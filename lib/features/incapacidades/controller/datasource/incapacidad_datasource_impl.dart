import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/incapacidades/controller/controller.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class IncapacidadDatasourceImpl extends IncapacidadDatasource
{
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDatasourceImpl');
  final DioClient httpService = DioClient(nameContext: 'Movil');
  final String accessToken;

  IncapacidadDatasourceImpl({required this.accessToken});

  @override
  Future<List<Incapacidad>> getListIncapacidades(DateTime fechaInicial, DateTime fechaFinal) async
  {
    httpService.setAccessToken(accessToken);
    
    try {
      String fechaI = FormatUtil.stringToISO(fechaInicial);
      String fechaF = FormatUtil.stringToISO(fechaFinal);
      String url = '/incapacidades/$fechaI/$fechaF';

      final response = await httpService.dio.get<List>(url);

      final List<Incapacidad> incapacidades = [];

      for(final incapacidad in response.data ?? []){
        incapacidades.add(IncapacidadMapper.jsonToEntity(incapacidad));
      }

      return incapacidades;
    } catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

}