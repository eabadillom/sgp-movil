import '../entities/incidencia.dart';

abstract class IncidenciaRepository {
  Future<List<Incidencia>> getInicidencias(
    String tipo,
    String estatus,
    String fechaInicial,
    String fechaFinal,
  );
}
