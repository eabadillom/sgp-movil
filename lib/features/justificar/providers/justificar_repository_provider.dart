import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/registro/controller/datasource/registro_datasource_impl.dart';
import 'package:sgp_movil/features/registro/controller/repositories/registro_repository_impl.dart';

final justificarRepositoryProvider = Provider<RegistroRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final faltasRepository = RegistroRepositoryImpl(
    RegistroDatasourceImpl(accessToken: accessToken )
  );

  return faltasRepository;
});
