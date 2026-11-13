import 'package:flutter/material.dart';

class DialogoConfirmacion extends StatelessWidget 
{
  final String titulo;
  final IconData icono;
  final Color color;
  final Future<void> Function() onConfirmar;

  const DialogoConfirmacion({super.key, required this.titulo, required this.icono, required this.color, required this.onConfirmar});

  @override
  Widget build(BuildContext context) 
  {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: 
        [
          Icon(icono, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(titulo, style: TextStyle(fontSize: 16.0))),
        ],
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: color),
          onPressed: () async 
          {
            await onConfirmar(); // Espera antes de cerrar el diálogo
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Sí'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(backgroundColor: Colors.red.shade400),
          onPressed: () => Navigator.pop(context),
          child: const Text('No', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}