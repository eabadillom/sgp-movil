import 'package:sgp_movil/features/empresas/domain/domain.dart';

class EmpresasRepositoryImpl extends EmpresasRepository
{
  final EmpresasDatasource datasource;

  EmpresasRepositoryImpl(this.datasource);

  @override
  Future<List<Empresa>> obtenerEmpresas() 
  {
    return datasource.obtenerEmpresas();
  }

}