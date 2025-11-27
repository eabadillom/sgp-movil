import 'package:flutter/material.dart';

class EtiquetaRegistroWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color? backgroundColor;

  const EtiquetaRegistroWidget({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
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
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold,fontSize: 16.0,),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: backgroundColor != null ? BoxDecoration(color: backgroundColor ?? Colors.blue.shade100, borderRadius: BorderRadius.circular(8),) : null,
              child: Text(
                value,
                style: textTheme.bodyMedium?.copyWith(fontSize: 16.0, color: Colors.black87,),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
