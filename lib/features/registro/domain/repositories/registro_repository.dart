import '../entities/registro.dart';

abstract class RegistroRepository 
{
  Future<List<Registro>> getRegistro(DateTime fechaIni, DateTime fechaFin, String codigo);
}
