import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _confirmarSalida() async {
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
            IconButton(
              icon: Icon(
                isDarkmode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
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
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // número de columnas
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1, // relación ancho/alto para ListTile
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuItem.icon, size: 26, color: colors.primary),
            const SizedBox(height: 10),
            Text(menuItem.title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 5),
            Text(menuItem.subTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
