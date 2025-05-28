import "../domain.dart";

abstract class IncapacidadDatasource 
{
  Future<List<Incapacidad>> getListIncapacidades(DateTime fechaInicial, DateTime fechaFinal);
}
