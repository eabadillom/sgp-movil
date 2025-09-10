import 'package:sgp_movil/features/incidencias/domain/domain.dart';

class IncidenciaPermisoDetalleRepositoryImpl extends IncidenciaPermisoDetalleRepository
{
  final IncidenciaPermisoDetalleDatasource datasource;

  IncidenciaPermisoDetalleRepositoryImpl(this.datasource);

  @override
  Future<IncidenciaPermisoDetalle> obtenerIncidenciaPermiso(int idIncidencia) 
  {
    return datasource.obtenerIncidenciaPermiso(idIncidencia);
  }

  @override
  Future<IncidenciaPermisoDetalle> actualizarIncidenciaPermiso(int idIncidencia, Map<String, dynamic> incidencia) 
  {
    return datasource.actualizarIncidenciaPermiso(idIncidencia, incidencia);
  }

}