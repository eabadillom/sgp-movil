class Empresa
{
  final int id;
  final String descripcion;

  Empresa({required this.id, required this.descripcion});

  @override
  bool operator ==(Object other) => identical(this, other) || other is Empresa && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
  
}
