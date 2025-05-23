import "../entities/incidencia.dart";

abstract class IncidenciaDatasource {
  Future<List<Incidencia>> getIncidencias(
    String tipo,
    DateTime fechaInicial,
    DateTime fechaFinal,
  );
}
