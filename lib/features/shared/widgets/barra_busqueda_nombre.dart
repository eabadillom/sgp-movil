import 'package:flutter/material.dart';

class BarraBusquedaNombre extends StatelessWidget 
{
  final void Function(String) onChanged;
  final String hintText;
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;

  const BarraBusquedaNombre({
    super.key,
    required this.onChanged,
    this.hintText = 'Buscar por nombre',
    this.controller,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) 
  {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller != null ? 
          IconButton(
            tooltip: 'Limpiar búsqueda',
            icon: const Icon(Icons.delete_rounded),
            onPressed: () 
            {
              controller!.clear();
              onChanged('');
            },
          ) : null,
      ),
      onChanged: onChanged,
    );
  }
}
