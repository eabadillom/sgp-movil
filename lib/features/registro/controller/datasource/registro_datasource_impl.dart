import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/registro/controller/controller.dart';

class RegistroDatasourceImpl extends RegistroDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('RegistroDatasourceImpl'); 
  final DioClient httpService = DioClient(nameContext: 'Movil');
  final String accessToken;

  RegistroDatasourceImpl({
    required this.accessToken,
  });

  @override
  Future<List<Registro>> getRegistro(DateTime fechaIni, DateTime fechaFin, String codigo) async
  {
    httpService.setAccessToken(accessToken);
    try 
    {
      String fechaI = FormatUtil.stringToISO(fechaIni);
      String fechaF = FormatUtil.stringToISO(fechaFin);
      String url = '/registros/$fechaI/$fechaF/$codigo';

      final response = await httpService.dio.get<List>(url);
      
      final List<Registro> registros = [];
      for (final registro in response.data ?? []) 
      {
        registros.add(RegistroMapper.jsonToEntity(registro));
      }
      
      return registros;
    }catch (e) 
    {
      log.logger.info('Error: ${e.toString()}');
      throw Exception();
    }
  }

}
