import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/plantas/controller/controller.dart';
import 'package:sgp_movil/features/plantas/domain/domain.dart';
import 'package:sgp_movil/features/plantas/presentation/providers/providers.dart';

final plantaNotifierProvider = StateNotifierProvider<PlantaNotifier, PlantaState>((ref) 
{
  final plantaRepository = ref.watch(plantasRepositoryProvider);
  
  return PlantaNotifier(plantaRepository);
});

class PlantaNotifier extends StateNotifier<PlantaState> 
{
  final PlantasRepository plantaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('PlantaNotifier');
  bool _loaded = false;

  PlantaNotifier(this.plantaRepository) : super(PlantaState.initial());

  Future<void> loadPlantas() async
  {
    if (_loaded && state.plantas.isNotEmpty) return; 

    await cargarPlantas();

    _loaded = true;
  }

  Future<void> refreshPlantas() async
  {
    if (state.isLoading) return;

    _loaded = false;

    await cargarPlantas();
    
    _loaded = true;
  }

  Future<void> cargarPlantas() async 
  {
    log.setupLoggin();
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      clearErrorMessage: true,
    );

    try 
    {
      final plantas = await plantaRepository.obtenerPlantas();
      state = state.copyWith(isLoading: false, plantas: plantas);
    } on CustomError catch (e)
    {
      log.logger.warning(e.message);

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ); 

    } catch (e)
    {
      if(e is SocketException)
      {
        log.logger.warning('Socket exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "No fue posible establecer comunicación con el servidor. Verifica tu conexión a Internet.",
        );
      }else if(e is TimeoutException)
      {
        log.logger.warning('Timeout exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "El servidor tardó demasiado en responder. Intenta nuevamente.",
        );
      }else if(e is ConnectionTimeout)
      {
        log.logger.warning('Connection exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Se agotó el tiempo de espera para establecer la conexión con el servidor.",
        );
      }
      else if(e is Exception)
      {
        log.logger.warning('Exception: $e');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Ocurrió un error inesperado al procesar la solicitud.",
        );
      }
      log.logger.severe('Error: ${e.toString()}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Ocurrió un error inesperado al procesar la solicitud.",
      );
    }
  }
  
}

class PlantaState 
{
  final bool isLoading;
  final List<Planta> plantas;
  final String? errorMessage;

  PlantaState({
    this.isLoading = false,
    this.plantas = const [],
    this.errorMessage,
  });

  factory PlantaState.initial() => PlantaState();

  PlantaState copyWith({
    bool? isLoading,
    List<Planta>? plantas,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) => PlantaState(
    isLoading: isLoading ?? this.isLoading,
    plantas: plantas ?? this.plantas,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );
}
