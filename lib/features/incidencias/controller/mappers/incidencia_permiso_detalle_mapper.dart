import 'package:sgp_movil/features/incidencias/domain/domain.dart';

class IncidenciaPermisoDetalleMapper {
  static jsonToEntity(Map<String, dynamic> json) => IncidenciaPermisoDetalle(
    idSolicitud: json['idIncidencia'],
    claveEstatus: json['codigoEstado'],
    nombreEmpleado: json['nombreSolicitante'],
    primerApEmpleado: json['primerApSolicitante'],
    segundoApEmpleado: json['segundoApSolicitante'],
    fechaInicio: DateTime.parse(json['fechaInicio']),
    fechaFin:
        json['fechaFin'] != null ? DateTime.parse(json['fechaFin']) : null,
    descripcionRechazo: json['descripcionRechazo'] ?? '',
  );

  static IncidenciaPermisoDetalle incidenciaJsonToEntity(
    Map<String, dynamic> json,
  ) => IncidenciaPermisoDetalle(
    idSolicitud: json['idIncidencia'],
    claveEstatus: json['codigoEstado'],
    nombreEmpleado: json['nombreSolicitante'],
    primerApEmpleado: json['primerApSolicitante'],
    segundoApEmpleado: json['segundoApSolicitante'],
    fechaInicio: DateTime.parse(json['fechaInicio']),
    fechaFin:
        json['fechaFin'] != null ? DateTime.parse(json['fechaFin']) : null,
    descripcionRechazo: json['descripcionRechazo'] ?? '',
  );
}
