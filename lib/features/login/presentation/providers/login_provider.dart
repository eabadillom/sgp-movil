import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/shared/shared.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) 
{
  final loginRepository = LoginRepositoryImpl();

  return LoginNotifier(
    loginRepository: loginRepository,
    ref: ref,
  );
});

class LoginNotifier extends StateNotifier<LoginState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('LoginProvider'); 
  final storage = SecureStorageService();
  final LoginRepository loginRepository;
  final Ref ref;

  LoginNotifier({
    required this.loginRepository,
    required this.ref,
  }): super(LoginState()){checkLoginStatus();} 

  Future<void> loginUser(String numeroEmpleado, String nombre, String contrasenia) async 
  {
    await Future.delayed(const Duration(milliseconds: 500));
    log.setupLoggin();

    try 
    {
      log.logger.info('Inicio Sesion');
      final Usuario usuario = Usuario(numeroEmpleado: numeroEmpleado, nombre: nombre, contrasenia: contrasenia);
      final LoginUsuario loginUsuario = await loginRepository.login(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
      final Token token = Token(accessToken: loginUsuario.accessToken, refreshToken: loginUsuario.refreshToken);
      final UsuarioDetalle usuarioDetalle = UsuarioDetalle(numeroUsuario: loginUsuario.numeroUsuario, nombreUsuario: loginUsuario.nombreUsuario, primerApUsuario: loginUsuario.primerApUsuario, segundoApUsuario: loginUsuario.segundoApUsuario, puesto: loginUsuario.puesto);
      ref.read(usuarioDetalleProvider.notifier).setUsuarioDetalle(usuarioDetalle);
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
      final token = await storage.read(key: 'token');
      final tokenRe = await storage.read(key: 'tokenRe');
      final numeroEmpleado = await storage.read(key: 'numeroEmpleado');
      final nombre = await storage.read(key: 'nombre');
      final contrasenia = await storage.read(key: 'contrasenia');
      
      if(token != null && tokenRe != null)
      {
        int status = await loginRepository.checkTokenStatus(token);

        if(status == 200)
        {
          final Token tokenObj = Token(accessToken: token, refreshToken: tokenRe);
          if(nombre != null && contrasenia != null && numeroEmpleado != null) 
          {  
            final Usuario usuario = Usuario(numeroEmpleado: numeroEmpleado, nombre: nombre, contrasenia: contrasenia);
            final LoginUsuario loginUsuario = await loginRepository.login(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
            final UsuarioDetalle usuarioDetalle = UsuarioDetalle(numeroUsuario: loginUsuario.numeroUsuario, nombreUsuario: loginUsuario.nombreUsuario, primerApUsuario: loginUsuario.primerApUsuario, segundoApUsuario: loginUsuario.segundoApUsuario, puesto: loginUsuario.puesto);
            ref.read(usuarioDetalleProvider.notifier).setUsuarioDetalle(usuarioDetalle);
            
            _setLoggedUser(tokenObj, usuario);
          }
        }
      }
    
      if(nombre == null || contrasenia == null || numeroEmpleado == null)
      {
        return logout();
      }

      final Usuario usuario = Usuario(numeroEmpleado: numeroEmpleado, nombre: nombre, contrasenia: contrasenia);
      final LoginUsuario loginUsuario = await loginRepository.login(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
      final Token tokenObj = Token(accessToken: loginUsuario.accessToken, refreshToken: loginUsuario.refreshToken);
      final UsuarioDetalle usuarioDetalle = UsuarioDetalle(numeroUsuario: loginUsuario.numeroUsuario, nombreUsuario: loginUsuario.nombreUsuario, primerApUsuario: loginUsuario.primerApUsuario, segundoApUsuario: loginUsuario.segundoApUsuario, puesto: loginUsuario.puesto);
      ref.read(usuarioDetalleProvider.notifier).setUsuarioDetalle(usuarioDetalle);
      
      await storage.write(key: 'token', value: tokenObj.accessToken);
      await storage.write(key: 'tokenRe', value: tokenObj.refreshToken);

      _setLoggedUser(tokenObj, usuario);
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
    await storage.write(key: 'token', value: token.accessToken);
    await storage.write(key: 'tokenRe', value: token.refreshToken);
    await storage.write(key: 'numeroEmpleado', value: usuario.numeroEmpleado);
    await storage.write(key: 'nombre', value: usuario.nombre);
    await storage.write(key: 'contrasenia', value: usuario.contrasenia);

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
    await storage.delete(key: 'token');
    await storage.delete(key: 'tokenRe');

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
