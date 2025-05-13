class Incidencia {
  final int idIncidencia;
  final String codigoEstadoIncidencia;
  final String codigoTipoIncidencia;
  final String nombreSolicitante;
  final String primerApSolicitante;
  final String segundoApSolicitante;
  final DateTime fechaCaptura;
  final int solicitudPermiso;
  final int solicitudPrenda;
  final int solicitudArticulo;

  Incidencia({
    required this.idIncidencia,
    required this.codigoEstadoIncidencia,
    required this.codigoTipoIncidencia,
    required this.nombreSolicitante,
    required this.primerApSolicitante,
    required this.segundoApSolicitante,
    required this.fechaCaptura,
    required this.solicitudArticulo,
    required this.solicitudPermiso,
    required this.solicitudPrenda,
  });

  @override
  String toString() {
    return 'incidencia[id: $idIncidencia, tipo: $codigoTipoIncidencia, estatus: $codigoEstadoIncidencia ,solicita: $nombreSolicitante $primerApSolicitante $segundoApSolicitante, fechaCaptura: $fechaCaptura';
  }
}
