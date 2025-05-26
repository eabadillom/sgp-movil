import '../entities/registro_detalle.dart';

abstract class RegistroDetalleRepository 
{
  Future<RegistroDetalle> registroDetalle(int idRegistro);
  Future<RegistroDetalle> actualizarRegistro(int id, Map<String, dynamic> registro);
}
