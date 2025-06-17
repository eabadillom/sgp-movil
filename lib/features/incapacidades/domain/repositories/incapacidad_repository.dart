import "../domain.dart";

abstract class IncapacidadRepository 
{
  Future<List<Incapacidad>> getListIncapacidades(DateTime fechaInicial, DateTime fechaFinal);
}