class SolicitudBase {
  final int id;
  final String estatusSolicitud;
  final DateTime fechaCaptura;
  final DateTime? fechaModificacion;
  final String? numeroRevisor;
  final String nombreSolicitante;
  final String primerApSolicitante;
  final String segundoApSolicitante;
  final String? descripcionRechazo;
  final String? rutaImagen;

  SolicitudBase({
    required this.id,
    required this.estatusSolicitud,
    required this.fechaCaptura,
    required this.nombreSolicitante,
    required this.primerApSolicitante,
    required this.segundoApSolicitante,
    this.fechaModificacion,
    this.descripcionRechazo,
    this.numeroRevisor,
    this.rutaImagen,
  });

  factory SolicitudBase.fromJson(Map<String, dynamic> json) {
    return SolicitudBase(
      id: json['id'] as int,
      estatusSolicitud: json['estatusSolicitud'] as String,
      fechaCaptura: DateTime.parse(json['fechaCaptura']),
      nombreSolicitante: json['nombreSolicitante'] as String,
      primerApSolicitante: json['primerApSolicitante'] as String,
      segundoApSolicitante: json['segundoApSolicitante'] as String,
      fechaModificacion:
          json['fechaModificacion'] != null
              ? DateTime.parse(json['fechaModificacion'])
              : null,
      descripcionRechazo:
          json['descripcionRechazo'] != null
              ? json['descripcionRechazo'] as String
              : null,
      numeroRevisor:
          json['numeroRevisor'] != null
              ? json['numeroRevisor'] as String
              : null,
      rutaImagen:
          json['rutaImagen'] != null ? json['rutaImagen'] as String : null,
    );
  }

  @override
  String toString() {
    return 'SolicitudBase[id: $id, estatus: $estatusSolicitud, fechaCaptura: $fechaCaptura, Solicitande: $nombreSolicitante  $primerApSolicitante $segundoApSolicitante, fechaModificacion: $fechaModificacion, numeroRevisor: $numeroRevisor]';
  }
}
