import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class IncapacidadDetalleRepositoryImpl extends IncapacidadDetalleRepository
{
  final IncapacidadDetalleDatasource datasource;

  IncapacidadDetalleRepositoryImpl(this.datasource);

  @override
  Future<IncapacidadDetalle> getIncapacidad(int idIncapacidad) 
  {
    return datasource.getIncapacidad(idIncapacidad);
  }

  @override
  Future<List<EmpleadoIncapacidad>> getEmpleados() 
  {
    return datasource.getEmpleados();
  }
  
  @override
  Future<List<TipoIncapacidad>> getTipoIncapacidad() 
  {
    return datasource.getTipoIncapacidad();
  }
  
  @override
  Future<IncapacidadGuardarDetalle> guardarIncapacidad(Map<String, dynamic> incapacidad) {
    return datasource.guardarIncapacidad(incapacidad);
  }

}