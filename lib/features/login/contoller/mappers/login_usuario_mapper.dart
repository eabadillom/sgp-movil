import 'package:sgp_movil/features/login/domain/domain.dart';

class LoginUsuarioMapper 
{
  static LoginUsuario tokenJsonToEntity(Map<String,dynamic> json) => 
  LoginUsuario(
    numeroUsuario: json['numeroUsuario'],
    nombreUsuario: json['nombreUsuario'],
    primerApUsuario: json['primerApUsuario'],
    segundoApUsuario: json['segundoApUsuario'],
    puesto: json['puesto'],
    accessToken: json['token'],
    refreshToken: json['refreshToken']
  );
}