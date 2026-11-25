import 'package:sgp_movil/features/asistencia/domain/domain.dart';

class AsistenciaRepositoryImpl extends AsistenciaRepository
{
  final AsistenciaDatasource datasource;

  AsistenciaRepositoryImpl(this.datasource);

  @override
  Future<List<Empleado>> obtenerEmpleados(DateTime fechaInicio, DateTime fechaFin, int? idPlanta, int? idEmpresa) 
  {
    return datasource.obtenerEmpleados(fechaInicio, fechaFin, idPlanta, idEmpresa);
  }

  @override
  Future<EmpleadoDetalle> obteneEmpleadoDetalle(DateTime fechaInicio, DateTime fechaFin, int idEmpleado) 
  {
    return datasource.obteneEmpleadoDetalle(fechaInicio, fechaFin, idEmpleado);
  }

  @override
  Future<List<EstatusRegistro>> obtenerEstatusRegistros() 
  {
    return datasource.obtenerEstatusRegistros();
  }

}
