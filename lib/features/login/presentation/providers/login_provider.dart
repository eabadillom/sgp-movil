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
  final LoginRepositoryImpl loginRepository;
  final Ref ref;

  LoginNotifier({required this.loginRepository, required this.ref}) : super(LoginState()) {unawaited(checkLoginStatus());}

  Future<void> loginUser(String numeroEmpleado, String nombre, String contrasenia) async 
  {
    state = state.copyWith(errorMessage: '');
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
      await _setLoggedUser(token, usuario);
    } on CustomError catch (e) 
    {
      log.logger.severe(e.message);
      await logout(e.message);
    } catch (e) 
    {
      String errorMessage = 'Error, contacte a su administrador de sistemas';
      if (e is SocketException) {
        log.logger.warning('Socket exception: ${e.toString()}');
        errorMessage = 'No hay conexión a internet';
      } else if (e is TimeoutException) {
        log.logger.warning('Timeout exception: ${e.toString()}');
        errorMessage = 'No hay conexión a internet';
      } else if (e is ConnectionTimeout) {
        log.logger.warning('Connection exception: ${e.toString()}');
        errorMessage = 'No hay conexión a internet';
      } else if (e is Exception) {
        log.logger.warning('Exception: $e');
      }
      log.logger.severe('Error: ${e.toString()}');
      await logout(errorMessage);
    }
  }

  Future<void> checkLoginStatus() async 
  {
    log.setupLoggin();
    log.logger.info('Validando estatus');
    try 
    {
      final data = await obtenerDatosUsuario();

      if (data.faltaInfo) {
        log.logger.info('Información de usuario incompleta');
        final hayDatosGuardados = data.hayTokens || data.accessToken != null || data.refreshToken != null || data.numeroEmpleado != null || data.nombre != null || data.contrasenia != null;
        await logout(hayDatosGuardados ? 'La sesión guardada está incompleta. Inicia sesión nuevamente.' : null);
        return;
      }

      if (!data.hayTokens) 
      {
        log.logger.info('No se encontró un token de sesión');
        await logout('No se encontró un token de sesión. Inicia sesión nuevamente.');
        return;
      }

      log.logger.info('Validando token de sesión.');
      await _manejarTokens(data);
    } on CustomError catch (e) {
      log.logger.warning('Error al validar la sesión: ${e.message}');
      await logout(e.message);
    } on SocketException catch (e) {
      log.logger.warning('Error de conexión a internet: ${e.toString()}');
      await logout('No hay conexión a internet');
    } on TimeoutException catch (e) {
      log.logger.warning('Error de tiempo de espera: ${e.toString()}');
      await logout('No hay conexión a internet');
    } catch (e) {
      log.logger.severe('Error inesperado: $e');
      await logout('Error: contacte a su administrador de sistemas');
    }
  }

  Future<void> _manejarTokens(UserLogData data) async 
  {
    final accessToken = data.accessToken;
    final refreshToken = data.refreshToken;
    if (accessToken == null || accessToken.trim().isEmpty || refreshToken == null || refreshToken.trim().isEmpty) 
    {
      await logout('El token de sesión está incompleto. Inicia sesión nuevamente.');
      return;
    }

    final status = await loginRepository.checkTokenStatus(accessToken);

    if (status != 200) 
    {
      await logout('La sesión expiró o el token no es válido. Inicia sesión nuevamente.');
      return;
    }

    final loginUsuario = await loginRepository.login(data.numeroEmpleado!, data.nombre!, data.contrasenia!);
    final usuario = Usuario(numeroEmpleado: data.numeroEmpleado!, nombre: data.nombre!, contrasenia: data.contrasenia!);
    final tokenObj = Token(accessToken: accessToken, refreshToken: refreshToken);

    _configurarDetalleUsuario(loginUsuario);
    await _setLoggedUser(tokenObj, usuario);
  }

  void _configurarDetalleUsuario(LoginUsuario loginUsuario) {
    final usuarioDetalle = UsuarioDetalle(
      numeroUsuario: loginUsuario.numeroUsuario,
      nombreUsuario: loginUsuario.nombreUsuario,
      primerApUsuario: loginUsuario.primerApUsuario,
      segundoApUsuario: loginUsuario.segundoApUsuario,
      puesto: loginUsuario.puesto,
    );
    ref.read(usuarioDetalleProvider.notifier).setUsuarioDetalle(usuarioDetalle);
  }

  Future<void> _setLoggedUser(Token token, Usuario usuario) async 
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
      errorMessage: '',
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
      clearUsuario: true,
      clearToken: true,
      errorMessage: errorMessage ?? '',
    );
  }

  Future<String> deshabilitar() async 
  {
    String mensaje = 'Sesión cerrada';
    try 
    {
      final data = await obtenerDatosUsuario();

      if (data.faltaInfo || !data.hayTokens) {
        log.logger.warning('Error al obtener datos de la sesión');
        return "Fallo al cerrar sesión";
      }

      mensaje = await loginRepository.deshabilitar(data.accessToken!);

      final Usuario usuario = Usuario(numeroEmpleado: data.numeroEmpleado!, nombre: data.nombre!, contrasenia: data.contrasenia!);
      final Token token = Token(accessToken: data.accessToken!, refreshToken: data.refreshToken!);

      if (mensaje.contains('Problema de red')) 
      {
        log.logger.info('Red: $mensaje');
        state = state.copyWith(
          loginStatus: LoginStatus.authenticated,
          token: token,
          usuario: usuario,
          errorMessage: mensaje,
        );
        return mensaje;
      }

      await logout();

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
    bool clearUsuario = false,
    bool clearToken = false,
  }) => LoginState(
    loginStatus: loginStatus ?? this.loginStatus,
    usuario: clearUsuario ? null : usuario ?? this.usuario,
    token: clearToken ? null : token ?? this.token,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
