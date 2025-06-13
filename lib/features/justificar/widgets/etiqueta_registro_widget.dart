import 'package:flutter/material.dart';

class EtiquetaRegistroWidget extends StatelessWidget {
  final String label;
  final String value;

  const EtiquetaRegistroWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 100),
            child: Text(
              '$label:',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(fontSize: 16.0),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
