class Usuario 
{
  final String numeroEmpleado;
  final String nombre;
  final String contrasenia;

  Usuario
  ({
    required this.numeroEmpleado,
    required this.nombre,
    required this.contrasenia,
  });

  @override
  String toString()
  {
    return 'Usuario[NumeroEmpleado: $numeroEmpleado, Nombre: $nombre, Contraseña: $contrasenia]';
  }

}
