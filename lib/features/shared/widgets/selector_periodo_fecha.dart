import 'package:flutter/material.dart';
import 'package:sgp_movil/conf/util/format_util.dart';

class SelectorPeriodoFecha extends StatelessWidget {
  final DateTime fechaIni;
  final DateTime fechaFin;
  final VoidCallback onCambiarFechaIni;
  final VoidCallback onCambiarFechaFin;

  const SelectorPeriodoFecha({
    super.key,
    required this.fechaIni,
    required this.fechaFin,
    required this.onCambiarFechaIni,
    required this.onCambiarFechaFin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Inicio'),
        const SizedBox(width: 3),
        Expanded(
          child: ElevatedButton(
            onPressed: onCambiarFechaIni,
            child: Text(
              FormatUtil.stringToStandard(fechaIni),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Fin'),
        const SizedBox(width: 3),
        Expanded(
          child: ElevatedButton(
            onPressed: onCambiarFechaFin,
            child: Text(
              FormatUtil.stringToStandard(fechaFin),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
