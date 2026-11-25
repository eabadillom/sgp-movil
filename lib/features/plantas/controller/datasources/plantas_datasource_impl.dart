import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/plantas/controller/controller.dart';
import 'package:sgp_movil/features/plantas/domain/domain.dart';

class PlantasDatasourceImpl implements PlantasDatasource 
{
  final DioClient httpService = DioClient();
  final LoggerSingleton log = LoggerSingleton.getInstance('PlantasDatasourceImpl');
  final String accessToken;

  PlantasDatasourceImpl({required this.accessToken});

  @override
  Future<List<Planta>> obtenerPlantas() async 
  {
    log.setupLoggin();

    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/plantas/obtenerPlantas';
      
      final response = await httpService.dio.get(url);
      
      List<Planta> listPlantas = [];
      for (var planta in response.data) {
        listPlantas.add(PlantaMappers.jsonToEntity(planta));
      }
      return listPlantas;
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
