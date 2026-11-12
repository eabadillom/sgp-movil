import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/atender/screens/incidencia_permiso_screen.dart';
import 'package:sgp_movil/features/atender/screens/listar_incidencias_screen.dart';
import 'package:sgp_movil/features/comprar/screens/screens.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/features/dashboard/presentation/screens/screens.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/screens/incapacidad_detalle.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/screens/incapacidad_detalle_guardar.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/screens/incapacidad_list_screen.dart';
import 'package:sgp_movil/features/justificar/screens/justificar_list_screen.dart';
import 'package:sgp_movil/features/justificar/screens/justificar_detalle.dart';
import 'package:sgp_movil/features/login/login.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider((ref) 
{
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  final LoggerSingleton log = LoggerSingleton.getInstance('GoRouterProvider');
  log.setupLoggin();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla de validación de datos
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login', 
        builder: (context, state) => const LoginScreen()
      ),

      ///* Dashboard
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashbordScreen(),
      ),

      //* Notificaciones
      GoRoute(
        path: '/notificaciones',
        builder: (context, state) => const NotificationsListScreen(),
      ),

      GoRoute(
        path: '/notificaciones_detalle/:messageId',
        builder: (context, state) {
          final messageId = state.pathParameters['messageId']!;
          final notification = state.extra;
          return NotificationDetailScreen(
            pushMessageId: messageId,
            notification: notification is PushMessage ? notification : null,
          );
        },
      ),

      ///* Justificar Faltas
      GoRoute(
        path: '/justificar_faltas',
        builder: (context, state) {
          String codigo = "F";
          return JustificarListScreen(codigo: codigo);
        },
      ),

      ///* Justificar Retardos
      GoRoute(
        path: '/justificar_retardos',
        builder: (context, state) {
          String codigo = "R";
          return JustificarListScreen(codigo: codigo);
        },
      ),

      ///* Atender Vacaciones
      GoRoute(
        path: '/vacaciones',
        builder: (context, state) {
          String tipo = "V";
          String rutaDetalle = 'incidenciaPermisoDetalle';
          return ListarIncidenciasScreen(tipo: tipo, rutaDetalle: rutaDetalle);
        },
      ),

      ///* Atender Permisos
      GoRoute(
        path: '/permisos',
        builder: (context, state) {
          String tipo = "PE";
          String rutaDetalle = 'incidenciaPermisoDetalle';
          return ListarIncidenciasScreen(tipo: tipo, rutaDetalle: rutaDetalle);
        },
      ),

      ///* Atender uniformes
      GoRoute(
        path: '/uniformes',
        builder: (cotext, state) {
          String tipo = "PR";
          String rutaDetalle = 'detalleSolicitud';
          return ListarIncidenciasScreen(
            tipo: tipo,
            rutaDetalle: rutaDetalle,
          );
        },
      ),

      ///*Atender articulos
      GoRoute(
        path: '/articulos',
        builder: (context, state) {
          String tipo = "A";
          String rutaDetalle = "detalleSolicitud";
          return ListarIncidenciasScreen(
            tipo: tipo,
            rutaDetalle: rutaDetalle,
          );
        },
      ),

      ///*Atender incapacidades
      GoRoute(
        path: '/incapacidades',
        builder: (context, state) {
          return IncapacidadListScreen();
        },
      ),

      GoRoute(
        path: '/detalle/:idParametro/:codigo',
        builder: (context, state) {
          final idParametro = state.pathParameters['idParametro']!;
          final codigo = state.pathParameters['codigo']!;
          final int id = int.tryParse(idParametro) ?? 0;
          return JusitificarDetalle(id: id, codigo: codigo);
        },
      ),

      GoRoute(
        path: '/detalleSolicitud/:idIncidencia/:codigoTipoIncidencia',
        builder: (constext, state) {
          final idIncidencia = state.pathParameters['idIncidencia']!;
          final tipo = state.pathParameters['codigoTipoIncidencia']!;
          final int id = int.tryParse(idIncidencia) ?? 0;
          return DetalleSolicitudScreen(idIncidencia: id, tipoIncidencia: tipo);
        },
      ),

      GoRoute(
        path: '/incidenciaPermisoDetalle/:idParametro/:codigo',
        builder: (context, state) {
          int id = int.tryParse(state.pathParameters['idParametro']!) ?? 0;
          String codigo = state.pathParameters['codigo']!;
          return IncidenciaPermisoScreen(id: id, codigo: codigo);
        },
      ),

      GoRoute(
        path: '/incapacidadDetalle/:idParametro',
        builder: (context, state) {
          int id = int.tryParse(state.pathParameters['idParametro']!) ?? 0;
          return IncapacidadDetalle(id: id);
        },
      ),

      GoRoute(
        path: '/agregarIncapacidad',
        builder: (context, state) {
          return IncapacidadDetalleGuardar();
        },
      ),

      ///* Cambio de Contraseña
      GoRoute(
        path: '/cambiarContrasenia',
        builder: (context, state) {
          return CambiarContraseniaScreen();
        },
      ),
    ],

    redirect: (context, state) 
    {
      final location = state.matchedLocation;
      final loginStatus = goRouterNotifier.loginStatus;

      final isGoingToLogin = location == '/login';
      final isGoingToSplash = location == '/splash';

      if (loginStatus == LoginStatus.notAuthenticated) // Usuario NO autenticado
      {
        return isGoingToLogin ? null : '/login';
      }

      if (loginStatus == LoginStatus.authenticated) // Usuario autenticado
      {
        if (isGoingToLogin || isGoingToSplash) {
          return '/dashboard';
        }
      }

      return null;
    },
  );
});
