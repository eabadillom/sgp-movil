import 'package:dio/dio.dart';

class ErroresHttp {
  static String obtenerMensajeError(DioException e) {
    // Primero, tratamos errores de red o configuración
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado.';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado.';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de espera de respuesta agotado.';
      case DioExceptionType.badCertificate:
        return 'Certificado SSL inválido.';
      case DioExceptionType.cancel:
        return 'Solicitud cancelada.';
      case DioExceptionType.connectionError:
        return 'Error de conexión. Verifica tu conexión a internet.';
      default:
        // No devolvemos mensaje aún; revisamos statusCode más abajo
        break;
    }

    // Si hay respuesta del servidor, revisamos el status code y el contenido
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode == 500) {
      return 'Error del servidor. Contacte con el administrador.';
    }

    if (data is Map<String, dynamic> && data.containsKey('mensajeError')) {
      return data['mensajeError'];
    }

    if (data is String) {
      return data;
    }

    return 'Ha ocurrido un error inesperado.';
  }
}
