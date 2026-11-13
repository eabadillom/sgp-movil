import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/atender/providers/listar_provider.dart';
import 'package:sgp_movil/features/comprar/providers/detalle_solicitud_provider.dart';
import 'package:sgp_movil/features/comprar/utils/solicitud_utils.dart';
import 'package:sgp_movil/features/comprar/widgets/dialogo_motivo_rechazo.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

class BotonRechazar extends ConsumerWidget 
{
  final int idIncidencia;
  final String tipo;
  final String numeroRevisor;
  final DateTime fechaIni;
  final DateTime fechaFin;

  const BotonRechazar({super.key, required this.idIncidencia, required this.tipo, required this.numeroRevisor, required this.fechaIni, required this.fechaFin});

  @override
  Widget build(BuildContext context, WidgetRef ref) 
  {
    return FilledButton.icon(
      icon: const Icon(Icons.cancel),
      label: const Text('Rechazar'),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: () 
      {
        dialogoConfirmacion(context, '¿Estás seguro de rechazar esta solicitud?', () async 
          {
            await dialogoMotivoRechazo(
              context: context,
              onEnviar: (String? comentario) async 
              {
                try 
                {
                  await ref.read(solicitudNotifierProvider.notifier).actualizarSolicitud(id: idIncidencia, numeroRevisor: numeroRevisor, codigoEstadoIncidencia: 'R', motivoRechazo: comentario);
                  ref.read(listarNotifierProvider(tipo).notifier).cargarInicidencias(fechaIni, fechaFin);
                  
                  if (!context.mounted) return;

                  await CustomSnackBarCentrado.mostrar(context, mensaje: 'Solicitud rechazada exitosamente', tipo: SnackbarTipo.success);

                  limpiarVariables(ref);

                  if (!context.mounted) return;

                  context.go('/${obtenerPagina(tipo)}');
                } catch (e) {
                  if (!context.mounted) return;

                  await CustomSnackBarCentrado.mostrar(context, mensaje: 'Error: $e', tipo: SnackbarTipo.error);
                }
              },
            );
          },
        );
      },
    );
  }
}
