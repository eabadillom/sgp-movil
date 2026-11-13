import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/login/contoller/controller.dart';
import 'package:sgp_movil/features/login/domain/domain.dart';
import 'package:sgp_movil/features/login/presentation/providers/provider.dart';

final cambiarContraseniaNotifierProvider = StateNotifierProvider.autoDispose<CambiarContraseniaNotifier, CambiarContraseniaState>((ref) 
{
  final cambiarContraseniaRepository = ref.watch(cambiarContraseniaRepoProvider);

  return CambiarContraseniaNotifier(cambiarContraseniaRepository);
});

class CambiarContraseniaNotifier extends StateNotifier<CambiarContraseniaState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('CambiarContraseniaNotifier');
  final CambiarContraseniaRepository cambiarContraseniaRepository;

  CambiarContraseniaNotifier(this.cambiarContraseniaRepository) : super(CambiarContraseniaState.initial());

  Future<bool> cambiarPalabra(String palabra) async 
  {
    log.setupLoggin();
    state = state.copyWith(isLoading: true, clearError: true);

    try 
    {
      final resultado = await cambiarContraseniaRepository.cambiarPalabra(palabra);

      state = state.copyWith(isLoading: false, controlMovil: resultado);

      return true;
    } on CustomError catch (e)
    {
      log.logger.warning(e.message);

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ); 

      return false;
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
      return false;
    }
  }

  void limpiar() 
  {
    state = CambiarContraseniaState.initial();
  }
}

class CambiarContraseniaState 
{
  final bool isLoading;
  final ControlMovil? controlMovil;
  final String? errorMessage;

  CambiarContraseniaState({
    this.isLoading = false,
    this.controlMovil,
    this.errorMessage,
  });

  factory CambiarContraseniaState.initial() => CambiarContraseniaState();

  CambiarContraseniaState copyWith({
    bool? isLoading,
    ControlMovil? controlMovil,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CambiarContraseniaState(
      isLoading: isLoading ?? this.isLoading,
      controlMovil: controlMovil ?? this.controlMovil,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
