import '../entities/incidencia.dart';

abstract class IncidenciaRepository {
  Future<List<Incidencia>> getInicidencias(
    String tipo,
    DateTime fechaInicial,
    DateTime fechaFinal,
  );

  Future<dynamic> actualizarIncidencia(
    String baseUrl,
    int id,
    Map<String, dynamic> incidencia,
  );
}
