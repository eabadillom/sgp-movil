import 'package:sgp_movil/features/incapacidades/domain/entities/incapacidad_guardar_detalle.dart';

class IncapacidadGuardarDetalleMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => IncapacidadGuardarDetalle(
    idIncapacidad: json['idIncapacidad'], 
    idEmpleadoInc: json['idEmpleadoInc'], 
    idEmpleadoRev: json['idEmpleadoRev'], 
    tipoIncapacidad: json['tipoIncapacidad'], 
    controlIncapacidad: json['controlIncapacidad'], 
    riesgoTrabajo: json['riesgoTrabajo'], 
    tipoRiesgo: json['tipoRiesgo'], 
    folio: json['folio'], 
    diasAutorizados: json['diasAutorizados'], 
    fechaInicio: DateTime.parse(json['fechaInicio']), 
    descripcion: json['descripcion'], 
    estatusIncapacidad: json['estatusIncapacidad'],
  );
}