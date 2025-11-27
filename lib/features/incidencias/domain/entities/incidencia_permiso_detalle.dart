class IncidenciaPermisoDetalle 
{
  int idSolicitud;
  String nombreEmpleado;
  String primerApEmpleado;
  String segundoApEmpleado;
  List<DateTime> periodo;
  String claveEstatus;
  String? descripcionRechazo;

  IncidenciaPermisoDetalle({
    required this.idSolicitud,
    required this.nombreEmpleado,
    required this.primerApEmpleado,
    required this.segundoApEmpleado,
    required this.periodo,
    required this.claveEstatus,
    this.descripcionRechazo
  });

}