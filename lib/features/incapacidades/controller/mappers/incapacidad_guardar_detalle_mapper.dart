import 'package:sgp_movil/features/incapacidades/domain/entities/incapacidad_guardar_detalle.dart';

class IncapacidadGuardarDetalleMapper 
{
  static IncapacidadGuardarDetalle jsonToEntity(Map<String, dynamic> json) 
  {
    return IncapacidadGuardarDetalle(
      idIncapacidad: json['idIncapacidad'] as int?,
      idEmpleadoInc: json['idEmpleadoInc'] as int,
      idEmpleadoRev: json['idEmpleadoRev'] as String,
      tipoIncapacidad: json['tipoIncapacidad'] as int,
      controlIncapacidad: json['controlIncapacidad'] as int,
      riesgoTrabajo: json['riesgoTrabajo'] as int?,
      tipoRiesgo: json['tipoRiesgo'] as int?,
      folio: json['folio'] as String,
      diasAutorizados: json['diasAutorizados'] ?? 0,
      fechaInicio: DateTime.tryParse(json['fechaInicio'] ?? '') ?? DateTime.now(),
      descripcion: json['descripcion'] ?? '',
      estatusIncapacidad: json['estatusIncapacidad'] as String,
    );
  }
}
