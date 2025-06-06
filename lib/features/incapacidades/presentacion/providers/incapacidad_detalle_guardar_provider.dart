import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/providers.dart';
import 'package:sgp_movil/features/incidencias/controller/errors/registro_errors.dart';

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
    } on RegistroNotFound catch (e) 
    {
      log.logger.warning('Entre a incapacidad detalle guardar provider');
      final errorMsg = e.message;

      log.logger.severe('Error al guardar: $errorMsg');
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
    }catch (e){
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error, contacte a su administrador de sistemas',
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