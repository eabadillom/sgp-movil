import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/atender/providers/estatus_provider.dart';
import 'package:sgp_movil/features/atender/providers/listar_provider.dart';
import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class ListarIncidenciasScreen extends ConsumerStatefulWidget {
  final String tipo;
  final String rutaDetalle;

  const ListarIncidenciasScreen({
    super.key,
    required this.tipo,
    required this.rutaDetalle,
  });

  @override
  ConsumerState<ListarIncidenciasScreen> createState() =>
      _ListarIncidenciasState();
}

class _ListarIncidenciasState extends ConsumerState<ListarIncidenciasScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fechaController = TextEditingController();
  late DateTime fechaIni;
  late DateTime fechaFin;
  late final String tipo;
  late String nombrePantalla;
  late String estatus;
  late String rutaDetalle;

  @override
  void initState() {
    super.initState();
    fechaIni = FormatUtil.dateFormated(
      DateTime.now().subtract(const Duration(days: 7)),
    );
    fechaFin = FormatUtil.dateFormated(DateTime.now());
    tipo = widget.tipo;
    rutaDetalle = widget.rutaDetalle;

    if (tipo == 'V') nombrePantalla = 'Vacaciones';
    if (tipo == 'PE') nombrePantalla = 'Permisos';
    if (tipo == 'PR') nombrePantalla = 'Uniformes';
    if (tipo == 'A') nombrePantalla = 'Articulos';

    Future.microtask(() {
      ref.invalidate(estatusSeleccionadoProvider);
      ref.read(estatusSeleccionadoProvider.notifier).state = 'E';

      ref.read(listarNotifierProvider(tipo).notifier).cargarInicidencias(fechaIni, fechaFin);
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

      ref.read(listarNotifierProvider(tipo).notifier).cargarInicidencias(nuevaFecha, fechaFin);
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

      ref.read(listarNotifierProvider(tipo).notifier).cargarInicidencias(fechaIni, nuevaFecha);
    }
  }

  @override
  Widget build(BuildContext context) {
    final incidenciasState = ref.watch(listarNotifierProvider(tipo));
    estatus = ref.watch(estatusSeleccionadoProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            nombrePantalla,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 22),
          ),
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
              const SizedBox(height: 16),
              SelectorPeriodoFecha(
                fechaIni: fechaIni,
                fechaFin: fechaFin,
                onCambiarFechaIni: _cambiarFechaInicial,
                onCambiarFechaFin: _cambiarFechaFinal,
              ),
              BotonesFiltradoEstado(
                estadoSeleccionado: estatus,
                onEstadoSeleccionado: (nuevoStatus) {
                  ref.read(estatusSeleccionadoProvider.notifier).state =
                      nuevoStatus;
                },
              ),
              const SizedBox(height: 6),
              BarraBusquedaNombre(
                onChanged: (value) => ref.read(listarNotifierProvider(tipo).notifier).setBusqueda(value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (incidenciasState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final filtradas = incidenciasState.paginaActualFiltrada(estatus);
                      if(filtradas.isEmpty) {
                        return const Center(
                          child: Text('No hay incidencias con este estado.'),
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListaTarjetaGenerica<Incidencia>(
                                items: filtradas,
                                getTitle: (incidencia) =>
                                    '${incidencia.nombreSolicitante} ${incidencia.primerApSolicitante} ${incidencia.segundoApSolicitante}',
                                getSubtitle: (incidencia) => 
                                    'Registrado el ${FormatUtil.stringToStandard(incidencia.fechaCaptura)}',
                                getRoute: (incidencia) =>
                                    '/$rutaDetalle/${incidencia.idIncidencia}/${incidencia.codigoTipoIncidencia}',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: incidenciasState.paginaActual > 1
                                      ? () => ref
                                          .read(listarNotifierProvider(tipo).notifier)
                                          .cambiarPagina(incidenciasState.paginaActual - 1, estatus)
                                      : null,
                                  child: const Text('Anterior'),
                                ),
                                Text(
                                  'Página ${incidenciasState.paginaActual} de ${incidenciasState.totalPaginas(estatus)}',
                                ),
                                ElevatedButton(
                                  onPressed: incidenciasState.paginaActual <
                                          incidenciasState.totalPaginas(estatus)
                                      ? () => ref
                                          .read(listarNotifierProvider(tipo).notifier)
                                          .cambiarPagina(incidenciasState.paginaActual + 1, estatus)
                                      : null,
                                  child: const Text('Siguiente'),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
