import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/constants/environment.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/features/solicitudes/controller/mappers/solicitud_articulo_mapper.dart';
import 'package:sgp_movil/features/solicitudes/controller/mappers/solicitud_prenda_mapper.dart';
import 'package:sgp_movil/features/solicitudes/domain/datasources/solicitud_datasource.dart';

class SolicicitudDatasourceImpl extends SolicitudDatasource {
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'SolicicitudDatasourceImpl',
  );

  final DioClient httpService = DioClient();
  final String accessToken;

  SolicicitudDatasourceImpl({required this.accessToken});

  @override
  Future<dynamic> obtenerSolicitud(String tipo, int id) async {
    String contexto = Environment.obtenerUrlPorNombre('Movil');
    httpService.setAccessToken(accessToken);

    try {
      String url = '$contexto/solicitudes/$id/estatus';
      final response = await httpService.dio.get<dynamic>(url);

      switch (tipo) {
        case "A":
          return SolicitudArticuloMapper.jsonToEntity(response.data);
        case "PR":
          return SolicitudPrendaMapper.jsonToEntity(response.data);
        default:
          throw Exception("Tipo de solicitud no reconocido.");
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      // El backend solo envía texto plano, así que lo tomamos directamente
      String mensajeError;
      if (data is String) {
        mensajeError = data;
      } else {
        mensajeError = "Error desconocido del servidor.";
      }

      log.logger.warning('Error ($statusCode): $mensajeError');
      throw Exception(mensajeError); // ← Lanza el mensaje tal cual
    } catch (e) {
      log.logger.severe(e);
      throw Exception("Error inesperado. Contacte con el administrador.");
    }
  }
}
