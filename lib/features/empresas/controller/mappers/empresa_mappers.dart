import 'package:sgp_movil/features/empresas/domain/domain.dart';

class EmpresaMappers 
{
  static Empresa jsonToEntity(Map<String, dynamic> json) => Empresa(
    id: json['id'] as int,
    descripcion: json['descripcion'] as String,
  );

}