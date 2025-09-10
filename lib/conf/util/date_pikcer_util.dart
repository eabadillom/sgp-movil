import 'package:flutter/material.dart';

typedef FechaCallback = Future<void> Function(DateTime nuevaFecha);

Future<void> seleccionarFechaConAccion({
  required BuildContext context,
  required DateTime fechaActual,
  required FechaCallback onFechaSeleccionada,
  DateTime? minFecha,
  DateTime? maxFecha,
}) async {
  final nuevaFecha = await showDatePicker(
    context: context,
    initialDate: fechaActual,
    firstDate: minFecha ?? DateTime(2000),
    lastDate: maxFecha ?? DateTime(2100),
  );

  if (nuevaFecha != null) {
    await onFechaSeleccionada(nuevaFecha);
  }
}
