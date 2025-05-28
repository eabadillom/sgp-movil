import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';

final incapacidadDetalleProvider = StateNotifierProvider<IncapacidadDetalleNotifier, IncapacidadDetalleState> ((ref)
{ 
  final incapacidadDetalleRepository = ref.watch(incapacidadDetalleRepositoryProvider);
  return IncapacidadDetalleNotifier(incapacidadDetalleRepository);
});

class IncapacidadDetalleNotifier extends StateNotifier<IncapacidadDetalleState>
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('IncidenciaPermisoDetalleNotifier');
  
  IncapacidadDetalleNotifier(this.incapacidadDetalleRepository) : super(IncapacidadDetalleState.initial());
  
  Future<void> obtenerIncapacidad(int idIncapacidad) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final incapacidadDetalle = await incapacidadDetalleRepository.getIncapacidad(idIncapacidad);

      state = state.copyWith(
        isLoading: false,
        incapacidadDetalle: incapacidadDetalle,
      );

    }catch (e, stack) {
      log.logger.severe('Error al cargar el registro', e, stack);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo cargar el registro',
      );
    }
  }
}

class IncapacidadDetalleState
{
  final bool isLoading;
  final IncapacidadDetalle? incapacidadDetalle;
  final String? errorMessage;

  IncapacidadDetalleState({
    this.isLoading = false,
    this.incapacidadDetalle,
    this.errorMessage,
  });

  factory IncapacidadDetalleState.initial() => IncapacidadDetalleState();

  IncapacidadDetalleState copyWith({
    bool? isLoading,
    IncapacidadDetalle? incapacidadDetalle,
    String? errorMessage,
  }) => IncapacidadDetalleState(
    isLoading: isLoading ?? this.isLoading,
    incapacidadDetalle: incapacidadDetalle ?? this.incapacidadDetalle,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}