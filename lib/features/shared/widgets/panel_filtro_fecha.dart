import 'package:flutter/material.dart';
import 'package:sgp_movil/features/shared/widgets/date_tile_widget.dart';

class PanelFiltroFecha extends StatelessWidget 
{
  final DraggableScrollableController controller;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final VoidCallback onSeleccionarFechaInicio;
  final VoidCallback onSeleccionarFechaFin;
  final VoidCallback onConsultar;

  const PanelFiltroFecha({super.key, required this.controller, required this.fechaInicio, required this.fechaFin, required this.onSeleccionarFechaInicio, required this.onSeleccionarFechaFin, required this.onConsultar});

  @override
  Widget build(BuildContext context) 
  {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.12, 0.45, 0.85],
      builder: (context, scrollController) 
      {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: 
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: 
              [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: 
                  [
                    Icon(
                      Icons.tune_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filtros de búsqueda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: 
                  [
                    Expanded(
                      child: DateTileWidget(
                        label: 'Desde',
                        date: fechaInicio,
                        onTap: onSeleccionarFechaInicio,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DateTileWidget(
                        label: 'Hasta',
                        date: fechaFin,
                        onTap: onSeleccionarFechaFin,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: onConsultar,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text(
                    'Consultar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
