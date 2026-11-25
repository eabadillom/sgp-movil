class EstatusRegistro 
{
  final String codigo;
  final String descripcion;

  EstatusRegistro({
    required this.codigo,
    required this.descripcion,
  });

  EstatusRegistro copyWith({
    String? codigo,
    String? descripcion,
  }) {
    return EstatusRegistro(
      codigo: codigo ?? this.codigo,
      descripcion:  descripcion ?? this.descripcion,
    );
  }
}