import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class SideMenu extends ConsumerStatefulWidget 
{
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu
  ({
    super.key, 
    required this.scaffoldKey
  });

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> 
{
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) 
  {
    final usuarioDetalleState = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final String fechaHoy = FormatUtil.fechaHoy();

    return NavigationDrawer
    (
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
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
            child: Text('Bienvenido', style: textStyles.titleMedium),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
            child: Text(
              '${usuarioDetalleState?.nombreUsuario} ${usuarioDetalleState?.primerApUsuario} ${usuarioDetalleState?.segundoApUsuario}', 
              style: textStyles.titleSmall
            ),
          ),
        ),
        
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              '${usuarioDetalleState?.puesto}',
              style: textStyles.titleSmall
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(fechaHoy),
          ),
        ),
        
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),

        Padding
        (
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            onPressed: () 
            {
              ref.read(loginProvider.notifier).logout();
            },
            text: 'Cerrar sesión'
          ),
        ),

      ]
    );
  }
}
