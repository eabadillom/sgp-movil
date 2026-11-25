import 'package:dio/dio.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/empresas/controller/controller.dart';
import 'package:sgp_movil/features/empresas/domain/domain.dart';

class EmpresasDatasourcesImpl extends EmpresasDatasource 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('EmpresasDatasourcesImpl');
  final DioClient httpService = DioClient();
  final String accessToken;

  EmpresasDatasourcesImpl({required this.accessToken});

  @override
  Future<List<Empresa>> obtenerEmpresas() async
  {
    log.setupLoggin();

    try {
      String contexto = Environment.obtenerUrlPorNombre('Movil');
      String url = '$contexto/empresas/obtenerEmpresas';
      
      final response = await httpService.dio.get(url);
      
      List<Empresa> listEmpresas = [];
      for (var planta in response.data) {
        listEmpresas.add(EmpresaMappers.jsonToEntity(planta));
      }
      return listEmpresas;
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
