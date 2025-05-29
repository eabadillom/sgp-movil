import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/incidencias/controller/controller.dart';
import 'package:sgp_movil/features/incidencias/domain/datasources/incidencia_datasource.dart';
import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';

class IncidenciaDatasourceImpl extends IncidenciaDatasource {
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'IncidenciaDatasourceImpl',
  );
  final DioClient httpService = DioClient(nameContext: 'Movil');
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
      String url = '/incidencias/$tipo/$fechaI/$fechaF';

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
}
