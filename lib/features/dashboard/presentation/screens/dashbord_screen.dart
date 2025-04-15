import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/shared/widgets/side_menu.dart';

class DashbordScreen extends StatelessWidget 
{
  static const name = 'dashboard_screen'; 
  const DashbordScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Dashboard')
      ),
      body: _DashboardView(),
      drawer: SideMenu(scaffoldKey: scaffoldKey,),
    );
  }

}

class _DashboardView extends StatelessWidget
{
  const _DashboardView();

  @override
  Widget build(BuildContext context) 
  {
    return ListView.builder(
      //physics: BouncingScrollPhysics(),
      itemCount: appMenuItem.length,
      itemBuilder: (context, index){
        final menuItem = appMenuItem[index];

        return CustomListTile(menuItem: menuItem);
      },
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
  Widget build(BuildContext context) 
  {
    final colors = Theme.of(context).colorScheme;
    
    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colors.primary), 
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap:()
      {
        context.push(menuItem.link);
      }
    
    );
  }
}
