import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/incapacidades/controller/controller.dart';
import 'package:sgp_movil/features/incapacidades/domain/repositories/incapacidad_detalle_repository.dart';
import 'package:sgp_movil/features/incapacidades/domain/repositories/incapacidad_repository.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

final incapacidadRepositoryProvider = Provider<IncapacidadRepository> ((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final incapacidadRepository = IncapacidadRepositoryImpl(IncapacidadDatasourceImpl(accessToken: accessToken));

  return incapacidadRepository;
});

final incapacidadDetalleRepositoryProvider = Provider<IncapacidadDetalleRepository> ((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final incapacidadDetalleRepository = IncapacidadDetalleRepositoryImpl(IncapacidadDetalleDatasourceImpl(accessToken: accessToken));

  return incapacidadDetalleRepository;
});
