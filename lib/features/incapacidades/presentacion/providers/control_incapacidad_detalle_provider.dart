import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';

final controlIncapacidadProvider = StateNotifierProvider<ControlIncapacidadDetalleNotifier, ControlIncapacidadDetalleState> ((ref)
{
  final controlIncapacidadRepository = ref.watch(incapacidadDetalleRepositoryProvider);

  return ControlIncapacidadDetalleNotifier(controlIncapacidadRepository);
});

class ControlIncapacidadDetalleNotifier extends StateNotifier<ControlIncapacidadDetalleState>
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('ControlIncapacidadDetalleNotifier');

  ControlIncapacidadDetalleNotifier(this.incapacidadDetalleRepository) : super(ControlIncapacidadDetalleState.initial());

  Future<void> obtenerControlIncapacidad() async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final controlIncapacidad = await incapacidadDetalleRepository.getControlIncapacidad();

      state = state.copyWith(
        isLoading: false,
        controlIncapacidad: controlIncapacidad,
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

class ControlIncapacidadDetalleState
{
  final bool isLoading;
  final List<ControlIncapacidad> controlIncapacidad;
  final String? errorMessage;

  ControlIncapacidadDetalleState({
    this.isLoading = false,
    this.controlIncapacidad = const [],
    this.errorMessage,
  });

  factory ControlIncapacidadDetalleState.initial() => ControlIncapacidadDetalleState();

  ControlIncapacidadDetalleState copyWith({
    bool? isLoading,
    List<ControlIncapacidad>? controlIncapacidad,
    String? errorMessage,
  }) => ControlIncapacidadDetalleState(
    isLoading: isLoading ?? this.isLoading,
    controlIncapacidad: controlIncapacidad ?? this.controlIncapacidad,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
