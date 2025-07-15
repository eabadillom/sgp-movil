import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';

class HiveService 
{
  static const _secureKeyName = 'hive_aes_key';
  static final _secureStorage = FlutterSecureStorage();

  static Future<void> init() async 
  {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    // Registrar adapter si no está registrado
    if(!Hive.isAdapterRegistered(PushMessageAdapter().typeId)) {
      Hive.registerAdapter(PushMessageAdapter());
    }

    // Obtener o generar clave de cifrado
    String? keyString = await _secureStorage.read(key: _secureKeyName);
    Uint8List encryptionKey;

    if(keyString == null) 
    {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _secureKeyName,
        value: base64UrlEncode(key),
      );
      encryptionKey = Uint8List.fromList(key);
    } else {
      encryptionKey = base64Url.decode(keyString);
    }

    // Abrir cajas cifradas
    if(!Hive.isBoxOpen('push_messages')) {
      await Hive.openBox<PushMessage>(
        'push_messages',
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }
  }

  static Future<Box<PushMessage>> get notificacionesBox async {
    if(!Hive.isBoxOpen('push_messages')) {
      await init();
    }
    return Hive.box<PushMessage>('push_messages');
  }

  static Future<void> close() async {
    if(Hive.isBoxOpen('push_messages')) {
      await Hive.box<PushMessage>('push_messages').close();
    }
    await Hive.close(); // Cierra Hive por completo
  }

  static Future<List<PushMessage>> getAllNotifications() async {
    final box = await notificacionesBox;
    return box.values.toList().reversed.toList();
  }

  static Future<void> saveNotification(PushMessage message) async {
    final box = await notificacionesBox;
    final key = message.messageId;
    if (!box.containsKey(key)) {
      await box.put(key, message);
    }
  }

  static Future<void> deleteNotification(String key) async {
    final box = await notificacionesBox;
    await box.delete(key);
  }

  static ValueListenable<Box<PushMessage>> get notificacionesListenable {
    if (!Hive.isBoxOpen('push_messages')) {
      throw Exception('Box push_messages no está abierto. Llama primero a HiveService.init()');
    }
    return Hive.box<PushMessage>('push_messages').listenable();
  }
  
}
