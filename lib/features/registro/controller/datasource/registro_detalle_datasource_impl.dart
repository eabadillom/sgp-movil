import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/registro/controller/controller.dart';

class RegistroDetalleDatasourceImpl extends RegistroDetalleDatasource
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('RegistroDetalleDatasourceImpl');
  final String accessToken;

  RegistroDetalleDatasourceImpl({
    required this.accessToken,
  });
  
  //registros/{id}/estatus
  @override
  Future<RegistroDetalle> actualizarRegistro(int id, Map<String, dynamic> registro) async
  {
    httpService.setAccessToken(accessToken);
    try 
    {
      final String method = 'PATCH';
      final String url = 'registros/{$id}/estatus';

      final response = await httpService.dio.request(url, data: registro, options: Options(method: method));

      final reg = RegistroDetalleMapper.jsonToEntity(response.data);

      return reg;
    }catch (e) 
    {
      throw Exception();
    }
  }

  //registros/{id}/estatus
  @override
  Future<RegistroDetalle> registroDetalle(int id) async
  {
    httpService.setAccessToken(accessToken);
    try 
    {
      String ruta = '/registros/$id/estatus';
      final response = await httpService.dio.get(ruta);
      final registro = RegistroDetalleMapper.jsonToEntity(response.data);
      return registro;
    }on DioException catch (e) 
    {
      if(e.response!.statusCode == 404) throw NotFound();
      throw Exception();
    }catch (e) {
      throw Exception();
    }
  }

}
