import 'package:sgp_movil/features/incapacidades/domain/entities/tipo_riesgo.dart';

class TipoRiesgoMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => TipoRiesgo(
    idTipoRiesgo: json['idTipoRiesgo'], 
    clave: json['clave'], 
    descripcion: json['descripcion'],
  );
}