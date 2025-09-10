import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class IncapacidadMapper 
{
  static jsonToEntity(Map<String, dynamic> json) => Incapacidad(
    idIncapacidad: json['idIncapacidad'] as int,
    nombreInc: json['nombreInc'],
    primerApInc: json['primerApInc'],
    segundoApInc: json['segundoApInc'],
    descipcion: json['descipcion'],
    folio: json['folio'],
    clave: json['clave'],
    fechaCaptura: DateTime.parse(json['fechaCaptura']),
  );
  
}
