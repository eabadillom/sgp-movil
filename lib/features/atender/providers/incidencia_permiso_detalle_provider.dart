import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/atender/providers/incidencia_repository_provider.dart';
import 'package:sgp_movil/features/incidencias/domain/domain.dart';

final incidenciaPermisoDetalleProvider = StateNotifierProvider<IncidenciaPermisoDetalleNotifier, IncidenciaPermisoDetalleState> ((ref)
{ 
  final incidenciaPermisoDetalleRepository = ref.watch(incidenciaPermisoDetalleRepositoryProvider);
  return IncidenciaPermisoDetalleNotifier(incidenciaPermisoDetalleRepository);
});

class IncidenciaPermisoDetalleNotifier extends StateNotifier<IncidenciaPermisoDetalleState>
{
  final IncidenciaPermisoDetalleRepository incidenciaPermisoDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('IncidenciaPermisoDetalleNotifier');

  IncidenciaPermisoDetalleNotifier(this.incidenciaPermisoDetalleRepository) : super(IncidenciaPermisoDetalleState.initial());

  Future<void> obtenerIncidenciaPermiso(int idIncidencia) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final incidenciaPermisoDetalle = await incidenciaPermisoDetalleRepository.obtenerIncidenciaPermiso(idIncidencia);

      state = state.copyWith(
        isLoading: false,
        incidenciaPermisoDetalle: incidenciaPermisoDetalle,
      );

    }catch (e, stack) {
      log.logger.severe('Error al cargar el registro', e, stack);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo cargar el registro',
      );
    }
  }

  Future<void> actualizarIncidenciaPermiso(int idIncidencia, Map<String, dynamic> incidencia) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final incidenciaPermisoDetalle = await incidenciaPermisoDetalleRepository.actualizarIncidenciaPermiso(idIncidencia, incidencia);

      state = state.copyWith(
        isLoading: false,
        incidenciaPermisoDetalle: incidenciaPermisoDetalle,
      );
    }catch (e, stack) {
      log.logger.severe('Error al actualizar el registro $idIncidencia', e, stack);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo actualizar el registro',
      );
    }
  }

}

class IncidenciaPermisoDetalleState 
{
  final bool isLoading;
  final IncidenciaPermisoDetalle? incidenciaPermisoDetalle;
  final String? errorMessage;

  IncidenciaPermisoDetalleState({
    this.isLoading = false,
    this.incidenciaPermisoDetalle,
    this.errorMessage,
  });

  factory IncidenciaPermisoDetalleState.initial() => IncidenciaPermisoDetalleState();

  IncidenciaPermisoDetalleState copyWith({
    bool? isLoading,
    IncidenciaPermisoDetalle? incidenciaPermisoDetalle,
    String? errorMessage,
  }) => IncidenciaPermisoDetalleState(
    isLoading: isLoading ?? this.isLoading,
    incidenciaPermisoDetalle: incidenciaPermisoDetalle ?? this.incidenciaPermisoDetalle,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}