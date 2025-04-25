import '../entities/registro.dart';

abstract class RegistroDatasource 
{
  Future<List<Registro>> getRegistro(DateTime fechaIni, String codigo);
}
