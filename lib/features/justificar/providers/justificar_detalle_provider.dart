import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_repository_provider.dart';
import 'package:sgp_movil/features/registro/domain/entities/registro_detalle.dart';
import 'package:sgp_movil/features/registro/domain/repositories/registro_detalle_repository.dart';

final justificarDetalleProvider =
    StateNotifierProvider<JustificarDetalleNotifier, JustificarDetalleState>((
      ref,
    ) {
      final registroRepository = ref.watch(justificarDetalleRepositoryProvider);

      return JustificarDetalleNotifier(registroRepository);
    });

class JustificarDetalleNotifier extends StateNotifier<JustificarDetalleState> {
  final RegistroDetalleRepository registroDetalleRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance(
    'RegistroDetalleProvider',
  );

  JustificarDetalleNotifier(this.registroDetalleRepository)
    : super(JustificarDetalleState.initial());

  Future<void> cargarRegistro(int idRegistro) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final registroDetalle = await registroDetalleRepository.registroDetalle(
      idRegistro,
    );

    state = state.copyWith(isLoading: true, registroDetalle: registroDetalle);
  }
}

/*factory JustificarDetalleState.initial() =>  JustificarDetalleState();

class JustificarDetalleState{
  final bool isLoading;
  final Registro registro;
  final String? errorMessage;

  JustificarDetalleState({
    this.isLoading = false,
     required this.registro,
    this.errorMessage,
  });


  JustificarDetalleState copyWith({
    String? codigo,
    bool? isLoading,
    Registro? registro,
    String? errorMessage,
  })  => JustificarDetalleState(
    isLoading: isLoading ?? this.isLoading,
    registro: registro ?? this.registro,
    errorMessage: errorMessage ?? this.errorMessage,
  );*/

class JustificarDetalleState {
  final bool isLoading;
  final RegistroDetalle? registroDetalle;
  final String? errorMessage;

  JustificarDetalleState({
    this.isLoading = false,
    this.registroDetalle,
    this.errorMessage,
  });

  factory JustificarDetalleState.initial() => JustificarDetalleState();

  JustificarDetalleState copyWith({
    bool? isLoading,
    RegistroDetalle? registroDetalle,
    String? errorMessage,
  }) => JustificarDetalleState(
    isLoading: isLoading ?? this.isLoading,
    registroDetalle: registroDetalle ?? this.registroDetalle,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
