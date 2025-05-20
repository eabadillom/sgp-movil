import 'package:flutter/material.dart';

class BotonesFiltradoEstado extends StatelessWidget {
  final String estadoSeleccionado;
  final Function(String) onEstadoSeleccionado;

  BotonesFiltradoEstado({
    super.key,
    required this.estadoSeleccionado,
    required this.onEstadoSeleccionado,
  });

  final Map<String, String> estadoApiMap = {
    'Pendiente': 'E',
    'Atendido': 'A',
    'Rechazado': 'R',
  };

  @override
  Widget build(BuildContext context) {
    final estados = ['Pendiente', 'Atendido', 'Rechazado'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          estados.map((estado) {
            final seleccionado = estadoApiMap[estado] == estadoSeleccionado;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: seleccionado ? Colors.blue : Colors.grey[300],
                foregroundColor: seleccionado ? Colors.white : Colors.black,
              ),
              onPressed: () => onEstadoSeleccionado(estadoApiMap[estado]!),
              child: Text(estado),
            );
          }).toList(),
    );
  }
}
