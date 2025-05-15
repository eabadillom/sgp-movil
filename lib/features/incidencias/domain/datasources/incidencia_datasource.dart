import "../entities/incidencia.dart";

abstract class IncidenciaDatasource {
  Future<List<Incidencia>> getIncidencias(
    String tipo,
    String estatus,
    DateTime fechaInicial,
    DateTime fechaFinal,
  );
}
