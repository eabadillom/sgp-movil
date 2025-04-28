import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/domain/entities/token.dart';
import 'package:sgp_movil/features/registro/domain/datasources/registro_datasource.dart';
import 'package:sgp_movil/features/registro/domain/entities/registro.dart';

/*final justificarDatasourceProvider = Provider<RegistroDatasource>((ref) 
{

});*/

class JustificarStatus
{
  final Registro? registro;
  final Token? token;
  final String errorMessage;

  JustificarStatus({
    required this.registro,
    required this.token,
    this.errorMessage = ''
  });

  JustificarStatus copyWith({
    Registro? registro,
    Token? token,
    String? errorMessage,
  })  => JustificarStatus(
    registro: registro,
    token: token,
    //errorMessage: errorMessage,
  );
}
