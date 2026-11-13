import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PeriodoCalendario extends StatelessWidget 
{
  final List<DateTime> fechas;

  const PeriodoCalendario({super.key, required this.fechas});

  @override
  Widget build(BuildContext context) 
  {
    if (fechas.isEmpty) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            Text(
              'Días solicitados: ',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${fechas.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSecondaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        TableCalendar(
          locale: 'es_MX',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: fechas.first,
          selectedDayPredicate: (day) {
            return fechas.any((d) => isSameDay(d, day));
          },
          calendarStyle: CalendarStyle(
            defaultTextStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colors.onSurface,
            ),
            weekendTextStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colors.onSurfaceVariant,
            ),
            outsideTextStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colors.outline,
            ),
            disabledTextStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colors.outline,
            ),
            selectedTextStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colors.onPrimary,
            ),
            todayTextStyle: theme.textTheme.bodyMedium!.copyWith(
              color: colors.onSecondaryContainer,
            ),
            selectedDecoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: colors.secondaryContainer,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: theme.textTheme.titleSmall!.copyWith(
              color: colors.onSurface,
              fontSize: 16,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: colors.onSurface),
            rightChevronIcon: Icon(Icons.chevron_right, color: colors.onSurface),
          ),
          onDaySelected: null,
        ),
      ],
    );
  }
}
