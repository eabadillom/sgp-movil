import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/comprar/providers/incidencia_repository_provider.dart';
import 'package:sgp_movil/features/comprar/providers/solicitud_repository_provider.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/incidencias/controller/controller.dart';
import 'package:sgp_movil/features/incidencias/domain/respositories/incidencia_repository.dart';
import 'package:sgp_movil/features/solicitudes/domain/entities/solicitudarticulo.dart';
import 'package:sgp_movil/features/solicitudes/domain/entities/solicitudprenda.dart';
import 'package:sgp_movil/features/solicitudes/domain/repositories/solicitud_repository.dart';

final solicitudNotifierProvider = StateNotifierProvider<
  DetalleSolicitudNotifier,
  DetalleSolicitudState
>((ref) {
  final solicitudRepository = ref.watch(solicitudRepositoryProvider);
  final incidenciaRepository = ref.watch(incidenciaRepositoryProvider);
  return DetalleSolicitudNotifier(solicitudRepository, incidenciaRepository);
});

class DetalleSolicitudNotifier extends StateNotifier<DetalleSolicitudState> {
  final SolicitudRepository solicitudRepository;
  final IncidenciaRepository incidenciaRepository;
  final LoggerSingleton log = LoggerSingleton.getInstance('SolicitudNotifier');

  DetalleSolicitudNotifier(this.solicitudRepository, this.incidenciaRepository)
    : super(DetalleSolicitudState.initial());

  Future<void> obtenerSolicitud(String tipo, int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final solicitudDetalle = await solicitudRepository.obtenerSolicitud(
        tipo,
        id,
      );

      SolicitudDetalle solicitud;

      if (tipo == "A") {
        solicitud = SolicitudArticuloDetalle(
          solicitudDetalle as SolicitudArticulo,
        );
      } else if (tipo == "PR") {
        solicitud = SolicitudPrendaDetalle(solicitudDetalle as SolicitudPrenda);
      } else {
        throw Exception("Tipo de solicitud no reconocido.");
      }

      state = state.copyWith(isLoading: false, solicitud: solicitud);
    } catch (e, stack) {
      final mensaje = e.toString().replaceFirst('Exception: ', '');

      log.logger.warning('Error al obtener solicitud: $mensaje');

      state = state.copyWith(isLoading: false, errorMessage: mensaje);
    }
  }

  Future<void> actualizarSolicitud({
    required int id,
    required String numeroRevisor,
    required String codigoEstadoIncidencia,
    String? motivoRechazo,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      String numero = numeroRevisor;

      final Map<String, dynamic> incidencia = {
        'codigoEstadoIncidencia': codigoEstadoIncidencia,
        'numeroRevisor': numero,
        if (motivoRechazo != null && motivoRechazo.isNotEmpty)
          'motivoRechazo': motivoRechazo,
      };

      await incidenciaRepository.actualizarIncidencia(
        'solicitudes',
        id,
        incidencia,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      final mensaje = e.toString().replaceFirst('Exception: ', '');

      log.logger.warning('Error al actualizar solicitud: $mensaje');
      state = state.copyWith(isLoading: false, errorMessage: mensaje);
    }
  }
}

class DetalleSolicitudState {
  final bool isLoading;
  final SolicitudDetalle? solicitud;
  final String? errorMessage;

  DetalleSolicitudState({
    this.isLoading = false,
    this.solicitud,
    this.errorMessage,
  });

  factory DetalleSolicitudState.initial() => DetalleSolicitudState();

  DetalleSolicitudState copyWith({
    bool? isLoading,
    SolicitudDetalle? solicitud,
    String? errorMessage,
  }) {
    return DetalleSolicitudState(
      isLoading: isLoading ?? this.isLoading,
      solicitud: solicitud ?? this.solicitud,
      errorMessage: errorMessage,
    );
  }
}

sealed class SolicitudDetalle {}

class SolicitudArticuloDetalle extends SolicitudDetalle {
  final SolicitudArticulo data;
  SolicitudArticuloDetalle(this.data);
}

class SolicitudPrendaDetalle extends SolicitudDetalle {
  final SolicitudPrenda data;
  SolicitudPrendaDetalle(this.data);
}
