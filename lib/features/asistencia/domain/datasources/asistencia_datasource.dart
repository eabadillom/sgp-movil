import 'package:sgp_movil/features/asistencia/domain/domain.dart';

abstract class AsistenciaDatasource 
{
  Future<List<Empleado>> obtenerEmpleados(DateTime fechaInicio, DateTime fechaFin, int? idPlanta, int? idEmpresa);
  Future<EmpleadoDetalle> obteneEmpleadoDetalle(DateTime fechaInicio, DateTime fechaFin, int idEmpleado);
  Future<List<EstatusRegistro>> obtenerEstatusRegistros();
}