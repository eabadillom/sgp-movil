import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/dashboard/presentation/screens/dashbord_screen.dart';
import 'package:sgp_movil/features/justificar/screens/justificar_list_screen.dart';
import 'package:sgp_movil/features/login/login.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) 
{
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  final LoggerSingleton log = LoggerSingleton.getInstance('LoginProvider'); 
  log.setupLoggin();

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla de validación de datos
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckLoginStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      ///* Dashboard
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashbordScreen(),
      ),

      ///* 
      GoRoute(
        path: '/justificar_faltas',
        builder: (context, state) => const FaltasRetardosScreen(),
      ),

      ///* 
      GoRoute(
        path: '/justificar_retardos',
        builder: (context, state) => const FaltasRetardosScreen(),
      ),
    ],

    redirect: (context, state) 
    {
      final isGoingTo = state.matchedLocation;
      final loginStatus = goRouterNotifier.loginStatus;

      //Pantalla de inicio de aplicacion dashboard
      if(isGoingTo == '/splash' && loginStatus == LoginStatus.checking)
      {
        if(loginStatus == LoginStatus.authenticated)
        {
          return '/dashboard';
        }

        if(loginStatus == LoginStatus.notAuthenticated)
        {
          return '/login';
        }
        return null;
      }

      //Pantalla de login y cuando el usuario no esta autenticado
      if(loginStatus == LoginStatus.notAuthenticated) 
      {
        if(isGoingTo == '/login') return null;

        return '/login';
      }

      if(loginStatus == LoginStatus.authenticated) 
      {
        if(isGoingTo == '/login' || isGoingTo == '/splash')
        {
          return '/dashboard';
        }
      }
      return null;
    },
  );
});
