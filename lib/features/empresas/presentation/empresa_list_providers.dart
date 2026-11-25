import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/empresas/controller/controller.dart';
import 'package:sgp_movil/features/empresas/domain/domain.dart';
import 'package:sgp_movil/features/empresas/presentation/providers.dart';

final empresaNotifierProvider = StateNotifierProvider<EmpresaNotifier, EmpresaState>((ref) 
{
  final empresaRepository = ref.watch(empresasRepositoryProvider);

  return EmpresaNotifier(empresaRepository);
});

class EmpresaNotifier extends StateNotifier<EmpresaState> 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('EmpresaNotifier');
  final EmpresasRepository empresaRepository;
  bool _loaded = false;

  EmpresaNotifier(this.empresaRepository) : super(EmpresaState.initial());

  Future<void> loadEmpresas() async 
  {
    if (_loaded && state.empresas.isNotEmpty) return;

    await cargarEmpresas();

    _loaded = true;
  }

  Future<void> refreshEmpresas() async 
  {
    if (state.isLoading) return;

    _loaded = false;

    await cargarEmpresas();

    _loaded = true;
  }

  Future<void> cargarEmpresas() async 
  {
    log.setupLoggin();
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      clearErrorMessage: true,
    );

    try {
      final empresas = await empresaRepository.obtenerEmpresas();
      state = state.copyWith(isLoading: false, empresas: empresas);
    } on CustomError catch (e) {
      log.logger.warning(e.message);

      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      if (e is SocketException) {
        log.logger.warning('Socket exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "No fue posible establecer comunicación con el servidor. Verifica tu conexión a Internet.",
        );
      } else if (e is TimeoutException) {
        log.logger.warning('Timeout exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "El servidor tardó demasiado en responder. Intenta nuevamente.",
        );
      } else if (e is ConnectionTimeout) {
        log.logger.warning('Connection exception: ${e.toString()}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Se agotó el tiempo de espera para establecer la conexión con el servidor.",
        );
      } else if (e is Exception) {
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
}

class EmpresaState 
{
  final bool isLoading;
  final List<Empresa> empresas;
  final String? errorMessage;

  EmpresaState({
    this.isLoading = false,
    this.empresas = const [],
    this.errorMessage,
  });

  factory EmpresaState.initial() => EmpresaState();

  EmpresaState copyWith({
    bool? isLoading,
    List<Empresa>? empresas,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) => EmpresaState(
    isLoading: isLoading ?? this.isLoading,
    empresas: empresas ?? this.empresas,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );
}
