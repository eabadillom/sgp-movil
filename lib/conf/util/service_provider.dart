import 'package:sgp_movil/features/shared/controller/services/key_value_storage_service_impl.dart';

class ServiceProvider 
{
  final keyValueStorageService = KeyValueStorageServiceImpl();

  static Future<String> obtenerToken(String tokenCadena) async
  {
    final token = await KeyValueStorageServiceImpl.getValue<String>(tokenCadena) ?? '';

    return token;
  }

}