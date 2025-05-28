import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/incapacidades/domain/entities/incapacidad.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_list_provider.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class IncapacidadListScreen extends ConsumerStatefulWidget
{
  const IncapacidadListScreen({super.key});

  @override
  ConsumerState<IncapacidadListScreen> createState() => _IncapacidadListState();
}

class _IncapacidadListState extends ConsumerState<IncapacidadListScreen> 
{
  final TextEditingController _fechaController = TextEditingController();
  late DateTime fechaIni;
  late DateTime fechaFin;
  late String nombrePantalla;

  @override
  void initState() 
  {
    super.initState();

    fechaIni = FormatUtil.dateFormated(
      DateTime.now().subtract(const Duration(days: 7)),
    );

    fechaFin = FormatUtil.dateFormated(DateTime.now());

    nombrePantalla = 'Incapacidades';
    
    Future.microtask(() {
      ref.read(incapacidadNotifierProvider.notifier).obtenerRegistros(fechaIni, fechaFin);
    });
  }

  @override
  void dispose() 
  {
    super.dispose();

    _fechaController.dispose();
  }

  Future<void> _cambiarFechaInicial() async {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaIni,
      firstDate: DateTime(2000), //Cambiar fecha de inicio de calendario
      lastDate: DateTime(2100), //Cambiar fecha de fin de calendario
    );

    if (nuevaFecha != null) {
      setState(() {
        fechaIni = FormatUtil.dateFormated(nuevaFecha);
      });

      // Llamar manualmente al notifier
      ref.read(incapacidadNotifierProvider.notifier).obtenerRegistros(nuevaFecha, fechaFin);
    }
  }

  Future<void> _cambiarFechaFinal() async {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaFin,
      firstDate: DateTime(2000), //Cambiar fecha de inicio de calendario
      lastDate: DateTime(2100), //Cambiar fecha de fin de calendario
    );

    if (nuevaFecha != null) {
      setState(() {
        fechaFin = FormatUtil.dateFormated(nuevaFecha);
      });

      // Llamar manualmente al notifier
      ref.read(incapacidadNotifierProvider.notifier).obtenerRegistros(fechaIni, nuevaFecha);
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final incapacidadState = ref.watch(incapacidadNotifierProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(nombrePantalla),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/dashboard');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BarraBusquedaNombre(
                onChanged:
                  (value) => ref.read(incapacidadNotifierProvider.notifier).setBusqueda(value),
              ),
              const SizedBox(height: 16),
              SelectorPeriodoFecha(
                fechaIni: fechaIni,
                fechaFin: fechaFin,
                onCambiarFechaIni: _cambiarFechaInicial,
                onCambiarFechaFin: _cambiarFechaFinal,
              ),
              const SizedBox(height: 16),
              if(incapacidadState.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (incapacidadState.incapacidades.isEmpty)
                const Expanded(
                  child: Center(child: Text('No hay registros disponibles.')),
                )
              else
                Expanded(
                  child: ListaTarjetaGenerica<Incapacidad>(
                    items: incapacidadState.registrosFiltrados,
                    getTitle:
                        (incapacidad) =>
                            '${incapacidad.nombreInc} ${incapacidad.primerApInc} ${incapacidad.segundoApInc}',
                    getSubtitle:
                        (incapacidad) =>
                            FormatUtil.stringToStandard(incapacidad.fechaCaptura),
                    getRoute:
                        (incapacidad) =>
                            '/incapacidadDetalle/${incapacidad.idIncapacidad}', // Ruta personalizada
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
