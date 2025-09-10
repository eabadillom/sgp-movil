import 'package:sgp_movil/features/solicitudes/domain/entities/solicitudarticulo.dart';

class SolicitudArticuloMapper {
  static SolicitudArticulo jsonToEntity(Map<String, dynamic> json) =>
      SolicitudArticulo(
        id: json['id'],
        estatusSolicitud: json['estatusSolicitud'],
        fechaCaptura: DateTime.parse(json['fechaCaptura']),
        nombreSolicitante: json['nombreSolicitante'] ?? '',
        primerApSolicitante: json['primerApSolicitante'] ?? '',
        segundoApSolicitante: json['segundoApSolicitante'] ?? '',
        descripcion: json['descripcion'] ?? '',
        unidad: json['unidad'] ?? '',
        detalle: json['detalle'] ?? '',
        activo: json['activo'] ?? false,
        numeroRevisor: json['numeroRevisor'] ?? '',
        fechaModificacion:
            json['fechaModificacion'] != null
                ? DateTime.parse(json['fechaModificacion'])
                : null,
        descripcionRechazo: json['descripcionRechazo'] ?? '',
        rutaImagen: json['rutaImagen'] ?? '',
      );

  static entityToJson(Map<String, dynamic> json) => SolicitudArticulo(
    id: json['id'],
    estatusSolicitud: json['estatusSolicitud'],
    fechaCaptura: DateTime.parse(json['fechaCaptura']),
    nombreSolicitante: json['nombreSolicitante'],
    primerApSolicitante: json['primerApSolicitante'],
    segundoApSolicitante: json['segundoApSolicitante'],
    descripcion: json['descripcion'],
    unidad: json['unidad'],
    detalle: json['detalle'],
    activo: json['activo'],
    numeroRevisor: json['numeroRevisor'],
    fechaModificacion:
        json['fechaModificacion'] != null
            ? DateTime.parse(json['fechaModificacion'])
            : null,
    descripcionRechazo: json['descripcionRechazo'],
    rutaImagen: json['rutaImagen'],
  );
}
