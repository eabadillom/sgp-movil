import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListaTarjetaGenerica<T> extends StatelessWidget {
  final List<T> items; // Lista genérica de elementos
  final String Function(T item) getTitle; // Función para obtener el título
  final String Function(T item)
  getSubtitle; // Función para obtener el subtítulo
  final String Function(T item)
  getRoute; // Función para obtener la ruta de navegación

  const ListaTarjetaGenerica({
    super.key,
    required this.items,
    required this.getTitle,
    required this.getSubtitle,
    required this.getRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(getTitle(item)), // Título del item
            subtitle: Text(getSubtitle(item)), // Subtítulo del item
            leading: const Icon(Icons.person),
            onTap: () {
              final route = getRoute(item); // Obtener la ruta personalizada
              context.push(route); // Navegar usando GoRouter
            },
          ),
        );
      },
    );
  }
}
