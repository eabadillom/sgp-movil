import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/incapacidades/domain/entities/tipo_riesgo.dart';
import 'package:sgp_movil/features/incapacidades/domain/repositories/incapacidad_detalle_repository.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';

final tipoRiesgoProvider = StateNotifierProvider<TipoRiesgoDetalleNotifier, TipoRiesgoDetalleState> ((ref) 
{
  final riesgoTrabajoRepository = ref.watch(incapacidadDetalleRepositoryProvider);

  return TipoRiesgoDetalleNotifier(riesgoTrabajoRepository);
});

class TipoRiesgoDetalleNotifier extends StateNotifier<TipoRiesgoDetalleState> 
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('TipoRiesgoDetalleNotifier');

  TipoRiesgoDetalleNotifier(this.incapacidadDetalleRepository) : super(TipoRiesgoDetalleState.initial());

  Future<void> obtenerTipoRiesgo() async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final tipoRiesgo = await incapacidadDetalleRepository.getTipoRiesgo();

      state = state.copyWith(
        isLoading: false,
        tipoRiesgo: tipoRiesgo,
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

class TipoRiesgoDetalleState
{
  final bool isLoading;
  final List<TipoRiesgo> tipoRiesgo;
  final String? errorMessage;

  TipoRiesgoDetalleState({
    this.isLoading = false,
    this.tipoRiesgo = const [],
    this.errorMessage,
  });

  factory TipoRiesgoDetalleState.initial() => TipoRiesgoDetalleState();

  TipoRiesgoDetalleState copyWith({
    bool? isLoading,
    List<TipoRiesgo>? tipoRiesgo,
    String? errorMessage,
  }) => TipoRiesgoDetalleState(
    isLoading: isLoading ?? this.isLoading,
    tipoRiesgo: tipoRiesgo ?? this.tipoRiesgo,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}