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

}