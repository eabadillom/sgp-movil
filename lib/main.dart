import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/theme_provider.dart';

void main() async
{
  await Environment.initEnvironmet();
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    final appRouter = ref.watch(goRouterProvider);
    final AppTheme appTheme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      routerConfig: appRouter,
      //theme: AppTheme().getTheme(),
      theme: appTheme.getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
