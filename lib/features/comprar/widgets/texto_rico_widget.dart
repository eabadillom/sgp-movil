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
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: constante,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: variable, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
