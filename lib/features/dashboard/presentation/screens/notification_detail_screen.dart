import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sgp_movil/features/dashboard/presentation/bloc/notifications/notifications_bloc.dart';

class NotificationDetailScreen extends StatelessWidget 
{
  final String pushMessageId;

  const NotificationDetailScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) 
  {
    final bloc = context.read<NotificationsBloc>();
    final PushMessage? message = bloc.getMessageById(pushMessageId);
    

    if (message != null && !message.read) {
      context.read<NotificationsBloc>().add(MarkNotificationAsRead(pushMessageId));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Notificación'),
      ),
      body: message != null
          ? _NotificationView(message: message)
          : const Center(child: Text('La notificación no existe')),
    );
  }
}

class _NotificationView extends StatelessWidget
{
  final PushMessage? message;

  const _NotificationView({required this.message});

  @override
  Widget build(BuildContext context) 
  {
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message!.title,
            style: textStyles.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            message!.body,
            style: textStyles.bodyLarge?.copyWith(height: 1.5),
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 1.2),
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Fecha de recepción:',
                style: textStyles.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(message!.sentDate),
            style: textStyles.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) 
  {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
