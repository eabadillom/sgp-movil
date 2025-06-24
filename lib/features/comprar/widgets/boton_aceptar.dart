import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/comprar/providers/detalle_solicitud_provider.dart';
import 'package:sgp_movil/features/comprar/utils/utils.dart';

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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        try {
          await ref
              .read(solicitudNotifierProvider.notifier)
              .actualizarSolicitud(
                id: idIncidencia,
                numeroRevisor: numeroRevisor,
                codigoEstadoIncidencia: 'A',
                motivoRechazo: null,
              );

          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Solicitud aceptada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );

          await Future.delayed(const Duration(seconds: 2));

          limpiarVariables(ref);

          context.go('/${obtenerPagina(tipo)}');
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );

          await Future.delayed(const Duration(seconds: 2));
        }
      },
      child: const Text('Aceptar'),
    );
  }
}
