import 'package:sgp_movil/features/solicitudes/domain/entities/solicitudbase.dart';

class SolicitudArticulo extends SolicitudBase {
  final String descripcion;
  final String unidad;
  final String detalle;
  final bool activo;

  SolicitudArticulo({
    required int id,
    required String estatusSolicitud,
    required DateTime fechaCaptura,
    DateTime? fechaModificacion,
    String? numeroRevisor,
    String? descripcionRechazo,
    required String nombreSolicitante,
    required String primerApSolicitante,
    required String segundoApSolicitante,
    String? rutaImagen,
    required this.descripcion,
    required this.unidad,
    required this.detalle,
    required this.activo,
  }) : super(
         id: id,
         estatusSolicitud: estatusSolicitud,
         fechaCaptura: fechaCaptura,
         fechaModificacion: fechaModificacion,
         numeroRevisor: numeroRevisor,
         descripcionRechazo: descripcionRechazo,
         nombreSolicitante: nombreSolicitante,
         primerApSolicitante: primerApSolicitante,
         segundoApSolicitante: segundoApSolicitante,
         rutaImagen: rutaImagen,
       );

  factory SolicitudArticulo.fromJson(Map<String, dynamic> json) {
    return SolicitudArticulo(
      id: json['id'],
      estatusSolicitud: json['estatusSolicitud'],
      fechaCaptura: DateTime.parse(json['fechaCaptura']),
      fechaModificacion:
          json['fechaModificacion'] != null
              ? DateTime.parse(json['fechaModificacion'])
              : null,
      numeroRevisor:
          json['numeroRevisor'] != null
              ? json['numeroRevisor'] as String
              : null,
      descripcionRechazo:
          json['descripcionRechazo'] != null
              ? json['descripcionRechazo'] as String
              : null,
      nombreSolicitante: json['nombreSolicitante'],
      primerApSolicitante: json['primerApSolicitante'],
      segundoApSolicitante: json['segundoApSolicitante'],
      rutaImagen:
          json['rutaImagen'] != null ? json['rutaImagen'] as String : null,
      descripcion: json['descripcion'],
      unidad: json['unidad'],
      detalle: json['detalle'],
      activo: json['activo'],
    );
  }
}
