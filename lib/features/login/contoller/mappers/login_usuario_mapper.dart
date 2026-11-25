import 'package:sgp_movil/features/login/domain/domain.dart';
import 'package:sgp_movil/features/login/contoller/errors/login_errors.dart';

class LoginUsuarioMapper 
{
  static LoginUsuario tokenJsonToEntity(Map<String,dynamic> json) 
  {
    final accessToken = json['token'];
    final refreshToken = json['refreshToken'];
    if (accessToken is! String || accessToken.trim().isEmpty || refreshToken is! String || refreshToken.trim().isEmpty) {
      throw CustomError('El servidor no devolvió un token válido.');
    }

    return LoginUsuario(
      numeroUsuario: json['numeroUsuario'],
      nombreUsuario: json['nombreUsuario'],
      primerApUsuario: json['primerApUsuario'],
      segundoApUsuario: json['segundoApUsuario'],
      puesto: json['puesto'],
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}