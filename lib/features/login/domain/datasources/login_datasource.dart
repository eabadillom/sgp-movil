import 'package:sgp_movil/features/login/domain/domain.dart';

abstract class LoginDatasource 
{
  Future<LoginUsuario> login(String numeroEmpleado, String nombre, String contrasenia);
  Future<int> checkTokenStatus(String token);
}