import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/remote_message_mapper.dart';
import 'package:sgp_movil/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async 
{
  WidgetsFlutterBinding.ensureInitialized();
  final LoggerSingleton log = LoggerSingleton.getInstance('FCMBackgroundHandler');
  try 
  {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }

    await SQLiteService.init();
    log.logger.info('[FCM] Mensaje recibido en background: ${message.messageId}');

    final pushMessage = pushMessageFromRemoteMessage(message);
    if (!pushMessage.hasContent) {
      log.logger.warning('[FCM] Mensaje sin título ni cuerpo; se omite: ${pushMessage.messageId}');
      return;
    }
    
    await SQLiteService.saveNotification(pushMessage);

    log.logger.info('[FCM] Notificación almacenada en SQLite: ${pushMessage.messageId}');
  } catch (e, st) {
    log.logger.severe('[Background] Error al guardar mensaje: $e\n$st');
    rethrow;
  }
}