import 'package:flutter/material.dart';

class DialogoConfirmacionRechazo extends StatefulWidget 
{
  final String titulo;
  final String mensaje;
  final IconData icono;
  final Color color;
  final void Function(String comentario) onConfirmar;

  const DialogoConfirmacionRechazo({
    super.key,
    required this.titulo,
    required this.mensaje,
    required this.icono,
    required this.color,
    required this.onConfirmar,
  });

  @override
  State<DialogoConfirmacionRechazo> createState() => _DialogoConfirmacionRechazoState();

}

class _DialogoConfirmacionRechazoState extends State<DialogoConfirmacionRechazo>
{
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void dispose() 
  {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return AlertDialog
    (
      title: Row
      (
        children: 
        [
          Icon(widget.icono, color: widget.color),
          const SizedBox(width: 8),
          Expanded(child: Text(widget.titulo)),
        ],
      ),
      content: Column
      (
        mainAxisSize: MainAxisSize.min,
        children: 
        [
          Text(widget.mensaje),
          const SizedBox(height: 12),
          Text('Descripcion Rechazo'),
          TextField(
            controller: _comentarioController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: 
      [
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: widget.color),
          onPressed: () {
            final comentario = _comentarioController.text.trim();
            Navigator.pop(context);
            widget.onConfirmar(comentario);
          },
          child: const Text('Sí'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
      ],
    );
  }

}
