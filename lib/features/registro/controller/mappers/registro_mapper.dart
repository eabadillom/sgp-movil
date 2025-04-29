import 'package:sgp_movil/features/registro/domain/domain.dart';

class RegistroMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => Registro
  (
    id: json['id'],
    codigoRegistro: json['codigoRegistro'],
    nombreEmpleado: json['nombreEmpleado'],
    primerApEmpleado: json['primerApEmpleado'],
    segundoApEmpleado: json['segundoApEmpleado'],
    fechaEntrada: DateTime.parse(json['fechaEntrada']),
  );
}