import 'package:sgp_movil/features/solicitudes/domain/datasources/solicitud_datasource.dart';
import 'package:sgp_movil/features/solicitudes/domain/repositories/solicitud_repository.dart';

class SolicitudRespositoryImpl extends SolicitudRepository {
  final SolicitudDatasource datasource;
  SolicitudRespositoryImpl(this.datasource);

  @override
  Future obtenerSolicitud(String tipo, int id) {
    return datasource.obtenerSolicitud(tipo, id);
  }
}
