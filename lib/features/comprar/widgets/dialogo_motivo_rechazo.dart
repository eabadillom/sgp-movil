import 'package:flutter/material.dart';

Future<void> dialogoMotivoRechazo({
  required BuildContext context,
  required Future<void> Function(String? motivo) onEnviar,
}) {
  final TextEditingController controller = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Motivo de rechazo',
          style: TextStyle(fontSize: 22.0),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Escribe el motivo...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final motivo = controller.text.trim();
                  Navigator.of(context).pop();
                  await onEnviar(motivo.isEmpty ? null : motivo);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
