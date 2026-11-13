import 'package:sgp_movil/features/login/domain/domain.dart';
import '../controller.dart';

class LoginRepositoryImpl 
{
  final LoginDatasourceImpl dataSource;

  LoginRepositoryImpl({LoginDatasourceImpl? dataSource}) : dataSource = dataSource ?? LoginDatasourceImpl();

  Future<int> checkTokenStatus(String token) 
  {
    return dataSource.checkTokenStatus(token);
  }

  Future<LoginUsuario> login(String numeroEmpleado, String nombre, String password) 
  {
    return dataSource.login(numeroEmpleado, nombre, password);
  }

  Future<String> deshabilitar(String token)
  {
    return dataSource.deshabilitar(token);
  }

}