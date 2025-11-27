import 'package:sgp_movil/features/incidencias/domain/domain.dart';

class IncidenciaPermisoDetalleMapper {
  static jsonToEntity(Map<String, dynamic> json) => IncidenciaPermisoDetalle(
    idSolicitud: json['idIncidencia'],
    claveEstatus: json['codigoEstado'],
    nombreEmpleado: json['nombreSolicitante'],
    primerApEmpleado: json['primerApSolicitante'],
    segundoApEmpleado: json['segundoApSolicitante'],
    periodo: (json['periodo'] as List<dynamic>?)?.map((d) => DateTime.parse(d)).toList() ?? [],
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
    periodo: (json['periodo'] as List<dynamic>?)?.map((d) => DateTime.parse(d)).toList() ?? [],
    descripcionRechazo: json['descripcionRechazo'] ?? '',
  );
}
