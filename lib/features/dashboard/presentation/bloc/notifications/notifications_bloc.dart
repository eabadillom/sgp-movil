import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/conf/service/sqlite_service.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/features/shared/controller/services/secure_storage_service_impl.dart';
import 'package:sgp_movil/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('NotificationsBloc');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
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
    on<SyncNotificationsFromApi>(_onSyncNotificationsFromApi);
    on<NotificationNavigate>(_onNotificationNavigate);
    on<NotificationNavigated>(_onNotificationNavigated);
    on<OptimisticRemoveNotification>(_onOptimisticRemoveNotification);
    on<RefreshRequested>(_onRefresh);

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
    if(Firebase.apps.isEmpty) {
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

  void _getFCMToken() async 
  {
    if ( state.status != AuthorizationStatus.authorized ) return;
  
    final token = await messaging.getToken();
    log.logger.info('Token FCM: $token');
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
    );

    await SQLiteService.saveNotification(notification);
    log.logger.info('Mensajes en Hive: ${(await SQLiteService.getNotifications()).length}');

    add(NotificationReceived(notification));
  }

  void _onRequestNotificationPermission(event, emit) async 
  {
    final settings = await messaging.getNotificationSettings();

    if(settings.authorizationStatus == AuthorizationStatus.notDetermined)  
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
      add(NotificationStatusChanged(newSettings.authorizationStatus));
    } else {
      add(NotificationStatusChanged(settings.authorizationStatus));
    }
  }

  void _onForegroundMessage()
  {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  Future<void> _onLoadStoredMessages(LoadStoredNotifications event, Emitter<NotificationsState> emit) async 
  {
    final storedMessages = await SQLiteService.getNotifications();

    final existingIds = state.notifications.map((n) => n.messageId).toSet();
    final newOnes = storedMessages.where((m) => !existingIds.contains(m.messageId)).toList();

    final updated = [...newOnes, ...state.notifications];

    updated.sort((a, b) => b.sentDate.compareTo(a.sentDate));

    log.logger.info("Load: Cargando / actualizando ${updated.length} mensajes de SQLite");

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
    syncFromSQLite();
  }

  void syncFromSQLite() 
  {
    log.logger.info("syncFromHive: agregando LoadStoredNotifications");
    add(LoadStoredNotifications());
  }

  /*Future<void> _onNotificationReceived(NotificationReceived event, Emitter<NotificationsState> emit) async 
  {
    final updatedList = List<PushMessage>.from(state.notifications);

    final existing = updatedList.indexWhere((n) => n.messageId == event.pushMessage.messageId);
    if (existing >= 0) {
      updatedList[existing] = event.pushMessage;
    } else {
      updatedList.insert(0, event.pushMessage);
    }

    await SQLiteService.saveNotification(event.pushMessage);

    emit(state.copyWith(notifications: updatedList));
  }*/

  void _onMarkNotificationAsRead(MarkNotificationAsRead event, Emitter<NotificationsState> emit) async 
  {
    final box = await SQLiteService.getNotificationById(event.messageId);

    if (box is PushMessage && !box.read) 
    {
      final updated = box.copyWith(read: true);
      await SQLiteService.saveNotification(updated);

      final updatedList = state.notifications.map((m) {
        return m.messageId == event.messageId ? updated : m;
      }).toList();

      emit(state.copyWith(notifications: updatedList));
    }
  }

  Future<void> _onMarkAllAsRead(MarkAllAsRead event, Emitter<NotificationsState> emit) async 
  {
    await SQLiteService.markAllAsReadNotifications();
    final updatedMessages = state.notifications.map((n) => n.copyWith(read: true)).toList();
    emit(state.copyWith(notifications: updatedMessages));
  }

  Future<void> _onDeleteNotification(DeleteNotification event, Emitter<NotificationsState> emit) async 
  {
    await SQLiteService.deleteNotification(event.messageId);

    final updatedList = state.notifications.where((n) => n.messageId != event.messageId).toList();

    emit(state.copyWith(notifications: updatedList));
  }

  Future<void> _onClearNotifications(ClearNotifications event, Emitter<NotificationsState> emit) async 
  {
    /*await SQLiteService.clearAll();
    emit(state.copyWith(notifications: []));*/
    await SQLiteService.deleteNotificationRead(onlyRead: true);

    final updatedList = await SQLiteService.getNotifications();
    log.logger.info('Quedan: ${updatedList.length} notificaciones');

    emit(state.copyWith(notifications: updatedList));
  }

  Future<void> _onSyncNotificationsFromApi(SyncNotificationsFromApi event, Emitter<NotificationsState> emit) async 
  {
    final synced = await SQLiteService.getNotifications();
    emit(state.copyWith(notifications: synced));
  }

  void _onOptimisticRemoveNotification(OptimisticRemoveNotification event, Emitter<NotificationsState> emit) 
  {
    final updated = state.notifications.where((n) => n.messageId != event.messageId).toList();
    emit(state.copyWith(notifications: updated));
  }

  void _onNotificationNavigate(NotificationNavigate event, Emitter<NotificationsState> emit) 
  {
    emit(state.copyWith(navigateToRoute: event.route));
  }

  void _onNotificationNavigated(NotificationNavigated event, Emitter<NotificationsState> emit) 
  {
    emit(state.copyWith(navigateToRoute: null));
  }

  void _onRefresh(RefreshRequested event, Emitter<NotificationsState> emit) 
  {
    // Esto emite un nuevo estado igual al actual,
    // forzando que los listeners reconstruyan la UI.
    emit(state.copyWith());
  }

  void _initialStatusCheck() async 
  {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String pushMessageId) 
  {
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if(!exist) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }

  void enviarFCMToken(String tokenFCM) async 
  {
    log.logger.info('Iniciando envio de token FCM');
    String accessToken = await storage.read(key: 'token') ?? '';
    httpService.setAccessToken(accessToken);

    log.logger.info('Estatus Authorization: ${state.status}');

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

}
