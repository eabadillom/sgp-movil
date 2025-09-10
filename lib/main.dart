import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/conf/service/sqlite_service.dart';
import 'package:sgp_movil/features/dashboard/domain/notifications_channel.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/fcm_background_handler.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/theme_provider.dart';

void main() async
{
  await Environment.initEnvironmet();

  WidgetsFlutterBinding.ensureInitialized();

  await SQLiteService.init();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initNotificationChannel();

  await NotificationsBloc.initializeFCM();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsBloc>(
          create: (_) => NotificationsBloc(),
          lazy: false,
        ),
      ],
      child: ProviderScope(
        child: MainApp(),
      ),
    ),
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
  final LoggerSingleton log = LoggerSingleton.getInstance('Main App State');
  bool _dbClosed = false;

  void _closeDBIfNeeded() {
    if (!_dbClosed) {
      SQLiteService.close();
      _dbClosed = true;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<NotificationsBloc>();
      bloc.add(LoadStoredNotifications());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _closeDBIfNeeded();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log.logger.info("App resumed: sincronizando notificaciones");
      context.read<NotificationsBloc>().add(RefreshRequested());
      context.read<NotificationsBloc>().add(LoadStoredNotifications());
    }

    if (state == AppLifecycleState.detached) {
      _closeDBIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(goRouterProvider);
    final appTheme = ref.watch(themeNotifierProvider);

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
      bloc.add(RequestNotificationPermission());
      bloc.add(RefreshRequested());
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
      bloc.add(RefreshRequested());
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
  
    await bloc.handleRemoteMessage(message);
    bloc.add(RefreshRequested());
    bloc.add(LoadStoredNotifications());
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
