import 'package:flutter/material.dart';

class EtiquetaRegistroWidget extends StatelessWidget 
{
  final String label;
  final String value;
  final Color? backgroundColor;

  const EtiquetaRegistroWidget({super.key, required this.label, required this.value, this.backgroundColor});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final badgeColor = backgroundColor;
    final badgeTextColor = badgeColor == null ? colors.onSurface : badgeColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: 
        [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.center,
            child: badgeColor == null ? 
              Text(
                value,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.normal,
                ),
              ) : 
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: badgeTextColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
