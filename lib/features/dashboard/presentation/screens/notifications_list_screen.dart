import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/shared/widgets/custom_snack_bar_centrado.dart';

class NotificationsListScreen extends StatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  State<NotificationsListScreen> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsListScreen> with WidgetsBindingObserver
{
  String _searchTerm = '';
  int _filterIndex = 0; // 0: todas, 1: leídas, 2: no leídas
  bool _isDescending = true; // true = más recientes primero

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<NotificationsBloc>().add(LoadStoredNotifications());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<NotificationsBloc>().add(RefreshRequested());
      context.read<NotificationsBloc>().add(LoadStoredNotifications());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            onPressed: () => _showClearConfirmation(context),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar notificaciones',
          ),
          IconButton(
            icon: const Icon(Icons.mark_email_read_outlined),
            tooltip: 'Marcar todas como leídas',
            onPressed: () {
              context.read<NotificationsBloc>().add(MarkAllAsRead());
            },
          ),
          IconButton(
            tooltip: _isDescending ? 'Ordenar más antiguas primero' : 'Ordenar más recientes primero',
            icon: Icon(_isDescending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                _isDescending = !_isDescending;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterButtons(),
          Expanded(
            child: BlocConsumer<NotificationsBloc, NotificationsState>(
              listenWhen: (previous, current) => previous.navigateToRoute != current.navigateToRoute,
              listener: (context, state) {
                final route = state.navigateToRoute;
                if (route != null) {
                  context.push(route);

                  context.read<NotificationsBloc>().add(NotificationNavigated());
                }
              },
              builder: (context, state) {
                final notifications = state.notifications;

                print('UI rebuild: ${notifications.length} notificaciones');

                if (notifications.isEmpty) {
                  return const Center(child: Text('No hay notificaciones'));
                }

                return _NotificationsList(
                  notifications: notifications,
                  searchTerm: _searchTerm,
                  filterIndex: _filterIndex,
                  isDescending: _isDescending,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Buscar notificaciones...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        onChanged: (value) => setState(() => _searchTerm = value),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ToggleButtons(
        isSelected: [
          _filterIndex == 0,
          _filterIndex == 1,
          _filterIndex == 2,
        ],
        onPressed: (index) {
          setState(() => _filterIndex = index);
        },
        borderRadius: BorderRadius.circular(12),
        children: const [
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Todas')),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Leídas')),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('No leídas')),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar notificaciones?'),
        content: const Text('Se eliminarán todas las notificaciones almacenadas localmente.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Eliminar'),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotificationsBloc>().add(ClearNotifications());
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final List<PushMessage> notifications;
  final String searchTerm;
  final int filterIndex; // 0: todas, 1: leídas, 2: no leídas
  final bool isDescending;

  const _NotificationsList({
    required this.notifications,
    required this.searchTerm,
    required this.filterIndex,
    required this.isDescending,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = notifications.where((notif) {
      final matchesSearch = notif.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
          notif.body.toLowerCase().contains(searchTerm.toLowerCase());
      final matchesFilter = switch (filterIndex) {
        1 => notif.read, // Leídas
        2 => !notif.read, // No leídas
        _ => true, // Todas
      };
      return matchesSearch && matchesFilter;
    }).toList();

    filtered.sort((a, b) {
      if (isDescending) {
        return b.sentDate.compareTo(a.sentDate);
      } else {
        return a.sentDate.compareTo(b.sentDate);
      }
    });

    if (filtered.isEmpty) {
      return const Center(child: Text('No hay notificaciones que coincidan'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = filtered[index];

        return Dismissible(
          key: Key(notification.messageId),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(215),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          onDismissed: (_) {
            final bloc = context.read<NotificationsBloc>();

            bloc.add(OptimisticRemoveNotification(notification.messageId));
            bloc.add(DeleteNotification(notification.messageId));

            CustomSnackBarCentrado.mostrar(
              context,
              mensaje: 'Notificación eliminada',
              tipo: SnackbarTipo.success,
            );
          },
          child: GestureDetector(
            onTap: () {
              context.push('/notificaciones_detalle/${notification.messageId}');
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: notification.read
                  ? (isDark ? const Color(0xFF1E1E1E) : Colors.white)
                  : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F4FF)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: notification.imageUrl != null
                          ? Image.network(
                              notification.imageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[300],
                              child: const Icon(Icons.notifications, color: Colors.white),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.grey[300] : Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Enviado el: ${_formatDate(notification.sentDate)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      notification.read ? Icons.mark_email_read : Icons.markunread,
                      color: notification.read ? Colors.green : Colors.blue,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
