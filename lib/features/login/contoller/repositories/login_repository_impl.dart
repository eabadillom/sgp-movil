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
  Future<Token> login(String email, String password) 
  {
    return dataSource.login(email, password);
  }

}