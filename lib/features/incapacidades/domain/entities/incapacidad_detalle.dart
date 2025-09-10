class IncapacidadDetalle 
{
  final int idIncapacidad;
  final String nombreInc;
  final String primerApInc;
  final String segundoApInc;
  final String tipoIncapacidad;
  final String controlIncapacidad;
  final String? riesgoTrabajo;
  final String? tipoRiesgo;
  final String folio;
  final int diasAutorizados;
  final String descripcion;
  final DateTime fechaIni;
  final DateTime fechaFin;
  final String estatusIncapacidad;

  IncapacidadDetalle({
    required this.idIncapacidad,
    required this.nombreInc,
    required this.primerApInc,
    required this.segundoApInc,
    required this.tipoIncapacidad,
    required this.controlIncapacidad,
    this.riesgoTrabajo,
    this.tipoRiesgo,
    required this.folio,
    required this.diasAutorizados,
    required this.descripcion,
    required this.fechaIni,
    required this.fechaFin,
    required this.estatusIncapacidad,
  });
}
