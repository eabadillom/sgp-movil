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

  factory Registro.fromJson(Map<String, dynamic> json) 
  {
    return Registro(
      id: json['id'],
      codigoRegistro: json['codigoRegistro'],
      nombreEmpleado: json['nombreEmpleado'],
      primerApEmpleado: json['primerApEmpleado'],
      segundoApEmpleado: json['segundoApEmpleado'],
      fechaEntrada: DateTime.parse(json['fechaEntrada']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigoRegistro': codigoRegistro,
      'nombreEmpleado': nombreEmpleado,
      'primerApEmpleado': primerApEmpleado,
      'segundoApEmpleado': segundoApEmpleado,
      'fechaEntrada': fechaEntrada.toIso8601String(),
    };
  }

  @override
  String toString() 
  {
    return 'registroEmpleado[nombreCompleado: $nombreEmpleado $primerApEmpleado $segundoApEmpleado, codigo: $codigoRegistro, fechaEntrada: $fechaEntrada]';
  }
  
}
