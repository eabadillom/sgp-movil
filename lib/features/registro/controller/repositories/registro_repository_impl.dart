import 'package:sgp_movil/features/registro/domain/domain.dart';

class RegistroRepositoryImpl extends RegistroRepository
{
  final RegistroDatasource datasource;

  RegistroRepositoryImpl(this.datasource);

  @override
  Future<List<Registro>> getRegistro(DateTime fechaIni, DateTime fechaFin, String codigo) 
  {
    return datasource.getRegistro(fechaIni, fechaFin, codigo);
  }

}
