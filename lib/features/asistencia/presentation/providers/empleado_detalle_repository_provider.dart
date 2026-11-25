import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/asistencia/controller/controller.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';
import 'package:sgp_movil/features/login/presentation/providers/provider.dart';

final empleadoDetalleRepositoryProvider = Provider<AsistenciaRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final empleadoDetalleRepository = AsistenciaRepositoryImpl(AsistenciaDatasourceImpl(accessToken: accessToken));
  
  return empleadoDetalleRepository;
});
