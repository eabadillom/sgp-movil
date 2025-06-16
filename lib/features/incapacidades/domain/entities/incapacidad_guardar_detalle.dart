class IncapacidadGuardarDetalle 
{
  final int? idIncapacidad;
  final int idEmpleadoInc;
  final String idEmpleadoRev;
  final int tipoIncapacidad;
  final int controlIncapacidad;
  final int? riesgoTrabajo;
  final int? tipoRiesgo;
  final String folio;
  final int diasAutorizados;
  final DateTime fechaInicio;
  final String descripcion;
  final String? estatusIncapacidad;

  IncapacidadGuardarDetalle({
    this.idIncapacidad,
    required this.idEmpleadoInc,
    required this.idEmpleadoRev,
    required this.tipoIncapacidad,
    required this.controlIncapacidad,
    this.riesgoTrabajo,
    this.tipoRiesgo,
    required this.folio,
    required this.diasAutorizados,
    required this.fechaInicio,
    required this.descripcion,
    this.estatusIncapacidad,
  });

  Map<String, dynamic> toJson() => {
    'idEmpleadoInc': idEmpleadoInc,
    'idEmpleadoRev': idEmpleadoRev,
    'tipoIncapacidad': tipoIncapacidad,
    'controlIncapacidad': controlIncapacidad,
    'riesgoTrabajo': riesgoTrabajo,
    'tipoRiesgo': tipoRiesgo,
    'folio': folio,
    'diasAutorizados': diasAutorizados,
    'fechaInicio': fechaInicio.toIso8601String(),
    'descripcion': descripcion,
  };

}