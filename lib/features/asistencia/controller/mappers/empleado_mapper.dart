import 'package:sgp_movil/features/asistencia/domain/domain.dart';

class EmpleadoMapper 
{
  static Empleado jsonToEntity(Map<String, dynamic> json) => Empleado(
    id: json['id'] as int,
    nombre: json['nombre'] as String,
    primerAp: json['primerAp'] as String,
    segundoAp: json['segundoAp'] as String
  );

}
