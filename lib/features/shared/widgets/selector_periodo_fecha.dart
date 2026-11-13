import 'package:flutter/material.dart';
import 'package:sgp_movil/conf/util/format_util.dart';

class SelectorPeriodoFecha extends StatelessWidget 
{
  final DateTime fechaIni;
  final DateTime fechaFin;
  final VoidCallback onCambiarFechaIni;
  final VoidCallback onCambiarFechaFin;

  const SelectorPeriodoFecha({super.key, required this.fechaIni, required this.fechaFin, required this.onCambiarFechaIni, required this.onCambiarFechaFin});

  @override
  Widget build(BuildContext context) 
  {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: 
      [
        Expanded(
          child: _PeriodoFecha(
            label: 'Desde',
            fecha: FormatUtil.stringToStandard(fechaIni),
            textTheme: textTheme,
            onPressed: onCambiarFechaIni,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PeriodoFecha(
            label: 'Hasta',
            fecha: FormatUtil.stringToStandard(fechaFin),
            textTheme: textTheme,
            onPressed: onCambiarFechaFin,
          ),
        ),
      ],
    );
  }
}

class _PeriodoFecha extends StatelessWidget 
{
  final String label;
  final String fecha;
  final TextTheme textTheme;
  final VoidCallback onPressed;

  const _PeriodoFecha({required this.label, required this.fecha, required this.textTheme, required this.onPressed});

  @override
  Widget build(BuildContext context) 
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(label, style: textTheme.labelMedium),
        ),
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.calendar_today_outlined, size: 16),
          label: Text(fecha, maxLines: 1, overflow: TextOverflow.ellipsis),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ],
    );
  }
}
