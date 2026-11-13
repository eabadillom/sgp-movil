import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListaTarjetaGenerica<T> extends StatelessWidget 
{
  final List<T> items; // Lista genérica de elementos
  final String Function(T item) getTitle; // Función para obtener el título
  final String Function(T item) getSubtitle; // Función para obtener el subtítulo
  final String Function(T item)? getRoute; // Función para obtener la ruta de navegación
  final Color? Function(T)? getBackgroundColor; // Funcion para obtener el color de la tarjeta (opcional)
  final Future<void> Function(T)? onTap;

  const ListaTarjetaGenerica({super.key, required this.items, required this.getTitle, required this.getSubtitle, this.getRoute, this.getBackgroundColor, this.onTap});

  @override
  Widget build(BuildContext context) 
  {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) 
      {
        final item = items[index];
        final bgColor = getBackgroundColor?.call(item);
        final colors = Theme.of(context).colorScheme;
        final foregroundColor = bgColor == null
            ? colors.onSurface
            : bgColor.computeLuminance() > 0.5
                ? Colors.black87
                : Colors.white;

        return Card(
          color: bgColor ?? colors.surfaceContainerHigh,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            title: Text(
              getTitle(item),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                getSubtitle(item),
                style: TextStyle(
                  color: foregroundColor.withValues(alpha: 0.75),
                ),
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              child: const Icon(Icons.person_outline),
            ),
            trailing: Icon(Icons.chevron_right, color: colors.outline),
            onTap: () async 
            {
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
