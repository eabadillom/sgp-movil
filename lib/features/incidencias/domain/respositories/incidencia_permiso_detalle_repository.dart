import '../entities/incidencia_permiso_detalle.dart';

abstract class IncidenciaPermisoDetalleRepository 
{
  Future<IncidenciaPermisoDetalle> obtenerIncidenciaPermiso(int idIncidencia);
  Future<IncidenciaPermisoDetalle> actualizarIncidenciaPermiso(int idIncidencia, Map<String, dynamic> incidencia);
}