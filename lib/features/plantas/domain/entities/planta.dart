class Planta
{
  final int id;
  final String descripcion;

  Planta({required this.id, required this.descripcion});

  @override
  bool operator ==(Object other) => identical(this, other) || other is Planta && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
  
}
