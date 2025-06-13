import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/atender/providers/estatus_provider.dart';
import 'package:sgp_movil/features/atender/providers/fecha_provider.dart';
import 'package:sgp_movil/features/atender/providers/listar_provider.dart';

String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

String obtenerPagina(String tipo) {
  switch (tipo) {
    case 'A':
      return 'articulos';
    case 'PR':
      return 'uniformes';
    default:
      return 'dashboard';
  }
}

Future<void> limpiarVariables(ref) async {
  ref.invalidate(listarNotifierProvider);
  ref.invalidate(estatusSeleccionadoProvider);
  ref.invalidate(fechaInicialProvider);
  ref.invalidate(fechaFinalProvider);
}
