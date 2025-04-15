import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/dashboard/presentation/screens/dashbord_screen.dart';
import 'package:sgp_movil/features/login/login.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) 
{
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
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
      
    ],

    redirect: (context, state) 
    {
      final isGoingTo = state.matchedLocation;
      final loginStatus = goRouterNotifier.loginStatus;

      //Pantalla de inicio de aplicacion
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
      }

      //Pantalla de login y cuando el usuario no esta autenticado
      if(loginStatus == LoginStatus.notAuthenticated) 
      {
        if(isGoingTo == '/login') return null;

        return '/login';
      }

      if(loginStatus == LoginStatus.authenticated) 
      {
        if (isGoingTo == '/login' || isGoingTo != '/splash')
        {
          return '/dashboard';
        }
      }
      return null;
    },
  );
});
