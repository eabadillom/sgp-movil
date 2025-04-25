import '../entities/registro.dart';

abstract class RegistroRepository 
{
  Future<List<Registro>> getRegistro(DateTime fechaIni, String codigo);
}
