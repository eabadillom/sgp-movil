import 'package:flutter/material.dart';

class SolicitanteWidget extends StatelessWidget {
  final String constante;
  final String variable;

  const SolicitanteWidget({
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          variable,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurface,
            fontSize: 20,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
