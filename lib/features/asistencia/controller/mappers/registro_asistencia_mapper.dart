import 'package:sgp_movil/features/asistencia/domain/domain.dart';

class RegistroAsistenciaMapper 
{
  static RegistroAsistencia fromJson(Map<String, dynamic> json) 
  {
    return RegistroAsistencia(
      id: json['id'] as int,
      fechaEntrada: DateTime.parse(json['fechaEntrada']),
      codigoRegistro: json['codigoRegistro'] as String
    );
  }
  
}
