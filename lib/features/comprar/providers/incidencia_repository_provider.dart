import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/incidencias/controller/datasource/incidencia_datasource_impl.dart';
import 'package:sgp_movil/features/incidencias/controller/repositories/incidencia_repository_impl.dart';
import 'package:sgp_movil/features/incidencias/domain/respositories/incidencia_repository.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

final incidenciaRepositoryProvider = Provider<IncidenciaRepository>((ref) {
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final incidenciaRepository = IncidenciaRepositoryImpl(
    IncidenciaDatasourceImpl(accessToken: accessToken),
  );
  return incidenciaRepository;
});
