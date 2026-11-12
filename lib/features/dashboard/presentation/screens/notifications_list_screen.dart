import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:sgp_movil/features/dashboard/presentation/screens/screens.dart';
import 'package:sgp_movil/features/shared/shared.dart';

enum _NotificationAction {markAllAsRead, toggleSort, clear}

class NotificationsListScreen extends StatefulWidget 
{
  const NotificationsListScreen({super.key});

  @override
  State<NotificationsListScreen> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsListScreen>
{
  String _searchTerm = '';
  int _filterIndex = 0; // 0: todas, 1: leídas, 2: no leídas
  bool _isDescending = true; // true = más recientes primero

  @override
  void initState() 
  {
    super.initState();
    context.read<NotificationsBloc>().add(LoadStoredNotifications());
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones', overflow: TextOverflow.ellipsis),
        actions: 
        [
          PopupMenuButton<_NotificationAction>(
            tooltip: 'Más opciones',
            onSelected: (action) 
            {
              switch (action) 
              {
                case _NotificationAction.markAllAsRead:
                  context.read<NotificationsBloc>().add(MarkAllAsRead());
                  break;
                case _NotificationAction.toggleSort:
                  setState(() => _isDescending = !_isDescending);
                  break;
                case _NotificationAction.clear:
                  _showClearConfirmation(context);
                  break;
              }
            },
            itemBuilder: (context) => 
            [
              const PopupMenuItem(
                value: _NotificationAction.markAllAsRead,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.mark_email_read_outlined),
                  title: Text('Marcar todas como leídas'),
                ),
              ),
              PopupMenuItem(
                value: _NotificationAction.toggleSort,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(_isDescending ? Icons.arrow_downward : Icons.arrow_upward),
                  title: Text(_isDescending ? 'Más antiguas primero' : 'Más recientes primero'),
                ),
              ),
              const PopupMenuItem(
                value: _NotificationAction.clear,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.delete_outline),
                  title: Text('Eliminar notificaciones'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: BusquedaExpandible(
        initialValue: _searchTerm,
        hintText: 'Buscar notificaciones...',
        searchTooltip: 'Buscar notificaciones',
        onChanged: (value) => setState(() => _searchTerm = value),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _filterIndex,
        onDestinationSelected: (index) => setState(() => _filterIndex = index),
        destinations: const 
        [
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Todas',
          ),
          NavigationDestination(
            icon: Icon(Icons.mark_email_read_outlined),
            selectedIcon: Icon(Icons.mark_email_read_rounded),
            label: 'Leídas',
          ),
          NavigationDestination(
            icon: Icon(Icons.mark_email_unread_outlined),
            selectedIcon: Icon(Icons.mark_email_unread_rounded),
            label: 'No leídas',
          ),
        ],
      ),
      body: Stack(
        children: 
        [
          Column(
            children: 
            [
              Expanded(
                child: BlocBuilder<NotificationsBloc, NotificationsState>(
                  builder: (context, state) 
                  {
                    final notifications = state.notifications;

                    if (notifications.isEmpty) {
                      return const EmptyNotifications(
                        icon: Icons.notifications_none_rounded,
                        title: 'Aún no tienes notificaciones',
                        message: 'Cuando recibas una, aparecerá aquí.',
                      );
                    }

                    return NotificationsList(
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
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) 
  {
    showDialog(
      context: context,
      builder: (_) =>
        AlertDialog(
          title: const Text('¿Eliminar notificaciones?'),
          content: const Text('Se eliminarán todas las notificaciones leídas almacenadas localmente.'),
          actions: 
          [
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
