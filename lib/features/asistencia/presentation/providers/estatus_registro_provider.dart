import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/asistencia/controller/errors/custom_error.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';
import 'package:sgp_movil/features/asistencia/presentation/providers/estatus_registro_repository_provider.dart';

final estatusRegistroNotifierProvider = StateNotifierProvider.autoDispose<EstatusRegistroNotifier, EstatusRegistroState>((ref) 
{
  final empleadoRepository = ref.watch(estatusRegistroRepositoryProvider);
  
  return EstatusRegistroNotifier(empleadoRepository);
});

class EstatusRegistroNotifier extends StateNotifier<EstatusRegistroState>
{
  final AsistenciaRepository asistenciaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('EstatusRegistroNotifier');
  
  EstatusRegistroNotifier(this.asistenciaRepository) : super(EstatusRegistroState.initial());
  
  Future<void> obtenerEstatusRegistros() async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final estatusRegistro = await asistenciaRepository.obtenerEstatusRegistros();

      state = state.copyWith(
        isLoading: false,
        estatusRegistro: estatusRegistro,
      );

    }on CustomError catch (e)
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

class EstatusRegistroState
{
  final bool isLoading;
  final List<EstatusRegistro> estatusRegistro;
  final String? errorMessage;

  EstatusRegistroState({
    this.isLoading = false,
    this.estatusRegistro = const [],
    this.errorMessage,
  });

  factory EstatusRegistroState.initial() => EstatusRegistroState();

  EstatusRegistroState copyWith({
    bool? isLoading,
    List<EstatusRegistro>? estatusRegistro,
    String? errorMessage,
  }) => EstatusRegistroState(
    isLoading: isLoading ?? this.isLoading,
    estatusRegistro: estatusRegistro ?? this.estatusRegistro,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
