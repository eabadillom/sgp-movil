class IncidenciaPermisoDetalle 
{
  int idSolicitud;
  String nombreEmpleado;
  String primerApEmpleado;
  String segundoApEmpleado;
  DateTime fechaInicio;
  DateTime? fechaFin;
  String claveEstatus;
  String? descripcionRechazo;

  IncidenciaPermisoDetalle({
    required this.idSolicitud,
    required this.nombreEmpleado,
    required this.primerApEmpleado,
    required this.segundoApEmpleado,
    required this.fechaInicio,
    this.fechaFin,
    required this.claveEstatus,
    this.descripcionRechazo
  });

}