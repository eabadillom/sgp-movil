import 'package:sgp_movil/features/solicitudes/domain/entitties/solicitudarticulo.dart';

class SolicitudArticuloMapper {
  static jsonToEntity(Map<String, dynamic> json) => SolicitudArticulo(
    id: json['id'],
    estatusSolicitud: json['estatusSolicitud'],
    fechaCaptura: json['fechaCaptura'],
    nombreSolicitante: json['nombreSolicitante'],
    primerApSolicitante: json['primerApSolicitante'],
    segundoApSolicitante: json['segundoApSolicitante'],
    descripcion: json['descripcion'],
    unidad: json['unidad'],
    detalle: json['detalle'],
    activo: json['activo'],
  );
}
