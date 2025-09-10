import 'package:decimal/decimal.dart';
import 'package:sgp_movil/features/solicitudes/domain/entities/solicitudprenda.dart';

class SolicitudPrendaMapper {
  static SolicitudPrenda jsonToEntity(Map<String, dynamic> json) =>
      SolicitudPrenda(
        id: json['id'],
        estatusSolicitud: json['estatusSolicitud'],
        fechaCaptura: DateTime.parse(json['fechaCaptura']),
        nombreSolicitante: json['nombreSolicitante'] ?? '',
        primerApSolicitante: json['primerApSolicitante'] ?? '',
        segundoApSolicitante: json['segundoApSolicitante'] ?? '',
        descripcion: json['descripcion'] ?? '',
        precio: _parseDecimal(json['precio']),
        detalle: json['detalle'] ?? '',
        activo: json['activo'] ?? false,
        talla: json['talla'] ?? '',
        numeroRevisor: json['numeroRevisor'] ?? '',
        fechaModificacion:
            json['fechaModificacion'] != null
                ? DateTime.parse(json['fechaModificacion'])
                : null,
        descripcionRechazo: json['descripcionRechazo'],
        rutaImagen: json['rutaImagen'],
      );

  static Decimal _parseDecimal(dynamic value) {
    if (value == null) return Decimal.zero;
    if (value is num) return Decimal.parse(value.toString());
    if (value is String) return Decimal.tryParse(value) ?? Decimal.zero;
    return Decimal.zero;
  }

  static entityToJson(Map<String, dynamic> json) => SolicitudPrenda(
    id: json['id'],
    estatusSolicitud: json['estatusSolicitud'],
    fechaCaptura: json['fechaCaptura'],
    nombreSolicitante: json['nombreSolicitante'],
    primerApSolicitante: json['primerApSolicitante'],
    segundoApSolicitante: json['segundoApSolicitante'],
    descripcion: json['descripcion'],
    precio: json['precio'],
    detalle: json['detalle'],
    activo: json['activo'],
    talla: json['talla'],
    numeroRevisor: json['numeroRevisor'] ?? '',
    fechaModificacion:
        json['fechaModificacion'] != null
            ? DateTime.parse(json['fechaModificacion'])
            : null,
    descripcionRechazo: json['descripcionRechazo'] ?? '',
    rutaImagen: json['rutaImagen'],
  );
}
