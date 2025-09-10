import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotificationChannel() async 
{
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel_id', // debe ser igual al android:value del manifest
    'Canal por defecto',
    description: 'Canal para notificaciones por defecto',
    importance: Importance.high,
  );

  // Crear canal Android
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);

  // Inicializar plugin (opcional, pero recomendable)
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');

  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}