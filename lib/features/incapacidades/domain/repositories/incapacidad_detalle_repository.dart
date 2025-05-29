import "../domain.dart";

abstract class IncapacidadDetalleRepository 
{
  Future<IncapacidadDetalle> getIncapacidad(int idIncapacidad);
  Future<List<EmpleadoIncapacidad>> getEmpleados();
  Future<List<TipoIncapacidad>> getTipoIncapacidad();
  Future<IncapacidadGuardarDetalle> guardarIncapacidad(Map<String, dynamic> incapacidad);
}