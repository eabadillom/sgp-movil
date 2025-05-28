import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_repository_provider.dart';

final incapacidadNotifierProvider = StateNotifierProvider<IncapacidadNotifier, IncapacidadState>((ref)
{
  final incapacidadRepository = ref.watch(incapacidadRepositoryProvider);
  
  return IncapacidadNotifier(incapacidadRepository);
});

class IncapacidadNotifier extends StateNotifier<IncapacidadState>
{
  final IncapacidadRepository incapacidadRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('IncapacidadNotifier');

  IncapacidadNotifier(this.incapacidadRepository) : super(IncapacidadState.initial());

  Future<void> obtenerRegistros(DateTime fechaIni, DateTime fechaFin) async
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final registrosIncapacidades = await incapacidadRepository.getListIncapacidades(FormatUtil.dateFormated(fechaIni), FormatUtil.dateFormated(fechaFin));

    state = state.copyWith(isLoading: false, incapacidades: registrosIncapacidades);
  }

  void setBusqueda(String value) 
  {
    state = state.copyWith(busqueda: value);
  }
}

class IncapacidadState
{
  final bool isLoading;
  final List<Incapacidad> incapacidades;
  final String? errorMessage;
  final String busqueda;

  IncapacidadState({
    this.isLoading = false,
    this.incapacidades = const [],
    this.errorMessage,
    required this.busqueda,
  });

  List<Incapacidad> get registrosFiltrados 
  {
    if(busqueda.isEmpty) return incapacidades;

    final query = busqueda.toLowerCase();

    return incapacidades.where((r) 
    {
      final nombreCompleto = '${r.nombreInc} ${r.primerApInc} ${r.segundoApInc}'.toLowerCase();
      return nombreCompleto.contains(query);
    }).toList();
  }

  factory IncapacidadState.initial() => IncapacidadState(incapacidades: [], busqueda: '');

  IncapacidadState copyWith({
    bool? isLoading,
    List<Incapacidad>? incapacidades,
    String? errorMessage,
    String? busqueda,
  }) => IncapacidadState(
    isLoading: isLoading ?? this.isLoading,
    incapacidades: incapacidades ?? this.incapacidades,
    errorMessage: errorMessage ?? this.errorMessage,
    busqueda: busqueda ?? this.busqueda,
  );

}
