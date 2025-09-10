import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';
import 'package:sgp_movil/features/incidencias/controller/errors/registro_errors.dart';

final incapacidadDetalleProvider = StateNotifierProvider<IncapacidadDetalleNotifier, IncapacidadDetalleState> ((ref)
{ 
  final incapacidadDetalleRepository = ref.watch(incapacidadDetalleRepositoryProvider);
  return IncapacidadDetalleNotifier(incapacidadDetalleRepository);
});

class IncapacidadDetalleNotifier extends StateNotifier<IncapacidadDetalleState>
{
  final IncapacidadDetalleRepository incapacidadDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadDetalleNotifier');
  
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

  Future<void> cancelarIncapacidad(String numeroUsuario, Map<String, dynamic> incapacidad) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final incapacidadDetalle = await incapacidadDetalleRepository.cancelarIncapacidad(numeroUsuario, incapacidad);

      state = state.copyWith(
        isLoading: false,
        incapacidadDetalle: incapacidadDetalle,
      );

    }on DioException catch (e) 
    {
      final errorMsg = e.toString();

      log.logger.severe('Error al guardar: $errorMsg');
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
      throw RegistroNotFound(errorMsg);
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
