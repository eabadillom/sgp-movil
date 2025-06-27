import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/comprar/providers/detalle_solicitud_provider.dart';
import 'package:sgp_movil/features/comprar/utils/utils.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

class BotonAceptar extends ConsumerWidget {
  final int idIncidencia;
  final String tipo;
  final String numeroRevisor;

  const BotonAceptar({
    super.key,
    required this.idIncidencia,
    required this.tipo,
    required this.numeroRevisor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.check),
      label: const Text('Autorizar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shadowColor: Colors.blueAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: () async {
        try {
          await ref
              .read(solicitudNotifierProvider.notifier)
              .actualizarSolicitud(
                id: idIncidencia,
                numeroRevisor: numeroRevisor,
                codigoEstadoIncidencia: 'A',
                motivoRechazo: null,
              );

          if (!context.mounted) return;

          await CustomSnackBarCentrado.mostrar(
            context,
            mensaje: 'Solicitud aceptada exitosamente',
            tipo: SnackbarTipo.success,
          );

          limpiarVariables(ref);

          if (!context.mounted) return;
          context.go('/${obtenerPagina(tipo)}');
        } catch (e) {
          if (!context.mounted) return;

          await CustomSnackBarCentrado.mostrar(
            context,
            mensaje: 'Error: $e',
            tipo: SnackbarTipo.error,
          );
        }
      },
    );
  }
}
