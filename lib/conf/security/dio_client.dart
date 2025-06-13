import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:sgp_movil/conf/config.dart';

class DioClient {
  // Instancia privada de Dio
  static Dio? _dio;
  static final DioClient _instance = DioClient._internal();
  final LoggerSingleton log = LoggerSingleton.getInstance('DioInstance');

  DioClient._internal() {
    log.setupLoggin();
    // Configurando interceptores
    _dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          //log.logger.info('Solicitud: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          //log.logger.info('Respuesta: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          //log.logger.warning('Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // Factoria para acceder a la instancia de HttpService
  factory DioClient({required String nameContext}) {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: Environment.obtenerUrlPorNombre(
          nameContext,
        ), // Reemplaza con tu URL base
        connectTimeout: Duration(seconds: 5), // 5 segundos
        receiveTimeout: Duration(seconds: 3), // 3 segundos
        validateStatus: (status) {
          // Devuelve `true` si el estado es exitoso o si es el código 400
          return (status! >= 200 && status < 300) || status == 400;
        },
        headers: {'Content-Type': 'application/json'},
      ),
    );
    return _instance;
  }

  // Método para obtener la instancia de Dio
  Dio get dio => _dio!;

  // Método para establecer el token de acceso (si es necesario)
  void setAccessToken(String token) {
    _dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  // Método para establecer la authenticacion basica
  void setBasicAuth(String nombre, String contrasenia) {
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$nombre:$contrasenia'))}';
    dio.options.headers['Authorization'] = basicAuth;
  }
}
