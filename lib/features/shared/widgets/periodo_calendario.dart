import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PeriodoCalendario extends StatelessWidget 
{
  final List<DateTime> fechas;

  const PeriodoCalendario({
    super.key,
    required this.fechas,
  });

  @override
  Widget build(BuildContext context) 
  {
    if (fechas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Row(
          children: [
            const Text(
              'Días solicitados: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.purple.shade200, borderRadius: BorderRadius.circular(8),),
              child: Text(
                '${fechas.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal,),
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

          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),

          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),

          onDaySelected: null,
        ),
      ],
    );
  }
}