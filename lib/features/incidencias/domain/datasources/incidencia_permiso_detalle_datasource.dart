import '../entities/incidencia_permiso_detalle.dart';

abstract class IncidenciaPermisoDetalleDatasource 
{
  Future<IncidenciaPermisoDetalle> obtenerIncidenciaPermiso(int idIncidencia);
  Future<IncidenciaPermisoDetalle> actualizarIncidenciaPermiso(int idIncidencia, Map<String, dynamic> incidencia);
}