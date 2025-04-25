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
  Future<RegistroDetalle> updateProduct(int id, Map<String, dynamic> registro) 
  {
    return datasource.updateProduct(id, registro);
  }

}
