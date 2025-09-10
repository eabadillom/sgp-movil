import 'package:sgp_movil/features/login/domain/domain.dart';

class TokenMapper 
{

  static Token tokenJsonToEntity(Map<String,dynamic> json) => 
  Token(
    accessToken: json['access_token'],
    refreshToken: json['refresh_token']
  );

}
