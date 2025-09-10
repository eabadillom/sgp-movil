import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class EmpleadoMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => EmpleadoIncapacidad(
    idEmpleadoInc: json['idEmpleado'], 
    nombreEmpleado: json['nombre'], 
    primerApEmpleado: json['primerApEmpleado'], 
    segundoApEmpleado: json['segundoApEmpleado'],
  );
}