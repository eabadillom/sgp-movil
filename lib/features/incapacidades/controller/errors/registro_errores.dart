class NotFound implements Exception 
{
  final String message;
  NotFound(this.message);

  @override
  String toString() => message;
}

class NoInternetException implements Exception 
{
  final String message;
  NoInternetException([this.message = 'No hay conexión a internet.']);

  @override
  String toString() => message;
}

class ServerException implements Exception 
{
  final String message;
  ServerException({this.message = 'Error del servidor.'});

  @override
  String toString() => message;
}

class UnexpectedException implements Exception 
{
  final String message;
  UnexpectedException([this.message = 'Ocurrió un error inesperado.']);

  @override
  String toString() => message;
}

class RegistroNotFound implements Exception 
{
  final String message;
  RegistroNotFound(this.message);

  @override
  String toString() => message;
}
