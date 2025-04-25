import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/registro/controller/controller.dart';

class RegistroDatasourceImpl extends RegistroDatasource 
{
  final DioClient httpService = DioClient();
  final String accessToken;

  RegistroDatasourceImpl({
    required this.accessToken,
  });

  @override
  Future<List<Registro>> getRegistro(DateTime fechaIni, String codigo) async
  {
    httpService.setAccessToken(accessToken);

    final response = await httpService.dio.get<List>('/registros/{$fechaIni}/{$codigo}');
    
    final List<RegistroDetalle> registros = [];

    for (final registro in response.data ?? [] ) {
      registros.add(RegistroMapper.jsonToEntity(registro));
    }
    
    return registros;
  }

}
