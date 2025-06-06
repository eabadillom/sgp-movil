import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/features/incapacidades/controller/controller.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';

class IncapacidadDetalleDatasourceImpl extends IncapacidadDetalleDatasource
{
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDatasourceImpl');
  final DioClient httpService = DioClient(nameContext: 'Movil');
  final String accessToken;

  IncapacidadDetalleDatasourceImpl({required this.accessToken});

  @override
  Future<IncapacidadDetalle> getIncapacidad(int idIncapacidad) async
  {
    httpService.setAccessToken(accessToken);
    
    try {
      String url = '/incapacidad/$idIncapacidad';

      final response = await httpService.dio.get(url);
      
      final incapacidad = IncapacidadDetalleMapper.jsonToEntity(response.data);

      return incapacidad;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

  @override
  Future<IncapacidadDetalle> cancelarIncapacidad(String numeroUsuario, Map<String, dynamic> incapacidad) async
  {
    httpService.setAccessToken(accessToken);

    try {
      final String method = 'PATCH';
      String url = '/incapacidad/$numeroUsuario/cancelar';

      final response = await httpService.dio.request(url, data: incapacidad, options: Options(method: method));
      
      final inc = IncapacidadDetalleMapper.jsonToEntity(response.data);

      return inc;
    } on DioException catch (e) {
      if (e.response != null) {
        log.logger.warning('Código de estado: ${e.response?.statusCode}');
        log.logger.warning('Mensaje del backend: ${e.response?.data}');

        final mensaje = e.response?.data ?? 'Ocurrió un error inesperado, favor de contatar al administrador de sistemas';
        throw mensaje;
      } else{
        throw 'Error de conexión. Verifica tu internet.';
      }
    }
  }
  
  @override
  Future<List<EmpleadoIncapacidad>> getEmpleados() async
  {
    httpService.setAccessToken(accessToken);

    try {
      String url = '/incapacidad/empleados';

      final response = await httpService.dio.get(url);
      
      final List<EmpleadoIncapacidad> empleados = [];

      for (final empleado in response.data ?? []) 
      {
        empleados.add(EmpleadoMapper.jsonToEntity(empleado));
      }

      return empleados;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }
  
  @override
  Future<List<TipoIncapacidad>> getTipoIncapacidad() async
  {
    httpService.setAccessToken(accessToken);

    try {
      String url = '/incapacidad/tiposIncapacidades';
      final List<TipoIncapacidad> tiposIncapacidades = [];

      final response = await httpService.dio.get(url);      

      for (final tipoIncapacidad in response.data ?? []) 
      {
        tiposIncapacidades.add(TipoIncapacidadMapper.jsonToEntity(tipoIncapacidad));
      }

      return tiposIncapacidades;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

  @override
  Future<List<ControlIncapacidad>> getControlIncapacidad() async
  {
    httpService.setAccessToken(accessToken);
    
    try {
      String url = '/incapacidad/controlIncapacidades';
      final List<ControlIncapacidad> controlIncapacidades = [];

      final response = await httpService.dio.get(url);      

      for (final controlIncapacidad in response.data ?? []) 
      {
        controlIncapacidades.add(ControlIncapacidadMapper.jsonToEntity(controlIncapacidad));
      }

      return controlIncapacidades;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }
  
  @override
  Future<List<RiesgoTrabajo>> getRiesgoTrabajo() async
  {
    httpService.setAccessToken(accessToken);

    try {
      String url = '/incapacidad/riesgosTrabajos';
      final List<RiesgoTrabajo> riesgoTrabajo = [];

      final response = await httpService.dio.get(url);      

      for(final rsgTrabajo in response.data ?? []) 
      {
        riesgoTrabajo.add(RiesgoTrabajoMapper.jsonToEntity(rsgTrabajo));
      }

      return riesgoTrabajo;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }
  
  @override
  Future<List<TipoRiesgo>> getTipoRiesgo() async
  {
    httpService.setAccessToken(accessToken);

    try {
      String url = '/incapacidad/tiposRiesgos';
      final List<TipoRiesgo> tipoRiesgo = [];

      final response = await httpService.dio.get(url);      

      for (final tiposRiesgos in response.data ?? []) 
      {
        tipoRiesgo.add(TipoRiesgoMapper.jsonToEntity(tiposRiesgos));
      }

      return tipoRiesgo;
    }catch (e) {
      log.logger.warning(e.toString());
      throw Exception("Hubo algun problema al obtener la informacion");
    }
  }

  @override
  Future<IncapacidadGuardarDetalle> guardarIncapacidad(Map<String, dynamic> incapacidad) async
  {
    httpService.setAccessToken(accessToken);
    try {
      final String method = 'PATCH';
      final String url = '/incapacidad/guardar';

      final response = await httpService.dio.request(url, data: incapacidad, options: Options(method: method));

      final inc = IncapacidadGuardarDetalleMapper.jsonToEntity(response.data);

      return inc;
    } on DioException catch (e) {
      if (e.response != null) {
        log.logger.warning('Entre a incapacidad detalle datasource impl');

        final mensaje = e.response?.data ?? 'Ocurrió un error inesperado, favor de contactar al administrador de sistemas';
        throw RegistroNotFound(mensaje);
      } else{
        throw RegistroNotFound('Revisar conexión a internet');
      }
    } catch (e) 
    {
      throw Exception();
    }
  }

}