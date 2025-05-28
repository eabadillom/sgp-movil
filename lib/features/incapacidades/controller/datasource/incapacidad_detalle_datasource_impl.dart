import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/features/incapacidades/controller/mappers/incapacidad_detalle_mapper.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class IncapacidadDetalleDatasourceImpl extends IncapacidadDetalleDatasource
{
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDatasourceImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  IncapacidadDetalleDatasourceImpl({required this.accessToken});

  @override
  Future<IncapacidadDetalle> getIncapacidad(int idIncapacidad) async
  {
    httpService.setAccessToken(accessToken);
    
    try {
      String url = '/incapacidad/$idIncapacidad';

      final response = await httpService.dio.get(url);
      
      final incapacidad = IncapacidadDetalleMapper.jsonToEntity(response.data);

      return incapacidad;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

}