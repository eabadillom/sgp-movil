import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/shared/widgets/side_menu.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/theme_provider.dart';

class DashbordScreen extends ConsumerWidget 
{
  static const name = 'dashboard_screen'; 
  const DashbordScreen({super.key});

  @override
  Widget build(BuildContext context, ref) 
  {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final isDarkmode = ref.watch(themeNotifierProvider).isDarkmode;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(isDarkmode ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            onPressed: (){
              ref.read(themeNotifierProvider.notifier).toggleDarkmode();
            },
          ),
        ],
      ),
      body: _DashboardView(),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),  
    );
  }

}

class _DashboardView extends StatelessWidget
{
  const _DashboardView();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // número de columnas
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1, // relación ancho/alto para ListTile
        ),
        itemCount: appMenuItem.length,
        itemBuilder: (context, index){
          final menuItem = appMenuItem[index];
          return Card(
            elevation: 2,
            child: CustomListTile(menuItem: menuItem),
          );
        },
      ),
    );
  }
}

class CustomListTile extends StatelessWidget 
{
  const CustomListTile({
    super.key,
    required this.menuItem,
  });

  final MenuItems menuItem;

  @override
  Widget build(BuildContext context){
    final colors = Theme.of(context).colorScheme;
    
    return ListTile(
      trailing: Icon(menuItem.icon, color: colors.primary),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap:()
      {
        context.push(menuItem.link);
      }
    
    );
  }
}
