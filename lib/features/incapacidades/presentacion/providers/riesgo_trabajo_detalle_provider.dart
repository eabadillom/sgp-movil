import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';

final riesgoTrabajoProvider = StateNotifierProvider<RiesgoTrabajoDetalleNotifier, RiesgoTrabajoDetalleState> ((ref) 
{
  final riesgoTrabajoRepository = ref.watch(incapacidadDetalleRepositoryProvider);

  return RiesgoTrabajoDetalleNotifier(riesgoTrabajoRepository);
});

class RiesgoTrabajoDetalleNotifier extends StateNotifier<RiesgoTrabajoDetalleState>
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('RiesgoTrabajoDetalleNotifier');

  RiesgoTrabajoDetalleNotifier(this.incapacidadDetalleRepository) : super(RiesgoTrabajoDetalleState.initial());

  Future<void> obtenerRiesgoTrabajo() async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final riesgoTrabajo = await incapacidadDetalleRepository.getRiesgoTrabajo();

      state = state.copyWith(
        isLoading: false,
        riesgoTrabajo: riesgoTrabajo,
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

class RiesgoTrabajoDetalleState
{
  final bool isLoading;
  final List<RiesgoTrabajo> riesgoTrabajo;
  final String? errorMessage;

  RiesgoTrabajoDetalleState({
    this.isLoading = false,
    this.riesgoTrabajo = const [],
    this.errorMessage,
  });

  factory RiesgoTrabajoDetalleState.initial() => RiesgoTrabajoDetalleState();

  RiesgoTrabajoDetalleState copyWith({
    bool? isLoading,
    List<RiesgoTrabajo>? riesgoTrabajo,
    String? errorMessage,
  }) => RiesgoTrabajoDetalleState(
    isLoading: isLoading ?? this.isLoading,
    riesgoTrabajo: riesgoTrabajo ?? this.riesgoTrabajo,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}