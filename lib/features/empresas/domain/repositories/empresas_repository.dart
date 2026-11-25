import 'package:sgp_movil/features/empresas/domain/domain.dart';

abstract class EmpresasRepository 
{
  Future<List<Empresa>> obtenerEmpresas();
}
