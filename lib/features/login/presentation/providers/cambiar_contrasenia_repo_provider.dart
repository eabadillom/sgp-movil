import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';
import 'package:sgp_movil/features/login/presentation/providers/provider.dart';

final cambiarContraseniaRepoProvider = Provider<CambiarContraseniaRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final cambiarContraseniaRepository = CambiarContraseniaRepositoryImpl(CambiarContraseniaDatasourceImpl(accessToken: accessToken));
  
  return cambiarContraseniaRepository;
});
