import 'package:flutter/material.dart';

class TextoRicoWidget extends StatelessWidget {
  final String variable;
  final String constante;

  const TextoRicoWidget({
    super.key,
    required this.constante,
    required this.variable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: constante,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: variable,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurface,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
