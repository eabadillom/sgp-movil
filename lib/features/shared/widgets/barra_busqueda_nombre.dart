import 'package:flutter/material.dart';

class BarraBusquedaNombre extends StatelessWidget {
  final void Function(String) onChanged;
  final String hintText;
  final TextEditingController? controller;

  const BarraBusquedaNombre({
    super.key,
    required this.onChanged,
    this.hintText = 'Buscar por nombre',
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText, // Texto que aparece como etiqueta arriba
        hintText:
            'Buscar por nombre (p.e. Juan)', // Placeholder dentro del campo
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            controller != null
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller!.clear();
                    onChanged('');
                  },
                )
                : null,
      ),
      onChanged: onChanged,
    );
  }
}
