import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';

final empleadoDetalleProvider = StateNotifierProvider<EmpleadoDetalleNotifier, EmpleadoDetalleState> ((ref)
{ 
  final empleadoDetalleRepository = ref.watch(incapacidadDetalleRepositoryProvider);
  
  return EmpleadoDetalleNotifier(empleadoDetalleRepository);
});

class EmpleadoDetalleNotifier extends StateNotifier<EmpleadoDetalleState>
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('EmpleadoDetalleNotifier');
  
  EmpleadoDetalleNotifier(this.incapacidadDetalleRepository) : super(EmpleadoDetalleState.initial());
  
  Future<void> obtenerEmpleados() async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final empleadoDetalle = await incapacidadDetalleRepository.getEmpleados();

      state = state.copyWith(
        isLoading: false,
        empleadoIncapacidad: empleadoDetalle,
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

class EmpleadoDetalleState
{
  final bool isLoading;
  final List<EmpleadoIncapacidad> empleadoIncapacidad;
  final String? errorMessage;

  EmpleadoDetalleState({
    this.isLoading = false,
    this.empleadoIncapacidad = const [],
    this.errorMessage,
  });

  factory EmpleadoDetalleState.initial() => EmpleadoDetalleState();

  EmpleadoDetalleState copyWith({
    bool? isLoading,
    List<EmpleadoIncapacidad>? empleadoIncapacidad,
    String? errorMessage,
  }) => EmpleadoDetalleState(
    isLoading: isLoading ?? this.isLoading,
    empleadoIncapacidad: empleadoIncapacidad ?? this.empleadoIncapacidad,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
