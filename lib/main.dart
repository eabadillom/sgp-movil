import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/conf/service/hive_service.dart';
import 'package:sgp_movil/features/dashboard/controller/notificacion_flag.dart';
import 'package:sgp_movil/features/dashboard/domain/notifications_channel.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/fcm_background_handler.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/theme_provider.dart';

void main() async
{
  await Environment.initEnvironmet();
  
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initNotificationChannel();

  await NotificationsBloc.initializeFCM();

  await HiveService.init();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsBloc>(
          create: (_) => NotificationsBloc(),
          lazy: false,
        ),
      ], 
      child: ProviderScope(
        child: MainApp()
      )
    )
  );
}

class MainApp extends ConsumerStatefulWidget 
{
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> with WidgetsBindingObserver 
{
  bool _hiveClosed = false;

  void _closeHiveIfNeeded() {
    if(!_hiveClosed) {
      HiveService.close();
      _hiveClosed = true;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().add(LoadStoredNotifications());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _closeHiveIfNeeded();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      print("App resumed: disparando syncFromHive");
      if (NotificationFlag().newNotificationArrived) {
        // Dispara evento para refrescar notificaciones
        context.read<NotificationsBloc>().add(RefreshRequested());
        context.read<NotificationsBloc>().add(LoadStoredNotifications());

        // Resetea la bandera
        NotificationFlag().newNotificationArrived = false;
      }
    }

    if(state == AppLifecycleState.detached) {
      _closeHiveIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(goRouterProvider); 
    final AppTheme appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
      locale: const Locale('es', 'ES'),
      supportedLocales: const [Locale('es', 'ES')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      builder: (context, child) => HandleNotificationInteractions(child: child!),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget
{
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() => _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState extends State<HandleNotificationInteractions> with WidgetsBindingObserver
{
  @override
  void initState() 
  {
    super.initState();
    setupInteractedMessage();

    // Escucha los cambios de navegación desde el Bloc
    WidgetsBinding.instance.addPostFrameCallback((_) 
    {
      final bloc = context.read<NotificationsBloc>();
      bloc.add(RefreshRequested());
      bloc.add(RequestNotificationPermission());
      bloc.add(LoadStoredNotifications());
      bloc.stream.listen((state) {
        final route = state.navigateToRoute;
        if (route != null) {
          safeNavigate(route);
          bloc.add(NotificationNavigated());
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Este se dispara cuando regresas de background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final bloc = context.read<NotificationsBloc>();
      bloc.add(LoadStoredNotifications());
    }
  }

  Future<void> setupInteractedMessage() async 
  {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null) _handleMessage(initialMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async 
  {
    final bloc = context.read<NotificationsBloc>();
  
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';
    final alreadyExists = bloc.state.notifications.any((n) => n.messageId == messageId);

    if (!alreadyExists) {
      await bloc.handleRemoteMessage(message);
    }
    
    bloc.add(NotificationNavigate('/notificaciones'));
  }

  void safeNavigate(String route) 
  {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).push(route);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
