import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/incidencias/domain/domain.dart';
import 'package:sgp_movil/features/incidencias/controller/controller.dart';

class IncidenciaPermisoDetalleDatasourceImpl
    extends IncidenciaPermisoDetalleDatasource {
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'IncidenciaPermisoDetalleDatasourceImpl',
  );
  final String accessToken;

  IncidenciaPermisoDetalleDatasourceImpl({required this.accessToken});

  @override
  Future<IncidenciaPermisoDetalle> actualizarIncidenciaPermiso(
    int idIncidencia,
    Map<String, dynamic> incidencia,
  ) async {
    httpService.setAccessToken(accessToken);
    try {
      final String method = 'PATCH';
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      final String url = '$contexto/incidencias/$idIncidencia/estatus';
      final response = await httpService.dio.request(
        url,
        data: incidencia,
        options: Options(method: method),
      );
      final inc = IncidenciaPermisoDetalleMapper.jsonToEntity(response.data);
      return inc;
    } on DioException catch (e) {
      final data = e.response?.data;
      log.logger.warning(data);
      String resultado = ErroresHttp.obtenerMensajeError(e);
      throw Exception(resultado);
    } catch (e) {
      log.logger.severe(e);
      throw Exception('Error, Contacte al administrador de sistemas');
    }
  }

  @override
  Future<IncidenciaPermisoDetalle> obtenerIncidenciaPermiso(
    int idIncidencia,
  ) async {
    httpService.setAccessToken(accessToken);
    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/incidencia/$idIncidencia';
      final response = await httpService.dio.get(url);
      final incidencia = IncidenciaPermisoDetalleMapper.jsonToEntity(
        response.data,
      );
      return incidencia;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw NotFound();
      }
      log.logger.warning(
        'DioError: ${e.response?.statusCode} - ${e.response?.data}',
      );
      throw Exception('Error al obtener la incidencia detalle');
    } catch (e) {
      log.logger.severe(e);
      throw Exception('Error, Contacte al administrador de sistemas');
    }
  }
}
