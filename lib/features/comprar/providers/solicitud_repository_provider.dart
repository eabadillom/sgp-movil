import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/solicitudes/controller/controller.dart';
import 'package:sgp_movil/features/solicitudes/domain/repositories/solicitud_repository.dart';

final solicitudRepositoryProvider = Provider<SolicitudRepository>((ref) {
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final solicitudRepository = SolicitudRespositoryImpl(
    SolicicitudDatasourceImpl(accessToken: accessToken),
  );
  return solicitudRepository;
});
