class UsuarioDetalle
{
  final String numeroUsuario;
  final String nombreUsuario;
  final String primerApUsuario;
  final String segundoApUsuario;
  final String puesto;

  UsuarioDetalle({
    required this.numeroUsuario,
    required this.nombreUsuario,
    required this.primerApUsuario,
    required this.segundoApUsuario,
    required this.puesto,
  });

  @override
  String toString() {
    return 'UsuarioDetalle[NumeroEmpleado: $numeroUsuario, NombreEmpleado: $nombreUsuario, PrimerApeEmpleado: $primerApUsuario, SegundoApeEmpleado: $segundoApUsuario, Puesto: $puesto]';
  }
}