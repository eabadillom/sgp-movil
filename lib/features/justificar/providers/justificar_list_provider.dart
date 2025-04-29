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

  Future<void> cargarRegistros(DateTime fecha, String codigo) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final DateTime fechaString = FormatUtil.dateFormated(fecha);
    final registros = await registroRepository.getRegistro(fechaString, codigo);

    state = state.copyWith(isLoading: false, registros: registros);
  }

  void setBusqueda(String value) 
  {
    state = state.copyWith(busqueda: value);
  }

}

class JustificarState
{
  final bool isLoading;
  final List<Registro> registros;
  final String? errorMessage;
  final String busqueda;

  JustificarState({
    this.isLoading = false,
    this.registros = const [],
    this.errorMessage,
    required this.busqueda,
  });

  List<Registro> get registrosFiltrados 
  {
    if (busqueda.isEmpty) return registros;

    final query = busqueda.toLowerCase();

    return registros.where((r) 
    {
      return r.nombreEmpleado.toLowerCase().contains(query) || r.primerApEmpleado.toLowerCase().contains(query) || r.segundoApEmpleado.toLowerCase().contains(query);
    }).toList();
  }

  factory JustificarState.initial() => JustificarState(registros: [], busqueda: '');

  JustificarState copyWith({
    String? codigo,
    bool? isLoading,
    List<Registro>? registros,
    String? errorMessage,
    String? busqueda,
  })  => JustificarState(
    isLoading: isLoading ?? this.isLoading,
    registros: registros ?? this.registros,
    errorMessage: errorMessage ?? this.errorMessage,
    busqueda: busqueda ?? this.busqueda,
  );
}
