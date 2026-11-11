import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class SideMenu extends ConsumerStatefulWidget 
{
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> 
{
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) 
  {
    final unreadCount = context.select((NotificationsBloc bloc) => bloc.state.unreadCount);
    final usuarioDetalleState = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final String fechaHoy = FormatUtil.fechaHoy();
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor;
    final textStyles = Theme.of(context).textTheme;
    final nombre = '${usuarioDetalleState?.nombreUsuario ?? ''} ${usuarioDetalleState?.primerApUsuario ?? ''} ${usuarioDetalleState?.segundoApUsuario ?? ''}'.trim();
    final puesto = (usuarioDetalleState?.puesto ?? '').toUpperCase();

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) 
      {
        setState(() 
        {
          navDrawerIndex = value;
        });

        // final menuItem = appMenuItems[value];
        // context.push(menuItem.link);
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: 
      [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 50 : 40, 20, 30),
          decoration: BoxDecoration(
            color: appBarColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.person_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Bienvenido',
                style: textStyles.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Sistema de Gestión\nde Personal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  fechaHoy,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 10),

        Padding(
          // 2. INFORMACIÓN DEL USUARIO
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                nombre.trim(),
                textAlign: TextAlign.center,
                style: textStyles.titleSmall?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  puesto,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Divider(color: Colors.amber, thickness: 1.1),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones'),
            trailing: unreadCount > 0 ? Badge(label: Text('$unreadCount')) : const Icon(Icons.chevron_right),
            onTap: () 
            {
              widget.scaffoldKey.currentState?.closeDrawer();
              context.push('/notificaciones');
            },
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Divider(color: Colors.amber, thickness: 1.1),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: 
            [
              SizedBox(
                width: double.infinity,
                child: CustomFilledButton(
                  onPressed: () => {context.push('/cambiarContrasenia')},
                  text: 'Actualizar Constraseña',
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Divider(color: Colors.amber, thickness: 1.1),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async 
              {
                final mensaje = await ref.read(loginProvider.notifier).deshabilitar();

                widget.scaffoldKey.currentState?.closeDrawer();

                if (!context.mounted) return;

                CustomSnackBarCentrado.mostrar(
                  context,
                  mensaje: mensaje,
                  tipo: mensaje.toLowerCase().contains('fallo') ? SnackbarTipo.error : SnackbarTipo.success,
                );

                if (!mensaje.toLowerCase().contains('fallo')) {
                  context.go('/login');
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
