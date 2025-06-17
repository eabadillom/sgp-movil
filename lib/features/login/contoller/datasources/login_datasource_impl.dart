import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/login/contoller/mappers/login_usuario_mapper.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';

class LoginDatasourceImpl extends LoginDatasource {
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'LoginDatasourceImpl',
  );

  @override
  Future<int> checkTokenStatus(String token) async {
    log.setupLoggin();
    final int status;
    try {
      httpService.setAccessToken(token);
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/verificar';
      final response = await httpService.dio.get(url);

      if (response.statusCode == 200) {
        log.logger.info('Token con salud');
        status = 200;
      } else {
        log.logger.info('Token expirado');
        status = -1;
      }

      //Token tokenOb = TokenMapper.tokenJsonToEntity(response.data);
      //log.logger.info('Token: $tokenOb');
      return status;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        log.logger.warning('Error 400: $e');
        throw CustomError(
          e.response?.data['message'] ?? 'Solicitud malformada',
        );
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Error 401: $e');
        throw CustomError('Token incorrecto, ingrese usuario/contraseña');
      }
      throw Exception();
    } catch (e) {
      if (e is SocketException) {
        log.logger.warning('Socket exception: ${e.toString()}');
        throw CustomError('No hay conexión a internet');
      } else if (e is TimeoutException) {
        log.logger.warning('Timeout exception: ${e.toString()}');
      }
      log.logger.warning('Error no controlado: ${e.toString()}');
      throw CustomError('Contacte a su administrador de sistemas');
      //throw Exception();
    }
  }

  @override
  Future<LoginUsuario> login(
    String numeroEmpleado,
    String nombre,
    String contrasenia,
  ) async {
    log.setupLoggin();
    try {
      httpService.setBasicAuth(nombre, contrasenia);
      //final response = await httpService.dio.get('/generar', data: {'numeroUsuario': numeroEmpleado});
      //final response = await httpService.dio.get('/generar', queryParameters: {'numeroEmpleado': numeroEmpleado});
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/generar';
      final response = await httpService.dio.request(
        url,
        data: {'numeroUsuario': numeroEmpleado},
        options: Options(method: 'GET'),
      );

      LoginUsuario loginUsuario = LoginUsuarioMapper.tokenJsonToEntity(
        response.data,
      );

      return loginUsuario;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        log.logger.warning('Error 401: $e');
        throw CustomError(
          e.response?.data['message'] ?? 'Credenciales incorrectas',
        );
      }

      if (e.response?.statusCode == 400) {
        log.logger.warning('Error 400: $e');
        throw CustomError(
          e.response?.data['message'] ?? 'Solicitud malformada',
        );
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        log.logger.warning('Error de conexcion de interner: $e');
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      log.logger.warning('Error de conexión de internet: $e');
      throw CustomError('Contacte a su administrador de sistemas');
      //throw Exception();
    }
  }
}
