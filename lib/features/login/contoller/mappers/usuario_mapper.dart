import 'package:sgp_movil/features/login/domain/domain.dart';

class UserMapper 
{

  static Usuario userJsonToEntity(Map<String,dynamic> json) => 
  Usuario(
    numeroEmpleado: json['numeroEmpleado'],
    nombre: json['nombre'],
    contrasenia: json['contrasenia'],
  );

}
