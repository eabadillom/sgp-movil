import "../domain.dart";

abstract class IncapacidadDetalleDatasource 
{
  Future<IncapacidadDetalle> getIncapacidad(int idIncapacidad);
}