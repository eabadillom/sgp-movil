import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/registro/controller/controller.dart';

class RegistroDatasourceImpl extends RegistroDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('RegistroDatasourceImpl'); 
  final DioClient httpService = DioClient();
  final String accessToken;

  RegistroDatasourceImpl({
    required this.accessToken,
  });

  @override
  Future<List<Registro>> getRegistro(DateTime fechaIni, String codigo) async
  {
    log.logger.info("Token: $accessToken");
    httpService.setAccessToken(accessToken);

    String fecha = FormatUtil.stringDateFormated(fechaIni);

    log.logger.info("Fecha: $fecha");
    log.logger.info("Codigo: $codigo");
    String url = '/registros/$fecha/$codigo';
    log.logger.info("URL: $url");

    final response = await httpService.dio.get<List>(url);
    
    final List<Registro> registros = [];
    for (final registro in response.data ?? []) 
    {
      registros.add(RegistroMapper.jsonToEntity(registro));
    }

    return registros;

    /*if(response.statusCode == 200) 
    {
      return (response.data as List)
        .map((json) => Registro.fromJson(json))
        .toList();
    } else {
      throw Exception('Error al obtener la lista');
    }*/
  }

}
