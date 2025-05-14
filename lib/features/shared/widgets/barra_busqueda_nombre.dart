import 'package:flutter/material.dart';

class BarraBusquedaNombre extends StatelessWidget {
  final void Function(String) onChanged;

  const BarraBusquedaNombre({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Buscar por nombre',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}
