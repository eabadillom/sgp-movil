import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/incidencias/controller/controller.dart';
import 'package:sgp_movil/features/incidencias/domain/respositories/incidencia_repository.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

final listarRepositoryProvider = Provider<IncidenciaRepository>((ref) {
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final listarRepository = IncidenciaRepositoryImpl(
    IncidenciaDatasourceImpl(accessToken: accessToken),
  );

  return listarRepository;
});
