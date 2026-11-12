import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/dashboard/presentation/screens/screens.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class NotificationsList extends StatelessWidget 
{
  final List<PushMessage> notifications;
  final String searchTerm;
  final int filterIndex; // 0: todas, 1: leídas, 2: no leídas
  final bool isDescending;

  const NotificationsList({super.key,  required this.notifications, required this.searchTerm, required this.filterIndex, required this.isDescending});

  @override
  Widget build(BuildContext context) 
  {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final filtered = notifications.where((notif) 
    {
      final matchesSearch = notif.title.toLowerCase().contains(searchTerm.toLowerCase()) || notif.body.toLowerCase().contains(searchTerm.toLowerCase());
      final matchesFilter = switch (filterIndex) 
      {
        1 => notif.read, // Leídas
        2 => !notif.read, // No leídas
        _ => true, // Todas
      };
      
      return matchesSearch && matchesFilter;
    }).toList();

    filtered.sort((a, b) 
    {
      if (isDescending) {
        return b.sentDate.compareTo(a.sentDate);
      } else {
        return a.sentDate.compareTo(b.sentDate);
      }
    });

    if (filtered.isEmpty) {
      return const EmptyNotifications(
        icon: Icons.search_off_rounded,
        title: 'No encontramos resultados',
        message: 'Prueba con otro filtro.',
      );
    }

    return Column(
      children: 
      [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: 
            [
              Expanded(
                child: Text(
                  'Tu actividad',
                  style: textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
              Text(
                '${filtered.length} ${filtered.length == 1 ? 'notificación' : 'notificaciones'}',
                style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) 
            {
              final notification = filtered[index];
              final unreadColor = colors.primary;

              return Dismissible(
                key: Key(notification.messageId),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: BoxDecoration(
                    color: colors.error,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) 
                {
                  final bloc = context.read<NotificationsBloc>();

                  bloc.add(OptimisticRemoveNotification(notification.messageId));
                  bloc.add(DeleteNotification(notification.messageId));

                  CustomSnackBarCentrado.mostrar(context, mensaje: 'Notificación eliminada', tipo: SnackbarTipo.success);
                },
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  color: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: notification.read ? colors.outlineVariant.withValues(alpha: 0.6) : unreadColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: InkWell(
                    onTap: () 
                    {
                      final encodedMessageId = Uri.encodeComponent(notification.messageId);
                      context.push(
                        '/notificaciones_detalle/$encodedMessageId',
                        extra: notification,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: 
                        [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: notification.read ? colors.surfaceContainerHighest : colors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              notification.read ? Icons.mark_email_read_outlined : Icons.mark_email_unread_rounded,
                              color: notification.read ? colors.onSurfaceVariant : colors.primary,
                              size: 21,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: 
                              [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: 
                                  [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: textTheme.titleSmall?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: colors.onSurface,
                                        ),
                                      ),
                                    ),
                                    if (!notification.read) 
                                    ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.only(top: 7),
                                        decoration: BoxDecoration(
                                          color: colors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notification.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    height: 1.4,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: 
                                  [
                                    Icon(
                                      Icons.schedule_rounded,
                                      size: 15,
                                      color: colors.outline,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        _formatDate(notification.sentDate),
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colors.outline,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 19,
                                      color: colors.outline,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) 
  {
    final String dia = date.day.toString().padLeft(2, '0');
    final String mes = date.month.toString().padLeft(2, '0');
    final String anio = date.year.toString();
    final String hora = date.hour.toString().padLeft(2, '0');
    final String minuto = date.minute.toString().padLeft(2, '0');

    return 'Recibido el $dia/$mes/$anio a las $hora:$minuto';
  }

}
