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
  Future<Token> checkTokenStatus(String token) async
  {
    log.setupLoggin();
    try 
    {
      httpService.setAccessToken(token);
      final response = await httpService.dio.get('/login/check-status-token');

      final tokenOb = TokenMapper.tokenJsonToEntity(response.data);
      return tokenOb;

    }on DioException catch (e) 
    {
      if(e.response?.statusCode == 401)
      {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) 
    {
      throw Exception();
    }
  }
  
  @override
  Future<Token> login(String nombre, String contrasenia) async
  {
    log.setupLoggin();
    try 
    {
      log.logger.info('Usuario: $nombre');
      log.logger.info('Contraseña: $contrasenia');
      httpService.setBasicAuth(nombre, contrasenia);
      final response = await httpService.dio.get('/inicio');

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
      throw Exception();
    }
  }

}
