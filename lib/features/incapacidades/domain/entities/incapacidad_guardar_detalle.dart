class IncapacidadGuardarDetalle 
{
  final int idIncapacidad;
  final int idEmpleadoInc;
  final int idEmpleadoRev;
  final int tipoIncapacidad;
  final int controlIncapacidad;
  final int? riesgoTrabajo;
  final int? tipoRiesgo;
  final String folio;
  final int diasAutorizados;
  final DateTime fechaInicio;
  final String descripcion;
  final int estatusIncapacidad;

  IncapacidadGuardarDetalle({
    required this.idIncapacidad,
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
    required this.estatusIncapacidad,
  });
}