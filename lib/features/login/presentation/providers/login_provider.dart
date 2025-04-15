import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/shared/controller/services/key_value_storage_service.dart';
import 'package:sgp_movil/features/shared/controller/services/key_value_storage_service_impl.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) 
{
  final loginRepository = LoginRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return LoginNotifier(
    loginRepository: loginRepository,
    keyValueStorageService: keyValueStorageService
  );
});

class LoginNotifier extends StateNotifier<LoginState> 
{
  final LoginRepository loginRepository;
  final KeyValueStorageService keyValueStorageService;
  final LoggerSingleton log = LoggerSingleton.getInstance('LoginProvider'); 

  LoginNotifier({
    required this.loginRepository,
    required this.keyValueStorageService,
  }): super(LoginState()){checkLoginStatus();} 

  Future<void> loginUser(String nombre, String contrasenia) async 
  {
    await Future.delayed(const Duration(milliseconds: 500));
    log.setupLoggin();

    try 
    {
      final Usuario usuario = Usuario(nombre: nombre, contrasenia: contrasenia);
      log.logger.info('Usuario: $usuario');
      final token = await loginRepository.login(usuario.nombre, usuario.contrasenia);
      _setLoggedUser(token, usuario);

    } on CustomError catch (e)
    {
      log.logger.severe(e.message);
      logout(e.message);
    } catch (e)
    {
      log.logger.severe(e.toString());
      logout('Error no controlado');
    }
  }

  void checkLoginStatus() async 
  {
    log.setupLoggin();
    log.logger.info('Obteniendo nombre');
    final nombre = await keyValueStorageService.getValue<String>('nombre');
    log.logger.info('Obteniendo contrasenia');
    final contrasenia = await keyValueStorageService.getValue<String>('contrasenia');
    
    if(nombre == null || contrasenia == null)
    {
      log.logger.info('No hay usuario/contrasenia guardado en cache');
      state = state.copyWith(
        usuario: null,
        token: null,
        loginStatus: LoginStatus.notAuthenticated,
        errorMessage: 'No se encuentra guardado el usuario'
      );
      return logout();
    }
    
    try 
    {
      final Usuario usuario = Usuario(nombre: nombre, contrasenia: contrasenia);
      
      log.logger.info('Obteniendo token');
      final token = await loginRepository.login(usuario.nombre, usuario.contrasenia);
      await keyValueStorageService.setKeyValue('token', token.accessToken);

      state = state.copyWith
      (
        usuario: usuario,
        token: token,
        loginStatus: LoginStatus.authenticated,
        errorMessage: 'Usuario Authenticado'
      );

      _setLoggedUser(token, usuario);
    } catch (e) 
    {
      logout();
    }
  }

  void _setLoggedUser(Token token, Usuario usuario) async
  {
    log.setupLoggin();
    log.logger.info('Guardando token');
    await keyValueStorageService.setKeyValue('token', token.accessToken);
    log.logger.info('Guardando nombre');
    await keyValueStorageService.setKeyValue('nombre', usuario.nombre);
    log.logger.info('Guardando usuario');
    await keyValueStorageService.setKeyValue('contrasenia', usuario.contrasenia);

    log.logger.info('Usuario ingresado con credenciales validas');
    state = state.copyWith(
      usuario: usuario,
      token: token,
      loginStatus: LoginStatus.authenticated,
      errorMessage: ''
    );
  }

  Future<void> logout([String? errorMessage]) async 
  {
    await keyValueStorageService.removeKey('token');

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
