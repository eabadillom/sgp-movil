import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/asistencia/controller/errors/custom_error.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';
import 'package:sgp_movil/features/asistencia/presentation/providers/providers.dart';

final empleadoDetalleNotifierProvider = StateNotifierProvider.autoDispose<EmpleadoDetalleNotifier, EmpleadoDetalleState>((ref) 
{
  final empleadoRepository = ref.watch(empleadoDetalleRepositoryProvider);
  
  return EmpleadoDetalleNotifier(empleadoRepository);
});

class EmpleadoDetalleNotifier extends StateNotifier<EmpleadoDetalleState>
{
  final AsistenciaRepository asistenciaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('EmpleadoDetalleNotifier');

  EmpleadoDetalleNotifier(this.asistenciaRepository) : super (EmpleadoDetalleState.initial());

  Future<void> obtenerEmpleadoDetalle(DateTime fechaInicio, DateTime fechaFin, int idEmpleado) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final empleadoDetalle = await asistenciaRepository.obteneEmpleadoDetalle(fechaInicio, fechaFin, idEmpleado);

      state = state.copyWith(
        isLoading: false,
        empleadoDetalle: empleadoDetalle,
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

class EmpleadoDetalleState 
{
  final bool isLoading;
  final EmpleadoDetalle? empleadoDetalle;
  final String? errorMessage;

  EmpleadoDetalleState({
    this.isLoading = false,
    this.empleadoDetalle,
    this.errorMessage,
  });

  factory EmpleadoDetalleState.initial() => EmpleadoDetalleState();

  EmpleadoDetalleState copyWith({
    bool? isLoading,
    EmpleadoDetalle? empleadoDetalle,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) => EmpleadoDetalleState(
    isLoading: isLoading ?? this.isLoading,
    empleadoDetalle: empleadoDetalle ?? this.empleadoDetalle,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );
}