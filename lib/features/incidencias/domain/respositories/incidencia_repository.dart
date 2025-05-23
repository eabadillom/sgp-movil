import '../entities/incidencia.dart';

abstract class IncidenciaRepository {
  Future<List<Incidencia>> getInicidencias(
    String tipo,
    DateTime fechaInicial,
    DateTime fechaFinal,
  );
}
