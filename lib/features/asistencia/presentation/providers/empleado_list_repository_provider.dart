import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/asistencia/controller/controller.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';
import '../../../login/presentation/providers/provider.dart';

final empleadoListRepositoryProvider = Provider<AsistenciaRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final empleadoListRepository = AsistenciaRepositoryImpl(AsistenciaDatasourceImpl(accessToken: accessToken));
  
  return empleadoListRepository;
});
