class ControlMovil 
{
  int? id;
  String? token;
  DateTime? expiracion;
  int? sistema;
  bool valido;

  ControlMovil({
    this.id,
    this.token,
    this.expiracion,
    this.sistema,
    this.valido = false,
  });
}
