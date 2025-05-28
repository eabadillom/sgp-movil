import "../domain.dart";

abstract class IncapacidadDetalleRepository 
{
  Future<IncapacidadDetalle> getIncapacidad(int idIncapacidad);
}