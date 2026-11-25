class Empleado 
{
  final int id;
  final String nombre;
  final String primerAp;
  final String segundoAp;

  Empleado({
    required this.id,
    required this.nombre,
    required this.primerAp,
    required this.segundoAp
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is Empleado && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}
