import "../entities/incidencia.dart";

abstract class IncidenciaDatasoutce {
  Future<List<Incidencia>> getIncidencias(
    String tipo,
    String estatus,
    String fechaInicial,
    String fechaFinal,
  );
}
