import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';

class CambiarContraseniaDatasourceImpl extends CambiarContraseniaDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('CambiarContraseniaDatasourceImpl');
  final String accessToken;

  CambiarContraseniaDatasourceImpl({required this.accessToken});

  @override
  Future<ControlMovil> cambiarPalabra(String palabra) async 
  {
    log.setupLoggin();

    try {
      httpService.setAccessToken(accessToken);
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/autenticacion/cambiarPassword';

      final response = await httpService.dio.post(url, data: {'password': palabra});

      ControlMovil controlMovil = ControlMovilMapper.jsonToEntity(response.data);

      return controlMovil;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw CustomError("Tiempo de espera agotado");
      }

      if (e.type == DioExceptionType.unknown) {
        log.logger.warning('Error desconocido: $e');
        throw CustomError("Sin conexión a internet");
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Token invalido: $e');
        throw CustomError("Token proporcionado no es válido");
      }

      log.logger.warning('Error interno: $e');
      throw CustomError("Error interno del servidor");
    }
  }
}
