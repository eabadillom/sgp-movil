import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/constants/environment.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/incidencias/controller/controller.dart';
import 'package:sgp_movil/features/incidencias/domain/datasources/incidencia_datasource.dart';
import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';
import 'package:sgp_movil/features/solicitudes/controller/mappers/solicitud_articulo_mapper.dart';
import 'package:sgp_movil/features/solicitudes/domain/domain.dart';

class IncidenciaDatasourceImpl extends IncidenciaDatasource {
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'IncidenciaDatasourceImpl',
  );
  final DioClient httpService = DioClient();
  final String accessToken;

  IncidenciaDatasourceImpl({required this.accessToken});

  @override
  Future<List<Incidencia>> getIncidencias(
    String tipo,
    DateTime fechaInicial,
    DateTime fechaFinal,
  ) async {
    httpService.setAccessToken(accessToken);

    try {
      String fechaI = FormatUtil.stringToISO(fechaInicial);
      String fechaF = FormatUtil.stringToISO(fechaFinal);
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/incidencias/$tipo/$fechaI/$fechaF';

      final response = await httpService.dio.get<List>(url);

      final List<Incidencia> incidencias = [];

      for (final incidencia in response.data ?? []) {
        incidencias.add(IncidenciaMapper.jsonToEntity(incidencia));
      }
      return incidencias;
    } catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

  @override
  Future<dynamic> actualizarIncidencia(
    String baseUrl,
    int id,
    Map<String, dynamic> incidencia,
  ) async {
    httpService.setAccessToken(accessToken);

    try {
      String url = '/$baseUrl/$id/estatus';
      final response = httpService.dio.patch(
        url,
        data: incidencia,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

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
