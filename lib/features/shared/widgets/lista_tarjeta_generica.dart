import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListaTarjetaGenerica<T> extends StatelessWidget {
  final List<T> items; // Lista genérica de elementos
  final String Function(T item) getTitle; // Función para obtener el título
  final String Function(T item)
  getSubtitle; // Función para obtener el subtítulo
  final String Function(T item)?
  getRoute; // Función para obtener la ruta de navegación
  final Color? Function(T)? getBackgroundColor; // Funcion para obtener el color de la tarjeta (opcional)
  final Future<void> Function(T)? onTap;

  const ListaTarjetaGenerica({
    super.key,
    required this.items,
    required this.getTitle,
    required this.getSubtitle,
    this.getRoute,
    this.getBackgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        final bgColor = getBackgroundColor?.call(item);
    
        return Card(
          color: bgColor,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(getTitle(item)), // Título del item
            subtitle: Text(getSubtitle(item)), // Subtítulo del item
            leading: const Icon(Icons.person),
            onTap: () async {
              if (onTap != null) {
                await onTap!(item);
              } else {
                context.push(getRoute!(item));
              }
            },
          ),
        );
      },
    );
  }
}
