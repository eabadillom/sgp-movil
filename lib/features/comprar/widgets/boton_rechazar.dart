import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/comprar/providers/detalle_solicitud_provider.dart';
import 'package:sgp_movil/features/comprar/utils/solicitud_utils.dart';
import 'package:sgp_movil/features/comprar/widgets/dialogo_motivo_rechazo.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

class BotonRechazar extends ConsumerWidget {
  final int idIncidencia;
  final String tipo;
  final String numeroRevisor;

  const BotonRechazar({
    super.key,
    required this.idIncidencia,
    required this.tipo,
    required this.numeroRevisor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.cancel),
      label: const Text('Rechazar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shadowColor: Colors.redAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 18),
      ),
      onPressed: () {
        dialogoConfirmacion(
          context,
          '¿Estás seguro de rechazar esta solicitud?',
          () async {
            Navigator.of(context).pop(); // Cierra el diálogo de confirmación

            await dialogoMotivoRechazo(
              context: context,
              onEnviar: (String? comentario) async {
                
                try {
                  await ref
                      .read(solicitudNotifierProvider.notifier)
                      .actualizarSolicitud(
                        id: idIncidencia,
                        numeroRevisor: numeroRevisor,
                        codigoEstadoIncidencia: 'R',
                        motivoRechazo: comentario,
                      );
                  
                  if (!context.mounted) return;

                  await CustomSnackBarCentrado.mostrar(
                    context,
                    mensaje: 'Solicitud rechazada exitosamente',
                    tipo: SnackbarTipo.success,
                  );

                  limpiarVariables(ref);
                  
                  if(!context.mounted) return;

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
          },
        );
      },
    );
  }
}
