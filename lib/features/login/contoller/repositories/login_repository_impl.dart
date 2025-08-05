import 'package:sgp_movil/features/login/domain/domain.dart';
import '../controller.dart';

class LoginRepositoryImpl extends LoginRepository
{
  final LoginDatasource dataSource;

  LoginRepositoryImpl({
    LoginDatasource? dataSource
  }) : dataSource = dataSource ?? LoginDatasourceImpl();

  @override
  Future<int> checkTokenStatus(String token) 
  {
    return dataSource.checkTokenStatus(token);
  }

  @override
  Future<LoginUsuario> login(String numeroEmpleado, String nombre, String password) 
  {
    return dataSource.login(numeroEmpleado, nombre, password);
  }

  @override
  Future<String> deshabilitar(String token)
  {
    return dataSource.deshabilitar(token);
  }

}