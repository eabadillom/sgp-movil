import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/incapacidades/controller/errors/registro_errores.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/providers.dart';

final incapacidadDetalleGuardarProvider = StateNotifierProvider<IncapacidadDetalleGuardarNotifier,IncapacidadDetalleGuardarState> ((ref)
{
  final incapacidadDetalleGuardarRepository = ref.watch(incapacidadDetalleRepositoryProvider);
  
  return IncapacidadDetalleGuardarNotifier(incapacidadDetalleGuardarRepository);
});

class IncapacidadDetalleGuardarNotifier extends StateNotifier<IncapacidadDetalleGuardarState>
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDetalleGuardarNotifier');

  IncapacidadDetalleGuardarNotifier(this.incapacidadDetalleRepository) : super(IncapacidadDetalleGuardarState.initial());

  Future<void> guardarIncapacidad(Map<String, dynamic> incapacidad) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null, mostrarMensaje: false);
    
    try 
    {
      final guardarIncapacidad = await incapacidadDetalleRepository.guardarIncapacidad(incapacidad);

      state = state.copyWith(
        isLoading: false,
        detalleIncapacidad: guardarIncapacidad,
        errorMessage: null,
        mostrarMensaje: true,
      );
    } on NoInternetException {
      final errorMsg = 'Error: sin conexion a internet';
      log.logger.severe(errorMsg);
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
        mostrarMensaje: true,
      );
    } on ServerException catch (e) {
      final errorMsg = e.message;
      log.logger.severe(errorMsg);

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
        mostrarMensaje: true,
      );
    } on RegistroNotFound catch (e)
    {
      final errorMsg = e.message;
      log.logger.severe(errorMsg);

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
        mostrarMensaje: true,
      );
    }
  }

  void marcarMensajeMostrado() 
  {
    state = state.copyWith(isLoading: true, mostrarMensaje: false);
  }
}

class IncapacidadDetalleGuardarState
{
  final bool isLoading;
  final IncapacidadGuardarDetalle? detalleIncapacidad;
  final String? errorMessage;
  final bool mostrarMensaje;

  IncapacidadDetalleGuardarState({
    this.isLoading = false,
    this.detalleIncapacidad,
    this.errorMessage,
    this.mostrarMensaje = false,
  });

  factory IncapacidadDetalleGuardarState.initial() => IncapacidadDetalleGuardarState();

  IncapacidadDetalleGuardarState copyWith({
    bool? isLoading,
    IncapacidadGuardarDetalle? detalleIncapacidad,
    String? errorMessage,
    bool? mostrarMensaje,
  }) => IncapacidadDetalleGuardarState(
    isLoading: isLoading ?? this.isLoading,
    detalleIncapacidad: detalleIncapacidad ?? this.detalleIncapacidad,
    errorMessage: errorMessage,
    mostrarMensaje: mostrarMensaje ?? this.mostrarMensaje,
  );

}
