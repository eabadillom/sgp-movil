import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/atender/providers/listar_repository_provider.dart';
import 'package:sgp_movil/features/incidencias/domain/domain.dart';

final listarNotifierProvider = StateNotifierProvider.family<ListarNotifier, ListarState, String>((ref, tipo) 
{
  final incidenciaRepository = ref.watch(listarRepositoryProvider);
  return ListarNotifier(incidenciaRepository, tipo);
});

class ListarNotifier extends StateNotifier<ListarState> {
  final IncidenciaRepository incidenciaRepository;
  final String tipo;
  final LoggerSingleton log = LoggerSingleton.getInstance('IncidenciaProvider');

  ListarNotifier(this.incidenciaRepository, this.tipo) : super(ListarState.initial());

  Future<void> cargarInicidencias(DateTime fechaInicial, DateTime fechaFinal) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null, paginaActual: 1);
    try {
      final incidencias = await incidenciaRepository.getInicidencias(
        tipo,
        FormatUtil.dateFormated(fechaInicial),
        FormatUtil.dateFormated(fechaFinal),
      );
      state = state.copyWith(isLoading: false, incidencias: incidencias);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar las incidencias',
      );
      log.logger.warning('Error al cargar incidencias: $e');
    }
  }

  void setBusqueda(String value) {
    state = state.copyWith(busqueda: value, paginaActual: 1);
  }

  void cambiarPagina(int nuevaPagina, String estatus) {
  final total = state.totalPaginas(estatus);
  if (nuevaPagina >= 1 && nuevaPagina <= total) {
    state = state.copyWith(paginaActual: nuevaPagina);
  }
}

}

class ListarState {
  final bool isLoading;
  final List<Incidencia> incidencias;
  final String? errorMessage;
  final String busqueda;
  final int paginaActual;
  final int tamanioPagina;

  ListarState({
    this.isLoading = false,
    this.incidencias = const [],
    this.errorMessage,
    required this.busqueda,
    this.paginaActual = 1,
    this.tamanioPagina = 4,
  });

  List<Incidencia> get incidenciasFiltradasPorNombre {
    if (busqueda.isEmpty) return incidencias;

    final query = busqueda.toLowerCase();

    return incidencias.where((r) {
      final nombreCompleto =
          '${r.nombreSolicitante} ${r.primerApSolicitante} ${r.segundoApSolicitante}'
              .toLowerCase();
      return nombreCompleto.contains(query);
    }).toList();
  }

  List<Incidencia> filtradasPor(String estatus) =>
      incidencias.where((i) => i.codigoEstadoIncidencia == estatus).toList();
  
  List<Incidencia> paginaActualFiltrada(String estatus) {
    final lista = filtradasPor(estatus);
    final inicio = ((paginaActual - 1) * tamanioPagina).clamp(0, lista.length);
    final fin = (inicio + tamanioPagina).clamp(inicio, lista.length);
    return lista.sublist(inicio, fin);
  }

  int totalPaginas(String estatus) {
    final total = filtradasPor(estatus).length;
    return (total / tamanioPagina).ceil();
  }

  factory ListarState.initial() => ListarState(incidencias: [], busqueda: '');

  ListarState copyWith({
    String? codigo,
    bool? isLoading,
    List<Incidencia>? incidencias,
    String? errorMessage,
    String? busqueda,
    int? paginaActual,
    int? tamanioPagina,
  }) => ListarState(
    isLoading: isLoading ?? this.isLoading,
    incidencias: incidencias ?? this.incidencias,
    errorMessage: errorMessage ?? this.errorMessage,
    busqueda: busqueda ?? this.busqueda,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );
}
