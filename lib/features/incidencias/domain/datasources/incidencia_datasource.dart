import "../entities/incidencia.dart";

abstract class IncidenciaDatasource {
  Future<List<Incidencia>> getIncidencias(
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
