class Incidencia {
  final int idIncidencia;
  final String codigoEstadoIncidencia;
  final String codigoTipoIncidencia;
  final String nombreSolicitante;
  final String primerApSolicitante;
  final String segundoApSolicitante;
  final String? numeroRevisor;
  final String? motivoRechazo;
  final DateTime fechaCaptura;
  final int? solicitudPermiso;
  final int? solicitudPrenda;
  final int? solicitudArticulo;

  Incidencia({
    required this.idIncidencia,
    required this.codigoEstadoIncidencia,
    required this.codigoTipoIncidencia,
    required this.nombreSolicitante,
    required this.primerApSolicitante,
    required this.segundoApSolicitante,
    required this.numeroRevisor,
    required this.motivoRechazo,
    required this.fechaCaptura,
    this.solicitudPermiso,
    this.solicitudPrenda,
    this.solicitudArticulo,
  });

  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      idIncidencia: json['idIncidencia'] as int,
      codigoEstadoIncidencia: json['codigoEstadoIncidencia'] as String,
      codigoTipoIncidencia: json['codigoTipoIncidencia'] as String,
      nombreSolicitante: json['nombreSolicitante'] as String,

      primerApSolicitante: json['primerApSolicitante'] as String,
      segundoApSolicitante: json['segundoApSolicitante'] as String,
      numeroRevisor:
          json['numeroRevisor'] != null
              ? json['numeroRevisor'] as String
              : null,
      motivoRechazo:
          json['motivoRechazo'] != null
              ? json['motivoRechazo'] as String
              : null,
      fechaCaptura: DateTime.parse(json['fechaCaptura']),
      solicitudPermiso:
          json['solicitudPermiso'] != null
              ? json['solicitudPermiso'] as int
              : null,
      solicitudPrenda:
          json['solicitudPrenda'] != null
              ? json['solicitudPrenda'] as int
              : null,
      solicitudArticulo:
          json['solicitudArticulo'] != null
              ? json['solicitudArticulo'] as int
              : null,
    );
  }

  @override
  String toString() {
    return 'incidencia[id: $idIncidencia, tipo: $codigoTipoIncidencia, estatus: $codigoEstadoIncidencia ,solicita: $nombreSolicitante $primerApSolicitante $segundoApSolicitante, fechaCaptura: $fechaCaptura';
  }
}
