import 'package:dio/dio.dart';

class ErroresHttp {
  static String verificarCodigoError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    // Si es error 500, mensaje genérico
    if (statusCode == 500) {
      return 'Error del servidor. Contacte con el administrador.';
    }

    // Si viene un JSON con mensajeError
    if (data is Map<String, dynamic> && data.containsKey('mensajeError')) {
      return data['mensajeError'];
    }

    // Si viene como texto plano (por si acaso)
    if (data is String) {
      return data;
    }

    // Fallback
    return 'Ha ocurrido un error inesperado.';
  }
}
