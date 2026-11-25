import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/asistencia/controller/controller.dart';
import 'package:sgp_movil/features/asistencia/domain/repositories/asistencia_repository.dart';
import 'package:sgp_movil/features/login/presentation/providers/provider.dart';

final estatusRegistroRepositoryProvider = Provider<AsistenciaRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final empleadoDetalleRepository = AsistenciaRepositoryImpl(AsistenciaDatasourceImpl(accessToken: accessToken));
  
  return empleadoDetalleRepository;
});
