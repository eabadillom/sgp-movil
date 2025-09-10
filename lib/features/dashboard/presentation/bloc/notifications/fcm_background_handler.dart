import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/conf/service/sqlite_service.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('FCMBackgroundHandler');
  try 
  {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }

    log.logger.info('[FCM] Mensaje recibido en background: ${message.messageId}');

    final id = message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? ''; 

    final pushMessage = PushMessage(
      messageId: id,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
    );
    
    await SQLiteService.saveNotification(pushMessage);

    log.logger.info('[FCM] Notificación almacenada en SQLite: $id');
  } catch (e, st) {
    log.logger.severe('[Background] Error al guardar mensaje: $e\n$st');
  }
}