import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';

class IncidenciaMapper {
  static jsonToEntity(Map<String, dynamic> json) => Incidencia(
    idIncidencia: json['idIncidencia'],
    codigoEstadoIncidencia: json['codigoEstadoIncidencia'],
    codigoTipoIncidencia: json['codigoTipoIncidencia'],
    nombreSolicitante: json['nombreSolicitante'],
    primerApSolicitante: json['primerApSolicitante'],
    segundoApSolicitante: json['segundoApSolicitante'],
    fechaCaptura: DateTime.parse(json['fechaCaptura']),
    solicitudArticulo: json['solicitudArticulo'],
    solicitudPermiso: json['solicitudPermiso'],
    solicitudPrenda: json['solicitudPrenda'],
  );
}
