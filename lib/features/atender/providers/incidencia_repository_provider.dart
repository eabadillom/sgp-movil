import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/incidencias/controller/controller.dart';
import 'package:sgp_movil/features/incidencias/domain/domain.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

final incidenciaPermisoDetalleRepositoryProvider = Provider<IncidenciaPermisoDetalleRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final incidenciaPermisoDetalleRepository = IncidenciaPermisoDetalleRepositoryImpl(
    IncidenciaPermisoDetalleDatasourceImpl(accessToken: accessToken)
  );

  return incidenciaPermisoDetalleRepository;
});
