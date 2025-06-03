import 'package:decimal/decimal.dart';
import 'package:sgp_movil/features/solicitudes/domain/entitties/solicitudbase.dart';

class SolicitudPrenda extends SolicitudBase {
  final String descripcion;
  final Decimal precio;
  final String detalle;
  final bool activo;
  final String talla;

  SolicitudPrenda({
    required int id,
    required String estatusSolicitud,
    required DateTime fechaCaptura,
    DateTime? fechaModificacion,
    String? numeroRevisor,
    String? descripcionRechazo,
    String? rutaImagen,
    required String nombreSolicitante,
    required String primerApSolicitante,
    required String segundoApSolicitante,
    required this.descripcion,
    required this.precio,
    required this.detalle,
    required this.activo,
    required this.talla,
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
       );

  factory SolicitudPrenda.fromJson(Map<String, dynamic> json) {
    return SolicitudPrenda(
      // Campos de la clase base
      id: json['id'] as int,
      estatusSolicitud: json['estatusSolicitud'] as String,
      fechaCaptura: DateTime.parse(json['fechaCaptura']),
      fechaModificacion:
          json['fechaModificacion'] != null
              ? DateTime.parse(json['fechaModificacion'])
              : null,
      numeroRevisor:
          json['numeroRevisor'] != null
              ? json['numeroRevisor'] as String?
              : null,
      descripcionRechazo:
          json['descripcionRechazo'] != null
              ? json['descripcionRechazo'] as String?
              : null,
      rutaImagen:
          json['rutaImagen'] != null ? json['rutaImagen'] as String : null,
      nombreSolicitante: json['nombreSolicitante'] as String,
      primerApSolicitante: json['primerApSolicitante'] as String,
      segundoApSolicitante: json['segundoApSolicitante'] as String,

      // Campos propios de SolicitudPrenda
      descripcion: json['descripcion'] as String,
      precio: Decimal.parse(json['precio'].toString()),
      detalle: json['detalle'] as String,
      activo: json['activo'] as bool,
      talla: json['talla'] as String,
    );
  }
}
