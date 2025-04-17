import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/login/contoller/mappers/token_mapper.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';
import '../controller.dart';

class LoginDatasourceImpl extends LoginDatasource
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('UserInstance');
  
  @override
  Future<int> checkTokenStatus(String token) async
  {
    log.setupLoggin();
    final int status;
    try 
    {
      httpService.setAccessToken(token);
      final response = await httpService.dio.get('/verificar');

      if(response.statusCode == 200)
      {
        log.logger.info('Token con salud');
        status = 200;
      }else{
        log.logger.info('Token expirado');
        status = -1;
      }

      //Token tokenOb = TokenMapper.tokenJsonToEntity(response.data);
      //log.logger.info('Token: $tokenOb');
      return status;
    }on DioException catch (e) 
    {
      if(e.response?.statusCode == 400)
      {
        log.logger.warning('Error 400: $e');
        throw CustomError(e.response?.data['message'] ?? 'Solicitud malformada');
      }

      if(e.response?.statusCode == 401)
      {
        log.logger.warning('Error 401: $e');
        throw CustomError('Token incorrecto, ingrese usuario/contraseña');
      }
      throw Exception();
    }catch (e) 
    {
      if(e is SocketException)
      {
        log.logger.warning('Socket exception: ${e.toString()}');
        throw CustomError('No hay conexión a internet');
      }else if(e is TimeoutException)
      {
        log.logger.warning('Timeout exception: ${e.toString()}');
      }
      log.logger.warning('Error no controlado: ${e.toString()}');
      throw CustomError('Contacte a su administrador de sistemas');
      //throw Exception();
    }
  }
  
  @override
  Future<Token> login(String nombre, String contrasenia) async
  {
    log.setupLoggin();
    try 
    {
      httpService.setBasicAuth(nombre, contrasenia);
      final response = await httpService.dio.get('/generar');

      Token token = TokenMapper.tokenJsonToEntity(response.data);
      return token;
    } on DioException catch (e) 
    {
      if(e.response?.statusCode == 401)
      {
        log.logger.warning('Error 401: $e');
        throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas');
      }

      if(e.response?.statusCode == 400)
      {
        log.logger.warning('Error 400: $e');
        throw CustomError(e.response?.data['message'] ?? 'Solicitud malformada');
      }

      if(e.type == DioExceptionType.connectionTimeout)
      {
        log.logger.warning('Error de conexcion de interner: $e');
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) 
    {
      log.logger.warning('Error de conexión de internet: $e');
      throw CustomError('Contacte a su administrador de sistemas');
      //throw Exception();
    }
  }

}
