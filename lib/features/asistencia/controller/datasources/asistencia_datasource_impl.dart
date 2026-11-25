import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/asistencia/controller/controller.dart';
import 'package:sgp_movil/features/asistencia/controller/mappers/estatus_registro_mapper.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';

class AsistenciaDatasourceImpl implements AsistenciaDatasource
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('PosicionesPlantaDatasourceImpl');
  final String accessToken;

  AsistenciaDatasourceImpl({required this.accessToken});

  @override
  Future<List<Empleado>> obtenerEmpleados(DateTime fechaInicio, DateTime fechaFin, int? idPlanta, int? idEmpresa) async
  {
    log.setupLoggin();
    httpService.setAccessToken(accessToken);

    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/incidencias/asistencia/empleados';

      final response = await httpService.dio.get<List>(url, queryParameters: {'fechaInicio': FormatUtil.stringToISO(fechaInicio), 'fechaFin': FormatUtil.stringToISO(fechaFin), 'idPlanta': idPlanta, 'idEmpresa': idEmpresa});
      
      List<Empleado> listEmpleados = [];

      for (final empleado in response.data ?? []) {
        listEmpleados.add(EmpleadoMapper.jsonToEntity(empleado));
      }

      return listEmpleados;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw CustomError("Tiempo de espera agotado");
      }

      if (e.type == DioExceptionType.unknown) {
        log.logger.warning('Error desconocido: $e');
        throw CustomError("Sin conexión a internet");
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Token invalido: $e');
        throw CustomError("Token proporcionado no es válido");
      }
      
      log.logger.warning('Error interno: $e');
      throw CustomError("Error interno del servidor");
    }
  }

  @override
  Future<EmpleadoDetalle> obteneEmpleadoDetalle(DateTime fechaInicio, DateTime fechaFin, int idEmpleado) async
  {
    log.setupLoggin();
    httpService.setAccessToken(accessToken);

    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/incidencias/empleado/obtenerDetalle';

      final response = await httpService.dio.get(url, queryParameters: {'fechaInicio': FormatUtil.stringToISO(fechaInicio), 'fechaFin': FormatUtil.stringToISO(fechaFin), 'idEmpleado': idEmpleado});
      
      EmpleadoDetalle empleado = EmpleadoDetalleMapper.detalleFromJson(response.data);

      return empleado;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw CustomError("Tiempo de espera agotado");
      }

      if (e.type == DioExceptionType.unknown) {
        log.logger.warning('Error desconocido: $e');
        throw CustomError("Sin conexión a internet");
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Token invalido: $e');
        throw CustomError("Token proporcionado no es válido");
      }
      
      log.logger.warning('Error interno: $e');
      throw CustomError("Error interno del servidor");
    }
  }

  @override
  Future<List<EstatusRegistro>> obtenerEstatusRegistros() async
  {
    log.setupLoggin();
    httpService.setAccessToken(accessToken);

    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/asistencia/estatus';

      final response = await httpService.dio.get(url);
      
      List<EstatusRegistro> listEstatusRegistro = [];
      
      for (final estatusRegistro in response.data ?? []) {
        listEstatusRegistro.add(EstatusRegistroMapper.fromJson(estatusRegistro));
      }

      return listEstatusRegistro;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw CustomError("Tiempo de espera agotado");
      }

      if (e.type == DioExceptionType.unknown) {
        log.logger.warning('Error desconocido: $e');
        throw CustomError("Sin conexión a internet");
      }

      if (e.response?.statusCode == 401) {
        log.logger.warning('Token invalido: $e');
        throw CustomError("Token proporcionado no es válido");
      }
      
      log.logger.warning('Error interno: $e');
      throw CustomError("Error interno del servidor");
    }
  }

}
