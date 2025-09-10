import 'dart:convert';

Incapacidad incapacidadFromJson(String str) => Incapacidad.fromJson(json.decode(str));

String incapacidadToJson(Incapacidad data) => json.encode(data.toJson());

class Incapacidad 
{
  final int idIncapacidad;
  final String nombreInc;
  final String primerApInc;
  final String segundoApInc;
  final String descipcion;
  final String folio;
  final String clave;
  final DateTime fechaCaptura;

  Incapacidad({
    required this.idIncapacidad,
    required this.nombreInc,
    required this.primerApInc,
    required this.segundoApInc,
    required this.descipcion,
    required this.folio,
    required this.clave,
    required this.fechaCaptura,
  });

  factory Incapacidad.fromJson(Map<String, dynamic> json) => Incapacidad(
    idIncapacidad: json['idIncapacidad'],
    nombreInc: json['nombreInc'],
    primerApInc: json['primerApInc'],
    segundoApInc: json['segundoApInc'],
    descipcion: json['descipcion'],
    folio: json['folio'],
    clave: json['clave'],
    fechaCaptura: DateTime.parse(json['fechaCaptura']),
  );

  Map<String, dynamic> toJson() => {
    "idIncapacidad": idIncapacidad,
    "nombreInc": nombreInc,
    "primerApInc": primerApInc,
    "segundoApInc": segundoApInc,
    "descipcion": descipcion,
    "folio": folio,
    "clave": clave,
    "fechaCaptura": fechaCaptura.toIso8601String(),
  };

  @override
  String toString() {
    return 'Incapacidad[id: $idIncapacidad, nombre: $nombreInc, primerApellido: $primerApInc, segundoApellido: $segundoApInc, descripcion: $descipcion, folio: $folio, clave: $clave, fechaCaptura: $fechaCaptura]';
  }

}