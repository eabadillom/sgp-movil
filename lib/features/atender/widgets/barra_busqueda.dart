import 'package:flutter/material.dart';

class BarraBusqueda extends StatelessWidget {
  final Function(String) onSearchChanged;

  const BarraBusqueda({Key? key, required this.onSearchChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearchChanged,
      decoration: const InputDecoration(
        labelText: 'Buscar por nombre',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
