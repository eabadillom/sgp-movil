import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/util/date_pikcer_util.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/atender/providers/estatus_provider.dart';
import 'package:sgp_movil/features/atender/providers/fecha_provider.dart';
import 'package:sgp_movil/features/atender/providers/listar_provider.dart';
import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class ListarIncidenciasScreen extends ConsumerStatefulWidget {
  final String tipo;

  const ListarIncidenciasScreen({super.key, required this.tipo});

  @override
  ConsumerState<ListarIncidenciasScreen> createState() =>
      _ListarIncidenciasState();
}

class _ListarIncidenciasState extends ConsumerState<ListarIncidenciasScreen> {
  final TextEditingController _fechaController = TextEditingController();
  late DateTime fechaIni;
  late DateTime fechaFin;
  late String tipo;
  late String nombrePantalla;
  late String estatus;

  late ProviderSubscription<DateTime> _removeFechaIniListener;
  late ProviderSubscription<DateTime> _removeFechaFinListener;
  late ProviderSubscription<String> _removeEstatusListener;

  @override
  void initState() {
    super.initState();
    tipo = widget.tipo;

    if (tipo == 'PE') nombrePantalla = 'Permisos';
    if (tipo == 'V') nombrePantalla = 'Vacaciones';

    Future.microtask(() {
      final estatus = ref.read(estatusSeleccionadoProvider);
      final fechaIni = ref.read(fechaInicialProvider);
      final fechaFin = ref.read(fechaFinalProvider);

      ref
          .read(listarNotifierProvider.notifier)
          .cargarInicidencias(tipo, estatus, fechaIni, fechaFin);

      _removeFechaIniListener =
          ref.listenManual(fechaInicialProvider, (prev, next) {
                final estatus = ref.read(estatusSeleccionadoProvider);
                final fechaFin = ref.read(fechaFinalProvider);
                ref
                    .read(listarNotifierProvider.notifier)
                    .cargarInicidencias(tipo, estatus, next, fechaFin);
              });

      _removeFechaFinListener =
          ref.listenManual(fechaFinalProvider, (prev, next) {
                final estatus = ref.read(estatusSeleccionadoProvider);
                final fechaIni = ref.read(fechaInicialProvider);
                ref
                    .read(listarNotifierProvider.notifier)
                    .cargarInicidencias(tipo, estatus, fechaIni, next);
              });

      _removeEstatusListener =
          ref.listenManual(estatusSeleccionadoProvider, (prev, next) {
                final fechaIni = ref.read(fechaInicialProvider);
                final fechaFin = ref.read(fechaFinalProvider);
                ref
                    .read(listarNotifierProvider.notifier)
                    .cargarInicidencias(tipo, next, fechaIni, fechaFin);
              });
    });
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _removeFechaIniListener.close();
    _removeFechaFinListener.close();
    _removeEstatusListener.close();
    super.dispose();
  }

  Future<void> _cambiarFechaInicial() async {
    final fechaActual = ref.read(fechaInicialProvider);
    final fechaFin = ref.read(fechaFinalProvider);

    await seleccionarFechaConAccion(
      context: context,
      fechaActual: fechaActual,
      maxFecha: fechaFin,
      onFechaSeleccionada: (nuevaFecha) async {
        ref.read(fechaInicialProvider.notifier).state = nuevaFecha;
      },
    );
  }

  Future<void> _cambiarFechaFinal() async {
    final fechaActual = ref.read(fechaFinalProvider);
    final fechaIni = ref.read(fechaInicialProvider);

    await seleccionarFechaConAccion(
      context: context,
      fechaActual: fechaActual,
      minFecha: fechaIni,
      onFechaSeleccionada: (nuevaFecha) async {
        ref.read(fechaFinalProvider.notifier).state = nuevaFecha;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidenciasState = ref.watch(listarNotifierProvider);
    estatus = ref.watch(estatusSeleccionadoProvider);
    fechaIni = ref.watch(fechaInicialProvider);
    fechaFin = ref.watch(fechaFinalProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(nombrePantalla)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BotonesFiltradoEstado(
                estadoSeleccionado: estatus,
                onEstadoSeleccionado: (nuevoStatus) {
                  ref.read(estatusSeleccionadoProvider.notifier).state =
                      nuevoStatus;
                },
              ),
              const SizedBox(height: 16),
              SelectorPeriodoFecha(
                fechaIni: fechaIni,
                fechaFin: fechaFin,
                onCambiarFechaIni: _cambiarFechaInicial,
                onCambiarFechaFin: _cambiarFechaFinal,
              ),
              BarraBusquedaNombre(
                onChanged:
                    (value) => ref
                        .read(listarNotifierProvider.notifier)
                        .setBusqueda(value),
              ),
              const SizedBox(height: 16),
              if (incidenciasState.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (incidenciasState.incidencias.isEmpty)
                const Expanded(
                  child: Center(child: Text('No hay incidencias disponibles.')),
                )
              else
                Expanded(
                  child: ListaTarjetaGenerica<Incidencia>(
                    items: incidenciasState.incidenciasFiltradas,
                    getTitle:
                        (incidencia) =>
                            '${incidencia.nombreSolicitante} ${incidencia.primerApSolicitante} ${incidencia.segundoApSolicitante}',
                    getSubtitle:
                        (incidencia) => FormatUtil.stringToStandard(
                          incidencia.fechaCaptura,
                        ),
                    getRoute: (incidencia) => 
                        '/incidenciaPermisoDetalle/${incidencia.idIncidencia}/${incidencia.codigoEstadoIncidencia}',
                    // Ruta personalizada
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
