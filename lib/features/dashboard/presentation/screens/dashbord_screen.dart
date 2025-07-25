import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/shared/widgets/side_menu.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/theme_provider.dart';

class DashbordScreen extends ConsumerStatefulWidget {
  static const name = 'dashboard_screen';
  const DashbordScreen({super.key});

  @override
  ConsumerState<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends ConsumerState<DashbordScreen> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('DashbordScreen');
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() 
  {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async 
  {
    final token = await FirebaseMessaging.instance.getToken();
    if(!mounted) return;
    final bloc = context.read<NotificationsBloc>();
    
    if (token != null) 
    {
      log.logger.info('Token FCM: $token');
      // Enviar al backend si es necesario
      bloc.enviarFCMToken(token);
    } else {
      log.logger.warning('No se pudo obtener el token FCM');
    }

  }

  Future<bool> _confirmarSalida() async 
  {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estas seguro que quieres salir de la app?', style: TextStyle(fontSize: 16.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) 
  {
    final isDarkmode = ref.watch(themeNotifierProvider).isDarkmode;
    final unreadCount = context.select((NotificationsBloc bloc) => bloc.state.unreadCount);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        final salir = await _confirmarSalida();
        if (salir) {
          if(!context.mounted) return;

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            // Estamos en la última pantalla, cerramos la app
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    context.push('/notificaciones');
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: Icon(
                isDarkmode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              onPressed: () {
                ref.read(themeNotifierProvider.notifier).toggleDarkmode();
              },
            ),
          ],
        ),
        body: const _DashboardView(),
        drawer: SideMenu(scaffoldKey: scaffoldKey),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220, // Mejor para que escale en tablets
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.2, // relación ancho/alto para ListTile
      ),
      itemCount: appMenuItem.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItem[index];
        return Card(elevation: 2, child: CustomListTile(menuItem: menuItem));
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.menuItem});

  final MenuItems menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push(menuItem.link),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuItem.icon, size: 28, color: colors.primary),
            const SizedBox(height: 10),
            Text(menuItem.title, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
