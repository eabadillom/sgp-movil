import 'package:sgp_movil/features/registro/domain/domain.dart';

class RegistroDetalleRepositoryImpl extends RegistroDetalleRepository
{
  final RegistroDetalleDatasource datasource;

  RegistroDetalleRepositoryImpl(this.datasource);
  
  @override
  Future<RegistroDetalle> registroDetalle(int idRegistro) 
  {
    return datasource.registroDetalle(idRegistro);
  }
  
  @override
  Future<RegistroDetalle> actualizarRegistro(int id, Map<String, dynamic> registro) 
  {
    return datasource.actualizarRegistro(id, registro);
  }

}
