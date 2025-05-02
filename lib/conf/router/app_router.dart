import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/dashboard/presentation/screens/dashbord_screen.dart';
import 'package:sgp_movil/features/justificar/screens/justificar_list_screen.dart';
import 'package:sgp_movil/features/login/login.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) 
{
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  final LoggerSingleton log = LoggerSingleton.getInstance('GoRouterProvider'); 
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

      ///* Justificar Faltas
      GoRoute(
        path: '/justificar_faltas',
        builder: (context, state)
        {
          DateTime fechaIni = DateTime.now().subtract(const Duration(days: 7));
          fechaIni = FormatUtil.dateFormated(fechaIni);
          DateTime fechaFin = DateTime.now();
          fechaFin =  FormatUtil.dateFormated(fechaFin);
          String codigo = "F";
          String nombrePantalla = "Ausencias";
          return JustificarListScreen(fechaIni: fechaIni, fechaFin: fechaFin, codigo: codigo, nombrePantalla: nombrePantalla,);
        }
      ),

      ///* Justificar Retardos
      GoRoute(
        path: '/justificar_retardos',
        builder: (context, state) 
        {
          DateTime fechaIni = DateTime.now().subtract(const Duration(days: 7));
          fechaIni = FormatUtil.dateFormated(fechaIni);
          DateTime fechaFin = DateTime.now();
          fechaFin = FormatUtil.dateFormated(fechaFin);
          String codigo = "R";
          String nombrePantalla = "Retardos";
          return JustificarListScreen(fechaIni: fechaIni, fechaFin: fechaFin, codigo: codigo, nombrePantalla: nombrePantalla,);
        },
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
