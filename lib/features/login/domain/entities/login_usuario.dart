class LoginUsuario 
{
  final String numeroUsuario;
  final String nombreUsuario;
  final String primerApUsuario;
  final String segundoApUsuario;
  final String puesto;
  final String accessToken;
  final String refreshToken;

  LoginUsuario({
    required this.numeroUsuario, 
    required this.nombreUsuario, 
    required this.primerApUsuario, 
    required this.segundoApUsuario, 
    required this.puesto, 
    required this.accessToken, 
    required this.refreshToken
  });

  @override
  String toString() 
  {
    return 'Token[NumeroEmpleado: $numeroUsuario, NombreEmpleado: $nombreUsuario, PrimerApeEmpleado: $primerApUsuario, SegundoApeEmpleado: $segundoApUsuario, Puesto: $puesto, accesToken: $accessToken, refreshToken: $refreshToken]';
  }
}