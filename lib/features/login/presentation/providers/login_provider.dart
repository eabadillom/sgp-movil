import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/login/domain/entities/user_log_data.dart';
import 'package:sgp_movil/features/shared/shared.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) 
{
  final loginRepository = LoginRepositoryImpl();

  return LoginNotifier(loginRepository: loginRepository, ref: ref);
});

class LoginNotifier extends StateNotifier<LoginState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('LoginProvider'); 
  final storage = SecureStorageService();
  final LoginRepository loginRepository;
  final Ref ref;

  LoginNotifier({required this.loginRepository, required this.ref}): super(
    LoginState()){checkLoginStatus();
  } 

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
      final data = await obtenerDatosUsuario();
      
      if (data.hayTokens && !data.faltaInfo) {
        log.logger.info('Tokens válidos, re-autenticando usuario.');
        await _manejarTokens(data);  
      }

      if(!data.hayTokens && !data.faltaInfo) {
        log.logger.info('Tokens inválidos o no existen, realizando nuevo login.');
        await _nuevaSesion(data);
      }

      if(!data.hayTokens && data.faltaInfo){
        log.logger.info('No hay tokens ni usuario');
        return logout();
      }

    } on SocketException catch (e) {
      log.logger.warning('Error de conexión a internet: ${e.toString()}');
      logout('No hay conexión a internet');
    } on TimeoutException catch (e) {
      log.logger.warning('Error de tiempo de espera: ${e.toString()}');
      logout('No hay conexión a internet');
    } catch (e) {
      log.logger.severe('Error inesperado: $e');
      logout('Error: contacte a su administrador de sistemas');
    }
  }

  Future<void> _manejarTokens(UserLogData data) async 
  {
    final status = await loginRepository.checkTokenStatus(data.accessToken!);

    if(status == 200) 
    {
      final usuario = Usuario(numeroEmpleado: data.numeroEmpleado!, nombre: data.nombre!, contrasenia: data.contrasenia!);
      final tokenObj = Token(accessToken: data.accessToken!, refreshToken: data.refreshToken!);
      
      _configurarDetalleUsuario(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
      _setLoggedUser(tokenObj, usuario);
    }
  }

  Future<void> _nuevaSesion(UserLogData data) async 
  {
    final usuario = Usuario(numeroEmpleado: data.numeroEmpleado!, nombre: data.nombre!, contrasenia: data.contrasenia!);
    
    final loginUsuario = await loginRepository.login(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
    final tokenObj = Token(accessToken: loginUsuario.accessToken, refreshToken: loginUsuario.refreshToken,);

    await _configurarDetalleUsuario(usuario.numeroEmpleado, usuario.nombre, usuario.contrasenia);
    _setLoggedUser(tokenObj, usuario);
  }

  Future<void> _configurarDetalleUsuario(String numeroEmpleado, String nombre, String contrasenia) async 
  {
    final loginUsuario = await loginRepository.login(numeroEmpleado, nombre, contrasenia);
    final usuarioDetalle = UsuarioDetalle(
      numeroUsuario: loginUsuario.numeroUsuario,
      nombreUsuario: loginUsuario.nombreUsuario,
      primerApUsuario: loginUsuario.primerApUsuario,
      segundoApUsuario: loginUsuario.segundoApUsuario,
      puesto: loginUsuario.puesto,
    );
    ref.read(usuarioDetalleProvider.notifier).setUsuarioDetalle(usuarioDetalle);
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
    await storage.delete(key: 'numeroEmpleado');
    await storage.delete(key: 'nombre');
    await storage.delete(key: 'contrasenia');

    state = state.copyWith(
      loginStatus: LoginStatus.notAuthenticated,
      usuario: null,
      token: null,
      errorMessage: errorMessage
    );
  }

  Future<String> deshabilitar() async 
  {
    String mensaje = 'Sesión cerrada';
    try 
    {
      final data = await obtenerDatosUsuario();

      if(data.faltaInfo || !data.hayTokens)
      {
        log.logger.warning('Error al obtener datos de la sesión');
        return "Fallo al cerrar sesión";
      }

      mensaje = await loginRepository.deshabilitar(data.accessToken!);

      final Usuario usuario = Usuario(numeroEmpleado: data.numeroEmpleado!, nombre: data.nombre!, contrasenia: data.contrasenia!);
      final Token token = Token(accessToken: data.accessToken!, refreshToken: data.refreshToken!);
        
      if (mensaje.contains('Problema de red')) {
        log.logger.info('Red: $mensaje');
        state = state.copyWith(
          loginStatus: LoginStatus.authenticated,
          token: token,
          usuario: usuario,
          errorMessage: mensaje,
        );
        return mensaje;
      }

      logout();

      return mensaje;
    } catch (e) 
    {
      final String accessToken = await storage.read(key: 'token') ?? '';
      final String refreshToken = await storage.read(key: 'tokenRe') ?? '';

      final Token token = Token(accessToken: accessToken, refreshToken: refreshToken);

      state = state.copyWith(
        loginStatus: LoginStatus.authenticated,
        token: token,
        errorMessage: 'Fallo al cerrar sesión',
      );

      return "Fallo al cerrar sesión";
    }
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
