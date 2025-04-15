class Usuario 
{
  final String nombre;
  final String contrasenia;

  Usuario
  ({
    required this.nombre,
    required this.contrasenia,
  });

  @override
  String toString()
  {
    return 'Usuario[id: $nombre, contraseña: $contrasenia]';
  }

}
