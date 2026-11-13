import 'package:sgp_movil/features/login/domain/domain.dart';

class ControlMovilMapper 
{
  static ControlMovil jsonToEntity(Map<String, dynamic> json) => ControlMovil(
    id: json['id'],
    token: json['token'],
    expiracion: DateTime.parse(json['expiracion']),
    sistema: json['sistema'],
    valido: json['valido'],
  );
}
