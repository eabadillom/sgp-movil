import 'package:sgp_movil/features/incapacidades/domain/entities/control_incapacidad.dart';

class ControlIncapacidadMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => ControlIncapacidad(
    idControlIncapacidad: json['idControlIncapacidad'], 
    clave: json['clave'], 
    descripcion: json['descripcion'],
  );
}