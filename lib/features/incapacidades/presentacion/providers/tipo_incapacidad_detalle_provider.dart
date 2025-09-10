import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/incapacidades/domain/entities/tipo_incapacidad.dart';
import 'package:sgp_movil/features/incapacidades/domain/repositories/incapacidad_detalle_repository.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';

final tipoIncapacidadDetalleProvider = StateNotifierProvider<TipoIncapacidadDetalleNotifier, TipoIncapacidadDetalleState> ((ref)
{ 
  final empleadoDetalleRepository = ref.watch(incapacidadDetalleRepositoryProvider);
  
  return TipoIncapacidadDetalleNotifier(empleadoDetalleRepository);
});

class TipoIncapacidadDetalleNotifier extends StateNotifier<TipoIncapacidadDetalleState>
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('TipoIncapacidadDetalleNotifier');

  TipoIncapacidadDetalleNotifier(this.incapacidadDetalleRepository) : super(TipoIncapacidadDetalleState.initial());
  
  Future<void> obtenerTipoIncapacidades() async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final tipoIncapacidadDetalle = await incapacidadDetalleRepository.getTipoIncapacidad();

      state = state.copyWith(
        isLoading: false,
        tipoIncapacidad: tipoIncapacidadDetalle,
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

class TipoIncapacidadDetalleState
{
  final bool isLoading;
  final List<TipoIncapacidad> tipoIncapacidad;
  final String? errorMessage;

  TipoIncapacidadDetalleState({
    this.isLoading = false,
    this.tipoIncapacidad = const [],
    this.errorMessage,
  });

  factory TipoIncapacidadDetalleState.initial() => TipoIncapacidadDetalleState();

  TipoIncapacidadDetalleState copyWith({
    bool? isLoading,
    List<TipoIncapacidad>? tipoIncapacidad,
    String? errorMessage,
  }) => TipoIncapacidadDetalleState(
    isLoading: isLoading ?? this.isLoading,
    tipoIncapacidad: tipoIncapacidad ?? this.tipoIncapacidad,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}