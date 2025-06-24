// motivo_rechazo_widget.dart

import 'package:flutter/material.dart';

class MotivoRechazoWidget extends StatelessWidget {
  final String constante;
  final String variable;

  const MotivoRechazoWidget({
    super.key,
    required this.constante,
    required this.variable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          constante,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          variable,
          style: const TextStyle(fontSize: 18),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
