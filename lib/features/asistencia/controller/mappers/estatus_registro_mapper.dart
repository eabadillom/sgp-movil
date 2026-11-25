import 'package:sgp_movil/features/asistencia/domain/domain.dart';

class EstatusRegistroMapper 
{
  static EstatusRegistro fromJson(Map<String, dynamic> json) 
  {
    return EstatusRegistro(
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String
    );
  }
}
