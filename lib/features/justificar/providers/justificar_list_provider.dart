import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_repository_provider.dart';
import 'package:sgp_movil/features/registro/domain/entities/registro.dart';
import 'package:sgp_movil/features/registro/domain/repositories/registro_repository.dart';

final justificarNotifierProvider = StateNotifierProvider<JustificarNotifier, JustificarState>((ref)
{
  final registroRepository = ref.watch(justificarRepositoryProvider);

  return JustificarNotifier(registroRepository);
});

class JustificarNotifier extends StateNotifier<JustificarState>
{
  final RegistroRepository registroRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('RegistroProvider');

  JustificarNotifier(this.registroRepository) : super(JustificarState.initial());

  Future<void> cargarRegistros(DateTime fechaIni, DateTime fechaFin, String codigo) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null, paginaActual: 1);
    final registros = await registroRepository.getRegistro(FormatUtil.dateFormated(fechaIni), FormatUtil.dateFormated(fechaFin), codigo);

    state = state.copyWith(isLoading: false, registros: registros);
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

class JustificarState
{
  final bool isLoading;
  final List<Registro> registros;
  final String? errorMessage;
  final String busqueda;
  final int paginaActual;
  final int tamanioPagina;

  JustificarState({
    this.isLoading = false,
    this.registros = const [],
    this.errorMessage,
    required this.busqueda,
    this.paginaActual = 1,
    this.tamanioPagina = 5,
  });

  List<Registro> get registrosFiltrados 
  {
    if(busqueda.isEmpty) return registros;

    final query = busqueda.toLowerCase();

    return registros.where((r) 
    {
      final nombreCompleto = '${r.nombreEmpleado} ${r.primerApEmpleado} ${r.segundoApEmpleado}'.toLowerCase();
      return nombreCompleto.contains(query);
    }).toList();
  }

  List<Registro> get registrosPaginados {
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

  factory JustificarState.initial() => JustificarState(registros: [], busqueda: '');

  JustificarState copyWith({
    String? codigo,
    bool? isLoading,
    List<Registro>? registros,
    String? errorMessage,
    String? busqueda,
    int? paginaActual,
    int? tamanioPagina,
  })  => JustificarState(
    isLoading: isLoading ?? this.isLoading,
    registros: registros ?? this.registros,
    errorMessage: errorMessage ?? this.errorMessage,
    busqueda: busqueda ?? this.busqueda,
    paginaActual: paginaActual ?? this.paginaActual,
    tamanioPagina: tamanioPagina ?? this.tamanioPagina,
  );
}
