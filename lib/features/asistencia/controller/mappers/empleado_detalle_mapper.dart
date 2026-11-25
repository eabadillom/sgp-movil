import 'package:sgp_movil/features/asistencia/controller/controller.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';

class EmpleadoDetalleMapper 
{
  static EmpleadoDetalle detalleFromJson(Map<String, dynamic> json) 
  {
    return EmpleadoDetalle (
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      primerAp: json['primerAp'] as String,
      segundoAp: json['segundoAp'] as String,
      registroAsistencia: _mapAsistencia(json['asistencia']),
    );
  }

  static List<RegistroAsistencia> _mapAsistencia(dynamic value) 
  {
    if (value == null || value is! List) {
      return [];
    }

    return value.whereType<Map<String, dynamic>>().map(RegistroAsistenciaMapper.fromJson).toList();
  }
}
