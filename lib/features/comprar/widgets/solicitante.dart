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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          constante,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(variable, style: const TextStyle(fontSize: 20), softWrap: true),
      ],
    );
  }
}
