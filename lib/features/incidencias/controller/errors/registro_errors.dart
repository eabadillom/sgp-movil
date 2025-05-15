class RegistroNotFound implements Exception 
{
  final String message;

  // final int errorCode;
  RegistroNotFound(this.message);
}

class NotFound implements Exception {}