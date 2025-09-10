import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class TipoIncapacidadMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => TipoIncapacidad(
    idTpIncapacidad: json['idTpIncapacidad'],
    clave: json['clave'],
    descripcion: json['descripcion'],
  );
}