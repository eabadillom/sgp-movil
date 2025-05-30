import 'package:sgp_movil/features/incapacidades/domain/entities/riesgo_trabajo.dart';

class RiesgoTrabajoMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => RiesgoTrabajo(
    idRiesgoTrabajo: json['idSecRiesgoTrabajo'], 
    clave: json['clave'], 
    descripcion: json['descripcion'],
  );
}