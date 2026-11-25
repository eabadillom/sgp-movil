import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/presentation/providers/provider.dart';
import 'package:sgp_movil/features/plantas/controller/controller.dart';
import 'package:sgp_movil/features/plantas/domain/domain.dart';

final plantasRepositoryProvider = Provider<PlantasRepository>((ref) 
{
  final accessToken = ref.watch(loginProvider).token?.accessToken ?? '';
  
  final plantasRepository = PlantasRepositoryImpl(PlantasDatasourceImpl(accessToken: accessToken));
  
  return plantasRepository;
});
