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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          constante,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          variable,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurface,
            fontSize: 18,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
