class Registro 
{
  final int id;
  final String codigoRegistro; 
  final String nombreEmpleado;
  final String primerApEmpleado;
  final String segundoApEmpleado;
  final DateTime fechaEntrada;

  Registro({
    required this.id,
    required this.codigoRegistro,
    required this.fechaEntrada,
    required this.nombreEmpleado,
    required this.primerApEmpleado,
    required this.segundoApEmpleado,
  });

  @override
  String toString() 
  {
    return 'registroEmpleado[nombreCompleado: $nombreEmpleado $primerApEmpleado $segundoApEmpleado, codigo: $codigoRegistro, fechaEntrada: $fechaEntrada]';
  }
  
}
