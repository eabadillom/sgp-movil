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
    state = state.copyWith(isLoading: true, errorMessage: null);
    log.logger.info('Info incapacidad: ${incapacidad.toString()}');
    try 
    {
      final guardarIncapacidad = await incapacidadDetalleRepository.guardarIncapacidad(incapacidad);

      state = state.copyWith(
        isLoading: false,
        detalleIncapacidad: guardarIncapacidad,
      );
    } on NoInternetException {
      final errorMsg = 'Error: sin conexion a internet';
      log.logger.severe(errorMsg);
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
    } on ServerException catch (e) {
      final errorMsg = e.message;
      log.logger.severe(errorMsg);

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
    } on RegistroNotFound catch (e)
    {
      final errorMsg = e.message;
      log.logger.severe(errorMsg);

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
    }
  }
}

class IncapacidadDetalleGuardarState
{
  final bool isLoading;
  final IncapacidadGuardarDetalle? detalleIncapacidad;
  final String? errorMessage;

  IncapacidadDetalleGuardarState({
    this.isLoading = false,
    this.detalleIncapacidad,
    this.errorMessage,
  });

  factory IncapacidadDetalleGuardarState.initial() => IncapacidadDetalleGuardarState();

  IncapacidadDetalleGuardarState copyWith({
    bool? isLoading,
    IncapacidadGuardarDetalle? detalleIncapacidad,
    String? errorMessage,
  }) => IncapacidadDetalleGuardarState(
    isLoading: isLoading ?? this.isLoading,
    detalleIncapacidad: detalleIncapacidad ?? this.detalleIncapacidad,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}
