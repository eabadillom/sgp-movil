import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/dashboard/domain/notifications_channel.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/fcm_background_handler.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/theme_provider.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initEnvironmet();

  await SQLiteService.init();

  await NotificationsBloc.initializeFCM();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initNotificationChannel();

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log.logger.info("App resumed: sincronizando notificaciones");
      context.read<NotificationsBloc>().add(RefreshRequested());
      context.read<NotificationsBloc>().add(LoadStoredNotifications());
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

class _HandleNotificationInteractionsState extends State<HandleNotificationInteractions>
{
  final LoggerSingleton log = LoggerSingleton.getInstance('NotificationInteractions');
  late final StreamSubscription<NotificationsState> _blocSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedSubscription;

  @override
  void initState() 
  {
    super.initState();
    final bloc = context.read<NotificationsBloc>();
    _blocSubscription = bloc.stream.listen((state) 
    {
      final route = state.navigateToRoute;
      if (route != null) {
        safeNavigate(route);
        bloc.add(NotificationNavigated());
      }
    });
    bloc.add(RequestNotificationPermission());
    bloc.add(RefreshRequested());
    unawaited(setupInteractedMessage());
  }

  @override
  void dispose() {
    unawaited(_blocSubscription.cancel());
    unawaited(_messageOpenedSubscription?.cancel() ?? Future<void>.value());
    super.dispose();
  }

  Future<void> setupInteractedMessage() async 
  {
    _messageOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      unawaited(_handleMessage(message));
    });

    try {
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (mounted && initialMessage != null) {
        await _handleMessage(initialMessage);
      }
    } catch (e, st) {
      log.logger.severe('Error al procesar el inicio desde una notificación: $e\n$st');
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async 
  {
    try {
      final bloc = context.read<NotificationsBloc>();
      await bloc.handleRemoteMessage(message);
      if (!mounted) return;
      bloc.add(RefreshRequested());
      bloc.add(LoadStoredNotifications());
      bloc.add(NotificationNavigate('/notificaciones'));
    } catch (e, st) {
      log.logger.severe('Error al procesar una interacción con notificación: $e\n$st');
    }
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
