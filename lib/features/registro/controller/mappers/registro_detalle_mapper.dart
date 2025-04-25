import 'package:sgp_movil/features/registro/domain/domain.dart';

class RegistroDetalleMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => RegistroDetalle
  (
    id: json['id'],
    codigoRegistro: json['codigoRegistro'],
    fechaEntrada: json['fechaEntrada'],
    fechaSalida: json['fechaEntrada'] ?? '',
    nombreEmpleado: json['nombreEmpleado'],
    primerApEmpleado: json['primerApEmpleado'],
    segundoApEmpleado: json['segundoApEmpleado'],
    plantaEmpleado: json['plantaEmpleado'],
  );

  static RegistroDetalle registroJsonToEntity(Map<String, dynamic> json) => RegistroDetalle(
    id: json['id'],
    codigoRegistro: json['codigoRegistro'],
    fechaEntrada: json['fechaEntrada'],
    fechaSalida: json['fechaEntrada'] ?? '',
    nombreEmpleado: json['nombreEmpleado'],
    primerApEmpleado: json['primerApEmpleado'],
    segundoApEmpleado: json['segundoApEmpleado'],
    plantaEmpleado: json['plantaEmpleado'],
  );
}