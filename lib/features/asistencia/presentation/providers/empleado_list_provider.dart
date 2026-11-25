import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/asistencia/controller/errors/custom_error.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';
import 'package:sgp_movil/features/asistencia/presentation/providers/providers.dart';

final empleadoNotifierProvider = StateNotifierProvider.autoDispose<EmpleadoNotifier, EmpleadoState>((ref) 
{
  final empleadoRepository = ref.watch(empleadoListRepositoryProvider);
  
  return EmpleadoNotifier(empleadoRepository);
});

class EmpleadoNotifier extends StateNotifier<EmpleadoState>
{
  final AsistenciaRepository asistenciaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('EmpleadoNotifier');
  
  EmpleadoNotifier(this.asistenciaRepository) : super(EmpleadoState.initial());

  Future<void> cargarEmpleados(DateTime fechaInicio, DateTime fechaFin, int idPlanta, int idEmpresa) async 
  {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      clearErrorMessage: true,
    );
    
    try 
    {
      final resultados = await asistenciaRepository.obtenerEmpleados(fechaInicio, fechaFin, idPlanta, idEmpresa);

      state = state.copyWith(
        isLoading: false,
        empleados: resultados,
        clearErrorMessage: true,
      );
    } on CustomError catch (e)
    {
      log.logger.warning(e.message);

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ); 

    } catch (e)
    {
      if(e is SocketException)
      {
        log.logger.warning('Socket exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "No fue posible establecer comunicación con el servidor. Verifica tu conexión a Internet.",
        );
      }else if(e is TimeoutException)
      {
        log.logger.warning('Timeout exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "El servidor tardó demasiado en responder. Intenta nuevamente.",
        );
      }else if(e is ConnectionTimeout)
      {
        log.logger.warning('Connection exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Se agotó el tiempo de espera para establecer la conexión con el servidor.",
        );
      }
      else if(e is Exception)
      {
        log.logger.warning('Exception: $e');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Ocurrió un error inesperado al procesar la solicitud.",
        );
      }
      log.logger.severe('Error: ${e.toString()}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Ocurrió un error inesperado al procesar la solicitud.",
      );
    }
  }

  void setBusqueda(String value) 
  {
    state = state.copyWith(busqueda: value);
  }

  void limpiar() 
  {
    state = EmpleadoState.initial();
  }

}

class EmpleadoState 
{
  final bool isLoading;
  final List<Empleado> empleados;
  final String? errorMessage;
  final String busqueda;

  EmpleadoState({
    this.isLoading = false,
    this.empleados = const [],
    this.errorMessage,
    required this.busqueda,
  });

  List<Empleado> get registrosFiltrados 
  {
    if(busqueda.isEmpty) return empleados;

    final query = busqueda.toLowerCase();

    return empleados.where((r) 
    {
      final nombreCompleto = '${r.nombre} ${r.primerAp} ${r.segundoAp}'.toLowerCase();
      return nombreCompleto.contains(query);
    }).toList();
  }

  List<Empleado> filtradasPor() => registrosFiltrados.toList();

  factory EmpleadoState.initial() => EmpleadoState(empleados: [], busqueda: '');

  EmpleadoState copyWith({
    bool? isLoading,
    List<Empleado>? empleados,
    String? errorMessage,
    String? busqueda,
    bool clearErrorMessage = false,
  }) => EmpleadoState(
    isLoading: isLoading ?? this.isLoading,
    empleados: empleados ?? this.empleados,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    busqueda: busqueda ?? this.busqueda,
  );
}
