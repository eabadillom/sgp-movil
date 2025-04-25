import '../entities/registro_detalle.dart';

abstract class RegistroDetalleDatasource 
{
  Future<RegistroDetalle> registroDetalle(int idRegistro);
  Future<RegistroDetalle> updateProduct(int id, Map<String, dynamic> registro);
}
