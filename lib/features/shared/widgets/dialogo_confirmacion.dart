import 'package:flutter/material.dart';

Future<void> dialogoConfirmacion(
  BuildContext context,
  String mensajeConfirmacion,
  VoidCallback onConfirm,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación', style: TextStyle(fontSize: 22.0)),
        content: Text(
          mensajeConfirmacion,
          style: const TextStyle(fontSize: 18.0),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm(); // Acción de confirmación
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Sí',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      );
    },
  );
}
