import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_list_provider.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class JustificarListScreen extends ConsumerStatefulWidget {
  final String codigo;

  const JustificarListScreen({super.key, required this.codigo});

  @override
  ConsumerState<JustificarListScreen> createState() => _JustificarListState();
}

class _JustificarListState extends ConsumerState<JustificarListScreen> {
  final TextEditingController _fechaController = TextEditingController();
  late DateTime fechaIni;
  late DateTime fechaFin;
  late String codigo;
  late String nombrePantalla;

  @override
  void initState() {
    super.initState();
    fechaIni = FormatUtil.dateFormated(
      DateTime.now().subtract(const Duration(days: 7)),
    );
    fechaFin = FormatUtil.dateFormated(DateTime.now());
    codigo = widget.codigo;

    if (codigo == 'F') {
      nombrePantalla = 'Ausencias';
    }

    if (codigo == 'R') {
      nombrePantalla = 'Retardos';
    }

    Future.microtask(() {
      ref
          .read(justificarNotifierProvider.notifier)
          .cargarRegistros(fechaIni, fechaFin, codigo);
    });
  }

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
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
      ref
          .read(justificarNotifierProvider.notifier)
          .cargarRegistros(nuevaFecha, fechaFin, codigo);
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
      ref
          .read(justificarNotifierProvider.notifier)
          .cargarRegistros(fechaIni, nuevaFecha, codigo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final registroState = ref.watch(justificarNotifierProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(nombrePantalla),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop()) 
              {
                Navigator.of(context).pop();
              } else {
                context.go('/dashboard');
              }
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
                    (value) => ref
                        .read(justificarNotifierProvider.notifier)
                        .setBusqueda(value),
              ),
              const SizedBox(height: 16),
              SelectorPeriodoFecha(
                fechaIni: fechaIni,
                fechaFin: fechaFin,
                onCambiarFechaIni: _cambiarFechaInicial,
                onCambiarFechaFin: _cambiarFechaFinal,
              ),
              const SizedBox(height: 16),
              if (registroState.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (registroState.registros.isEmpty)
                const Expanded(
                  child: Center(child: Text('No hay registros disponibles.')),
                )
              else
                Expanded(
                  child: ListaTarjetaGenerica<Registro>(
                    items: registroState.registrosFiltrados,
                    getTitle:
                        (registro) =>
                            '${registro.nombreEmpleado} ${registro.primerApEmpleado} ${registro.segundoApEmpleado}',
                    getSubtitle:
                        (registro) =>
                            FormatUtil.stringToStandard(registro.fechaEntrada),
                    getRoute:
                        (registro) =>
                            '/detalle/${registro.id}/${registro.codigoRegistro}', // Ruta personalizada
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
