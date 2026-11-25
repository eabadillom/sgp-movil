import 'package:sgp_movil/features/empresas/domain/domain.dart';

abstract class EmpresasDatasource 
{
  Future<List<Empresa>> obtenerEmpresas();
}
