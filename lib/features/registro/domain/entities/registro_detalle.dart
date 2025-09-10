import 'package:sgp_movil/features/registro/domain/entities/registro.dart';

class RegistroDetalle extends Registro
{
  final DateTime? fechaSalida;
  final String plantaEmpleado;
  
  RegistroDetalle({
    required super.id, 
    required super.codigoRegistro, 
    required super.fechaEntrada,
    this.fechaSalida, 
    required super.nombreEmpleado, 
    required super.primerApEmpleado, 
    required super.segundoApEmpleado,
    required this.plantaEmpleado,
  });

  @override
  String toString() 
  {
    return 'registroEmpleado[nombreCompleado: $nombreEmpleado $primerApEmpleado $segundoApEmpleado, codigo: $codigoRegistro, fechaEntrada: $fechaEntrada, fechaSalida: ${fechaSalida ?? ""}]';
  }

}
