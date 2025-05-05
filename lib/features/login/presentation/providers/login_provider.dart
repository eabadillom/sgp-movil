import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/shared/controller/services/key_value_storage_service_impl.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) 
{
  final loginRepository = LoginRepositoryImpl();

  return LoginNotifier(
    loginRepository: loginRepository
  );
});

class LoginNotifier extends StateNotifier<LoginState> 
{
  final LoginRepository loginRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('LoginProvider'); 

  LoginNotifier({
    required this.loginRepository,
  }): super(LoginState()){checkLoginStatus();} 

  Future<void> loginUser(String nombre, String contrasenia) async 
  {
    await Future.delayed(const Duration(milliseconds: 500));
    log.setupLoggin();

    try 
    {
      log.logger.info('Inicio Sesion');
      final Usuario usuario = Usuario(nombre: nombre, contrasenia: contrasenia);
      final token = await loginRepository.login(usuario.nombre, usuario.contrasenia);
      _setLoggedUser(token, usuario);

    } on CustomError catch (e)
    {
      log.logger.severe(e.message);
      logout(e.message);
    } catch (e)
    {
      if(e is SocketException)
      {
        log.logger.warning('Socket exception: ${e.toString()}');
        logout('No hay conexión a internet');
      }else if(e is TimeoutException)
      {
        log.logger.warning('Timeout exception: ${e.toString()}');
        logout('No hay conexión a internet');
      }else if(e is ConnectionTimeout)
      {
        log.logger.warning('Connection exception: ${e.toString()}');
        logout('No hay conexión a internet');
      }
      else if(e is Exception)
      {
        log.logger.warning('Exception: $e');
        logout('No hay conexión a internet');
      }
      log.logger.severe('Error: ${e.toString()}');
      logout('Error, contacte a su administrador de sistemas');
    }
  }

  void checkLoginStatus() async 
  {
    log.setupLoggin();
    log.logger.info('Validando estatus');
    try 
    {
      final token = await KeyValueStorageServiceImpl.getValue<String>('token');
      final tokenRe = await KeyValueStorageServiceImpl.getValue<String>('tokenRe');
      final nombre = await KeyValueStorageServiceImpl.getValue<String>('nombre');
      final contrasenia = await KeyValueStorageServiceImpl.getValue<String>('contrasenia');
      
      if(token != null && tokenRe != null)
      {
        int status = await loginRepository.checkTokenStatus(token);

        if(status == 200)
        {
          Token tokenOb = Token(accessToken: token, refreshToken: tokenRe);
          if(nombre != null && contrasenia != null) 
          {  
            final Usuario usuario = Usuario(nombre: nombre, contrasenia: contrasenia);
            _setLoggedUser(tokenOb, usuario);
          }
        }
      }
    
      if(nombre == null || contrasenia == null)
      {
        return logout();
      }

      final Usuario usuario = Usuario(nombre: nombre, contrasenia: contrasenia);
      final Token tokenOb = await loginRepository.login(usuario.nombre, usuario.contrasenia);
      await KeyValueStorageServiceImpl.setKeyValue('token', tokenOb.accessToken);

      _setLoggedUser(tokenOb, usuario);
    } catch (e) 
    {
      if(e is SocketException)
      {
        log.logger.warning('Socket exception: ${e.toString()}');
        logout('No hay conexión a internet');
      }else if(e is TimeoutException)
      {
        log.logger.warning('Timeout exception: ${e.toString()}');
        logout('No hay conexión a internet');
      }else if(e is ConnectionTimeout)
      {
        log.logger.warning('Connection exception: ${e.toString()}');
        logout('No hay conexión a internet');
      }
      log.logger.warning('Error: $e');
      logout('Error: contacte a su administrador de sistemas');
    }
  }

  void _setLoggedUser(Token token, Usuario usuario) async
  {
    log.setupLoggin();
    await KeyValueStorageServiceImpl.setKeyValue('token', token.accessToken);
    await KeyValueStorageServiceImpl.setKeyValue('tokenRe', token.refreshToken);
    await KeyValueStorageServiceImpl.setKeyValue('nombre', usuario.nombre);
    await KeyValueStorageServiceImpl.setKeyValue('contrasenia', usuario.contrasenia);

    log.logger.info('Usuario ingresado correctamente');
    state = state.copyWith(
      usuario: usuario,
      token: token,
      loginStatus: LoginStatus.authenticated,
      errorMessage: ''
    );
  }

  Future<void> logout([String? errorMessage]) async 
  {
    await KeyValueStorageServiceImpl.removeKey('token');
    await KeyValueStorageServiceImpl.removeKey('tokenRe');

    state = state.copyWith(
      loginStatus: LoginStatus.notAuthenticated,
      usuario: null,
      errorMessage: errorMessage
    );
  }

}

enum LoginStatus {checking, authenticated, notAuthenticated}

class LoginState 
{
  final LoginStatus loginStatus;
  final Usuario? usuario;
  final Token? token;
  final String errorMessage;

  LoginState({
    this.loginStatus = LoginStatus.checking, 
    this.usuario,
    this.token,
    this.errorMessage = ''
  });

  LoginState copyWith({
    LoginStatus? loginStatus,
    Usuario? usuario,
    Token? token,
    String? errorMessage,
  }) => LoginState(
    loginStatus: loginStatus ?? this.loginStatus,
    usuario: usuario ?? this.usuario,
    token: token ?? this.token,
    errorMessage: errorMessage ?? this.errorMessage
  );

}
