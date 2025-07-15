import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/conf/service/hive_service.dart';
import 'package:sgp_movil/features/dashboard/controller/notificacion_flag.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('FCMBackgroundHandler');
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  await HiveService.init();

  log.logger.info("[Background] Mensaje recibido: ${message.messageId}");
  
  final id = message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';  

  final pushMessage = PushMessage(
    messageId: id,
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    sentDate: message.sentTime ?? DateTime.now(),
    data: message.data,
    imageUrl: Platform.isAndroid
      ? message.notification?.android?.imageUrl
      : message.notification?.apple?.imageUrl,
  );

  try {
    await HiveService.saveNotification(pushMessage);
    NotificationFlag().newNotificationArrived = true;
  } catch (e, st) {
    log.logger.severe('[Background] Error al guardar mensaje: $e\n$st');
  }
}
