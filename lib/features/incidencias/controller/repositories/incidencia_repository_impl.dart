import 'package:sgp_movil/features/incidencias/domain/datasources/incidencia_datasource.dart';
import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';
import 'package:sgp_movil/features/incidencias/domain/respositories/incidencia_repository.dart';

class IncidenciaRepositoryImpl extends IncidenciaRepository {
  final IncidenciaDatasource datasource;

  IncidenciaRepositoryImpl(this.datasource);

  @override
  Future<List<Incidencia>> getInicidencias(
    String tipo,
    DateTime fechaInicial,
    DateTime fechaFinal,
  ) {
    return datasource.getIncidencias(tipo, fechaInicial, fechaFinal);
  }

  @override
  Future<dynamic> actualizarIncidencia(
    String baseUrl,
    int id,
    Map<String, dynamic> incidencia,
  ) {
    return datasource.actualizarIncidencia(baseUrl, id, incidencia);
  }
}
