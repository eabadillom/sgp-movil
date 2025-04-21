import 'package:sgp_movil/features/login/domain/domain.dart';

abstract class LoginDatasource 
{
  Future<Token> login(String nombre, String contrasenia);
  Future<int> checkTokenStatus(String token);
}