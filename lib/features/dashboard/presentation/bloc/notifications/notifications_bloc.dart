import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/conf/service/hive_service.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/features/shared/controller/services/secure_storage_service_impl.dart';
import 'package:sgp_movil/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('NotificationsBloc');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late final ValueListenable<Box<PushMessage>> _listenable;
  final DioClient httpService = DioClient();
  final storage = SecureStorageService();

  NotificationsBloc() : super(const NotificationsState()) 
  {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);
    on<LoadStoredNotifications>(_onLoadStoredMessages);
    on<ClearNotifications>(_onClearNotifications);
    on<DeleteNotification>(_onDeleteNotification);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<NotificationNavigate>(_onNotificationNavigate);
    on<NotificationNavigated>(_onNotificationNavigated);
    on<OptimisticRemoveNotification>(_onOptimisticRemoveNotification);
    on<RefreshRequested>(_onRefresh);

    _listenable = HiveService.notificacionesListenable;
    _listenable.addListener(_onBoxChanged);

    // Verificar estado de las notificaciones
    _initialStatusCheck();

    // Listener para notificaciones en Foreground
    _onForegroundMessage();

    // Carga los mensaje de la base de datos hive
    add(LoadStoredNotifications());

    // Solicitar permisos al arrancar por primera vez la app
    on<RequestNotificationPermission>(_onRequestNotificationPermission);
  }

  static Future<void> initializeFCM() async 
  {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit) 
  {
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }

  void _onBoxChanged() {
    add(LoadStoredNotifications());
  }

  void _onLoadStoredMessages(LoadStoredNotifications event, Emitter<NotificationsState> emit) async
  {
    final storedMessages = await HiveService.getAllNotifications();
    
    final existingIds = state.notifications.map((n) => n.messageId).toSet();
    final newOnes = storedMessages.where((m) => !existingIds.contains(m.messageId)).toList();

    final updated = [...newOnes, ...state.notifications];

    updated.sort((a, b) => b.sentDate.compareTo(a.sentDate));

    print("Load: Cargando / actualizando ${updated.length} mensajes de Hive");

    emit(state.copyWith(notifications: updated));
  }
  
  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit) async
  {
    final exists = state.notifications.any((n) => n.messageId == event.pushMessage.messageId);
    if(exists) return;

    /*
    await HiveService.saveNotification(event.pushMessage);
    final box = await HiveService.notificacionesBox;
    if(!box.containsKey(event.pushMessage.messageId)) {
      await box.put(event.pushMessage.messageId, event.pushMessage);
    }*/
    emit(state.copyWith(notifications: [event.pushMessage, ...state.notifications]));

    syncFromHive();
  }

  void syncFromHive() {
    print("syncFromHive: agregando LoadStoredNotifications");
    add(LoadStoredNotifications());
  }

  void _onOptimisticRemoveNotification(OptimisticRemoveNotification event, Emitter<NotificationsState> emit){
    final updatedList = state.notifications
      .where((n) => n.messageId != event.messageId)
      .toList();

    emit(state.copyWith(notifications: updatedList));
  }

  void _onDeleteNotification(DeleteNotification event, Emitter<NotificationsState> emit) async 
  {
    await HiveService.deleteNotification(event.messageId);

    final updatedList = state.notifications.where((n) => n.messageId != event.messageId).toList();

    emit(state.copyWith(notifications: updatedList));
  }

  void _onClearNotifications(ClearNotifications event, Emitter<NotificationsState> emit) async 
  {
    final box = await HiveService.notificacionesBox;

    final toDelete = box.keys.where((key) {
      final msg = box.get(key);
      return msg is PushMessage && msg.read;
    }).toList();

    for (final key in toDelete) {
      await box.delete(key);
    }

    final updatedList = box.values.cast<PushMessage>().toList().reversed.toList();
    emit(state.copyWith(notifications: updatedList));
  }

  void _onMarkNotificationAsRead(MarkNotificationAsRead event, Emitter<NotificationsState> emit) async 
  {
    final box = await HiveService.notificacionesBox;
    final raw = box.get(event.messageId);

    if (raw is PushMessage && !raw.read) 
    {
      final updated = raw.copyWith(read: true);
      await box.put(event.messageId, updated);

      final updatedList = state.notifications.map((m) {
        return m.messageId == event.messageId ? updated : m;
      }).toList();

      emit(state.copyWith(notifications: updatedList));
    }
  }

  void _onMarkAllAsRead(MarkAllAsRead event, Emitter<NotificationsState> emit) async 
  {
    final box = await HiveService.notificacionesBox;
    final updatedMessages = <PushMessage>[];

    for (int i = 0; i < box.length; i++) {
      final key = box.keyAt(i);
      final msg = box.get(key);
      if (msg != null && !msg.read) {
        final updated = msg.copyWith(read: true);
        await box.put(key, updated);
        updatedMessages.add(updated);
      } else if (msg != null) {
        updatedMessages.add(msg);
      }
    }

    emit(state.copyWith(
      notifications: updatedMessages.reversed.toList(),
    ));
  }

  void _initialStatusCheck() async 
  {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  void _onNotificationNavigate(NotificationNavigate event, Emitter<NotificationsState> emit) 
  {
    emit(state.copyWith(navigateToRoute: event.route));
  }

  void _onNotificationNavigated(NotificationNavigated event, Emitter<NotificationsState> emit) 
  {
    emit(state.copyWith(navigateToRoute: null));
  }

  void _getFCMToken() async 
  {
    if ( state.status != AuthorizationStatus.authorized ) return;
  
    final token = await messaging.getToken();
    log.logger.info('Token FCM: $token');
  }

  void enviarFCMToken(String tokenFCM) async 
  {
    log.logger.info('Iniciando envio de token FCM');
    String accessToken = await storage.read(key: 'token') ?? '';
    httpService.setAccessToken(accessToken);

    if(state.status != AuthorizationStatus.authorized) return;
  
    try {
      final String method = 'POST';
      /*String contexto = Environment.obtenerUrlPorNombre('Movil'); 
      String url =  '$contexto/generar/notificacion/';*/
      String url = 'http://192.168.1.126:8080/books-api/api/setToken';
      final data = {
        'token': tokenFCM,
      };
      final response = await httpService.dio.request(url, data: data, options: Options(method: method));
      log.logger.info('Respuesta del servidor: ${response.data}');
    } catch (e) {
      log.logger.warning('Error al enviar token: $e');
    }
      log.logger.info('Token: $tokenFCM');
  }

  Future<void> handleRemoteMessage(RemoteMessage message) async
  {
    if(message.notification == null) return;

    final id = message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';
    if(state.notifications.any((n) => n.messageId == id)) return;
    
    final notification = PushMessage(
      messageId: id,
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl
    );

    await HiveService.saveNotification(notification);
    log.logger.info('Mensajes en Hive: ${(await HiveService.notificacionesBox).values.length}');

    add(NotificationReceived(notification));
  }

  void _onForegroundMessage()
  {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void _onRequestNotificationPermission(event, emit) async 
  {
    final settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) 
    {
      final newSettings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
      emit(state.copyWith(status: newSettings.authorizationStatus));
    } else {
      emit(state.copyWith(status: settings.authorizationStatus));
    }
  }

  PushMessage? getMessageById(String pushMessageId) 
  {
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if(!exist) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }

  @override
  Future<void> close() {
    _listenable.removeListener(_onBoxChanged);
    return super.close();
  }

  void _onRefresh(RefreshRequested event, Emitter<NotificationsState> emit) {
    // Esto emite un nuevo estado igual al actual,
    // forzando que los listeners reconstruyan la UI.
    emit(state.copyWith());
  }

}
