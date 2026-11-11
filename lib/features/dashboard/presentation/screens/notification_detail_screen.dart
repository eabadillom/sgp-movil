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
        title: const Text(
          'Detalle de la notificación',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: message != null ? _NotificationView(message: message) : const _NotificationNotFound(),
    );
  }
}

class _NotificationView extends StatelessWidget 
{
  final PushMessage message;

  const _NotificationView({required this.message});

  @override
  Widget build(BuildContext context) 
  {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: 
                  [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.75),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: colors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'DETALLE DE NOTIFICACIÓN',
                      textAlign: TextAlign.center,
                      style: textStyles.labelLarge?.copyWith(
                        color: colors.onPrimaryContainer.withValues(alpha: 0.75),
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message.title,
                      textAlign: TextAlign.center,
                      style: textStyles.titleLarge?.copyWith(
                        fontSize: 24,
                        height: 1.25,
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: 
                  [
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.subject_rounded,
                            size: 20,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Mensaje',
                            style: textStyles.titleSmall?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      message.body,
                      textAlign: TextAlign.center,
                      style: textStyles.bodyLarge?.copyWith(
                        height: 1.6,
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: 
                  [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colors.secondaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.schedule_rounded,
                        size: 21,
                        color: colors.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Fecha de recepción',
                      textAlign: TextAlign.center,
                      style: textStyles.titleSmall?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(message.sentDate),
                      textAlign: TextAlign.center,
                      style: textStyles.bodyMedium?.copyWith(
                        height: 1.4,
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

class _NotificationNotFound extends StatelessWidget 
{
  const _NotificationNotFound();

  @override
  Widget build(BuildContext context) 
  {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: 
          [
            Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'La notificación no existe',
              textAlign: TextAlign.center,
              style: textStyles.titleSmall?.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
