import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';

class IncidenciaMapper {
  static Incidencia jsonToEntity(Map<String, dynamic> json) => Incidencia(
    idIncidencia: json['idIncidencia'] as int,
    codigoEstadoIncidencia: json['codigoEstadoIncidencia'] as String,
    codigoTipoIncidencia: json['codigoTipoIncidencia'] as String,
    nombreSolicitante: json['nombreSolicitante'] as String,
    primerApSolicitante: json['primerApSolicitante'] as String,
    segundoApSolicitante: json['segundoApSolicitante'] as String,
    numeroRevisor:
        json['numeroRevisor'] != null ? json['numeroRevisor'] as String : null,
    motivoRechazo:
        json['motivoRechazo'] != null ? json['motivoRechazo'] as String : null,
    fechaCaptura: DateTime.parse(json['fechaCaptura'] as String),
    solicitudArticulo:
        json['solicitudArticulo'] != null
            ? json['solicitudArticulo'] as int
            : null,
    solicitudPermiso:
        json['solicitudPermiso'] != null
            ? json['solicitudPermiso'] as int
            : null,
    solicitudPrenda:
        json['solicitudPrenda'] != null ? json['solicitudPrenda'] as int : null,
  );
}
