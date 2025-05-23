import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Instancia privada de FlutterSecureStorage
  final FlutterSecureStorage _storage;

  // Constructor (puedes inyectar configuración si lo necesitas)
  SecureStorageService({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  Future<void> write({
    required String key,
    required String value,
    IOSOptions? iosOptions,
    AndroidOptions? androidOptions,
  }) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  Future<String?> read({
    required String key,
    IOSOptions? iosOptions,
    AndroidOptions? androidOptions,
  }) async {
    return await _storage.read(
      key: key,
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> delete({
    required String key,
    IOSOptions? iosOptions,
    AndroidOptions? androidOptions,
  }) async {
    await _storage.delete(
      key: key,
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  Future<void> deleteAll({
    IOSOptions? iosOptions,
    AndroidOptions? androidOptions,
  }) async {
    await _storage.deleteAll(
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  Future<Map<String, String>> readAll({
    IOSOptions? iosOptions,
    AndroidOptions? androidOptions,
  }) async {
    return await _storage.readAll(
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

}
