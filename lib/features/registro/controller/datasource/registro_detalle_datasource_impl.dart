import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/registro/controller/controller.dart';

class RegistroDetalleDatasourceImpl extends RegistroDetalleDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('RegistroDetalleDatasourceImpl',);
  final String accessToken;

  RegistroDetalleDatasourceImpl({required this.accessToken});

  //registros/{id}/estatus
  @override
  Future<RegistroDetalle> actualizarRegistro(
    int id,
    Map<String, dynamic> registro,
  ) async {
    httpService.setAccessToken(accessToken);
    try {
      final String method = 'PATCH';
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      final String url = '$contexto/registros/$id/estatus';

      final response = await httpService.dio.request(
        url,
        data: registro,
        options: Options(method: method),
      );

      final reg = RegistroDetalleMapper.jsonToEntity(response.data);
      return reg;
    } on DioException catch (e) {
      log.logger.warning(
        'DioError: ${e.response?.statusCode} - ${e.response?.data}',
      );
      throw Exception('Error al actualizar registro');
    } catch (e) {
      log.logger.severe(e);
      throw Exception('Error inesperado');
    }
  }

  //registros/{id}/estatus
  @override
  Future<RegistroDetalle> registroDetalle(int id) async {
    httpService.setAccessToken(accessToken);
    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url = '$contexto/registros/$id/estatus';
      final response = await httpService.dio.get(url);
      final registro = RegistroDetalleMapper.jsonToEntity(response.data);
      return registro;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw NotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
