import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/features/incapacidades/controller/mappers/empleado_mapper.dart';
import 'package:sgp_movil/features/incapacidades/controller/mappers/incapacidad_detalle_mapper.dart';
import 'package:sgp_movil/features/incapacidades/controller/mappers/tipo_incapacidad_mapper.dart';
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
  Future<IncapacidadGuardarDetalle> guardarIncapacidad(Map<String, dynamic> incapacidad) 
  {
    throw UnimplementedError();
  }

}