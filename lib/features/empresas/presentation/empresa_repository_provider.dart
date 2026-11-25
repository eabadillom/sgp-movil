import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/empresas/controller/controller.dart';
import 'package:sgp_movil/features/empresas/domain/domain.dart';
import 'package:sgp_movil/features/login/presentation/providers/provider.dart';

final empresasRepositoryProvider = Provider<EmpresasRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final empresasRepository = EmpresasRepositoryImpl(EmpresasDatasourcesImpl(accessToken: accessToken));
  
  return empresasRepository;
});
