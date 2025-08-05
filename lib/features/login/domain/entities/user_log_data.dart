import 'package:sgp_movil/features/shared/controller/services/secure_storage_service_impl.dart';

class UserLogData 
{
  final String? accessToken;
  final String? refreshToken;
  final String? numeroEmpleado;
  final String? nombre;
  final String? contrasenia;

  UserLogData({
    this.accessToken,
    this.refreshToken,
    this.numeroEmpleado,
    this.nombre,
    this.contrasenia,
  });

  bool get faltaInfo => numeroEmpleado == null || nombre == null || contrasenia == null;
  bool get hayTokens => accessToken != null && refreshToken != null;

  @override
  String toString() 
  {
    return '''StoredLoginData(
      accessToken: ${accessToken == null ? 'null' : '**********'},
      refreshToken: ${refreshToken == null ? 'null' : '**********'},
      numeroEmpleado: $numeroEmpleado,
      nombre: $nombre,
      contrasenia: ${contrasenia == null ? 'null' : '**********'}
    )''';
  }
}

/// Obtiene todos los datos del almacenamiento seguro.
Future<UserLogData> obtenerDatosUsuario() async 
{
  final storage = SecureStorageService();
  final accessToken = await storage.read(key: 'token');
  final tokenRe = await storage.read(key: 'tokenRe');
  final numeroEmpleado = await storage.read(key: 'numeroEmpleado');
  final nombre = await storage.read(key: 'nombre');
  final contrasenia = await storage.read(key: 'contrasenia');
  
  return UserLogData(
    accessToken: accessToken,
    refreshToken: tokenRe,
    numeroEmpleado: numeroEmpleado,
    nombre: nombre,
    contrasenia: contrasenia
  );
}
