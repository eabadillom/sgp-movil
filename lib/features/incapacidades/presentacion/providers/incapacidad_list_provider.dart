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
    state = state.copyWith(isLoading: true, errorMessage: null, paginaActual: 1);
    
    final registrosIncapacidades = await incapacidadRepository.getListIncapacidades(FormatUtil.dateFormated(fechaIni), FormatUtil.dateFormated(fechaFin));

    state = state.copyWith(isLoading: false, incapacidades: registrosIncapacidades);
  }

  void setBusqueda(String value) 
  {
    state = state.copyWith(busqueda: value, paginaActual: 1);
  }

  void cambiarPagina(int nuevaPagina) 
  {
    if (nuevaPagina >= 1 && nuevaPagina <= state.totalPaginas) 
    {
      state = state.copyWith(paginaActual: nuevaPagina);
    }
  }
}

class IncapacidadState
{
  final bool isLoading;
  final List<Incapacidad> incapacidades;
  final String? errorMessage;
  final String busqueda;
  final int paginaActual;
  final int tamanioPagina;

  IncapacidadState({
    this.isLoading = false,
    this.incapacidades = const [],
    this.errorMessage,
    required this.busqueda,
    this.paginaActual = 1,
    this.tamanioPagina = 5,
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

  List<Incapacidad> get registrosPaginados {
    final lista = registrosFiltrados;
    if (lista.isEmpty) return [];

    final inicio = ((paginaActual - 1) * tamanioPagina).clamp(0, lista.length);
    final fin = (inicio + tamanioPagina).clamp(inicio, lista.length);

    return lista.sublist(inicio, fin);
  }

  int get totalPaginas {
    final total = (registrosFiltrados.length / tamanioPagina).ceil();
    return total == 0 ? 0 : total;
  }

  int get paginaMostrada => totalPaginas == 0 ? 0 : paginaActual;

  factory IncapacidadState.initial() => IncapacidadState(incapacidades: [], busqueda: '');

  IncapacidadState copyWith({
    bool? isLoading,
    List<Incapacidad>? incapacidades,
    String? errorMessage,
    String? busqueda,
    int? paginaActual,
    int? tamanioPagina,
  }) => IncapacidadState(
    isLoading: isLoading ?? this.isLoading,
    incapacidades: incapacidades ?? this.incapacidades,
    errorMessage: errorMessage ?? this.errorMessage,
    busqueda: busqueda ?? this.busqueda,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );

}
