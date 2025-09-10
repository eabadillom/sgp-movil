import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class IncapacidadDetalleMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => IncapacidadDetalle(
    idIncapacidad: json["idIncapacidad"],
    nombreInc: json["nombreInc"],
    primerApInc: json["primerApInc"],
    segundoApInc: json["segundoApInc"],
    tipoIncapacidad: json["tipoIncapacidad"] ?? '',
    controlIncapacidad: json["controlIncapacidad"] ?? '',
    riesgoTrabajo: json["riesgoTrabajo"] ?? '',
    tipoRiesgo: json["tipoRiesgo"] ?? '',
    folio: json["folio"],
    diasAutorizados: json["diasAutorizados"],
    descripcion: json["descripcion"],
    fechaIni: DateTime.parse(json["fechaIni"]),
    fechaFin: DateTime.parse(json["fechaFin"]),
    estatusIncapacidad: json["estatusIncapacidad"],
  );

  static Map<String, dynamic> toJson(IncapacidadDetalle entity) =>
  {
    "idIncapacidad": entity.idIncapacidad,
    "nombreInc": entity.nombreInc,
    "primerApInc": entity.primerApInc,
    "segundoApInc": entity.segundoApInc,
    "tipoIncapacidad": entity.tipoIncapacidad,
    "controlIncapacidad": entity.controlIncapacidad,
    "riesgoTrabajo": entity.riesgoTrabajo,
    "tipoRiesgo": entity.tipoRiesgo,
    "folio": entity.folio,
    "diasAutorizados": entity.diasAutorizados,
    "descripcion": entity.descripcion,
    "fechaIni": entity.fechaIni.toIso8601String(),
    "fechaFin": entity.fechaFin.toIso8601String(),
    "estatusIncapacidad": entity.estatusIncapacidad,
  };

}