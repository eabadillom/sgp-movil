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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (message != null && !message.read) {
      context.read<NotificationsBloc>().add(MarkNotificationAsRead(pushMessageId));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la Notificación', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              message!.title,
              textAlign: TextAlign.center,
              style: textStyles.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: isDark ? Colors.blueAccent : Colors.blueAccent.shade100,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            message!.body,
            textAlign: TextAlign.center,
            style: textStyles.bodyLarge?.copyWith(
              height: 1.5, fontSize: 16
            ),
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
                style: textStyles.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
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
    const List<String> dias = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    const List<String> meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    final String diaSemana = dias[date.weekday - 1];
    final String dia = date.day.toString();
    final String mes = meses[date.month - 1];
    final String anio = date.year.toString();
    final String hora = date.hour.toString();
    final String minuto = date.minute.toString().padLeft(2, '0');

    return '$diaSemana $dia de $mes del $anio a las $hora:$minuto';
  }
}
