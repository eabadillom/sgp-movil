import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/features/solicitudes/domain/datasources/solicitud_datasource.dart';

class SolicicitudDatasourceImpl extends SolicitudDatasource {
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'SolicicitudDatasourceImpl',
  );

  final DioClient httpService = DioClient(nameContext: 'Movil');
  final String accessToken;

  SolicicitudDatasourceImpl({required this.accessToken});

  @override
  Future<dynamic> obtenerSolicitud(String tipo, int id) async {
    httpService.setAccessToken(accessToken);

    try {
      String url = '/solicitudes/$tipo/$id';

      final response = await httpService.dio.get<dynamic>(url);

      switch (tipo) {
        case "A":
          break;

        case "PR":
          break;
      }
    } catch (e) {}
  }
}
