class RegistroAsistencia 
{
  final int id;
  final DateTime fechaEntrada;
  final String codigoRegistro;

  RegistroAsistencia({
    required this.id,
    required this.fechaEntrada,
    required this.codigoRegistro,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegistroAsistencia && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
  
}