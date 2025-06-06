import "../domain.dart";

abstract class IncapacidadDetalleDatasource 
{
  Future<IncapacidadDetalle> getIncapacidad(int idIncapacidad);
  Future<IncapacidadDetalle> cancelarIncapacidad(String numeroUsuario, Map<String, dynamic> incapacidad);
  Future<List<EmpleadoIncapacidad>> getEmpleados();
  Future<List<TipoIncapacidad>> getTipoIncapacidad();
  Future<List<ControlIncapacidad>> getControlIncapacidad();
  Future<List<RiesgoTrabajo>> getRiesgoTrabajo();
  Future<List<TipoRiesgo>> getTipoRiesgo();
  Future<IncapacidadGuardarDetalle> guardarIncapacidad(Map<String, dynamic> incapacidad);
}