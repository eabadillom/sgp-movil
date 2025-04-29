import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';
import 'package:sgp_movil/features/registro/controller/datasource/registro_detalle_datasource_impl.dart';
import 'package:sgp_movil/features/registro/controller/repositories/registro_detalle_repository_impl.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/registro/controller/datasource/registro_datasource_impl.dart';
import 'package:sgp_movil/features/registro/controller/repositories/registro_repository_impl.dart';

//Lista de registros con codigo y fecha 
final justificarRepositoryProvider = Provider<RegistroRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final justificarRepository = RegistroRepositoryImpl(
    RegistroDatasourceImpl(accessToken: accessToken)
  );

  return justificarRepository;
});

//Registro completo con ID del registro
final justificarDetalleRepositoryProvider = Provider<RegistroDetalleRepository>((ref)
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';

  final justificarDetalleRepository = RegistroDetalleRepositoryImpl(
    RegistroDetalleDatasourceImpl(accessToken: accessToken)
  );

  return justificarDetalleRepository;
});
