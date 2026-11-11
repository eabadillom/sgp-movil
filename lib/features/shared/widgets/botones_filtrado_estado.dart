import 'package:flutter/material.dart';

class BotonesFiltradoEstado extends StatelessWidget 
{
  final String estadoSeleccionado;
  final Function(String) onEstadoSeleccionado;

  const BotonesFiltradoEstado({
    super.key,
    required this.estadoSeleccionado,
    required this.onEstadoSeleccionado,
  });

  static const List<String> _estados = ['E', 'A', 'R'];

  @override
  Widget build(BuildContext context) 
  {
    final selectedIndex = _estados.indexOf(estadoSeleccionado);

    return NavigationBar(
      selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) 
      {
        onEstadoSeleccionado(_estados[index]);
      },
      destinations: const 
      [
        NavigationDestination(
          icon: Icon(Icons.pending_actions_outlined),
          selectedIcon: Icon(Icons.pending_actions),
          label: 'Pendiente',
        ),
        NavigationDestination(
          icon: Icon(Icons.task_alt_outlined),
          selectedIcon: Icon(Icons.task_alt),
          label: 'Atendido',
        ),
        NavigationDestination(
          icon: Icon(Icons.cancel_outlined),
          selectedIcon: Icon(Icons.cancel),
          label: 'Rechazado',
        ),
      ],
    );
  }
}
