import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/atender/providers/estatus_provider.dart';
import 'package:sgp_movil/features/atender/providers/listar_provider.dart';
import 'package:sgp_movil/features/incidencias/domain/entities/incidencia.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class ListarIncidenciasScreen extends ConsumerStatefulWidget 
{
  final String tipo;
  final String rutaDetalle;

  const ListarIncidenciasScreen({
    super.key,
    required this.tipo,
    required this.rutaDetalle,
  });

  @override
  ConsumerState<ListarIncidenciasScreen> createState() => _ListarIncidenciasState();
}

class _ListarIncidenciasState extends ConsumerState<ListarIncidenciasScreen> 
{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final panelController = DraggableScrollableController();
  late DateTime? fechaIni;
  late DateTime? fechaFin;
  late final String tipo;
  late String nombrePantalla;
  late String estatus;
  late String rutaDetalle;

  @override
  void initState() 
  {
    super.initState();

    final hoy = DateTime.now();
    fechaFin = DateTime(hoy.year, hoy.month, hoy.day);
    fechaIni = fechaFin?.subtract(Duration(days: fechaFin!.weekday - DateTime.monday));

    tipo = widget.tipo;
    rutaDetalle = widget.rutaDetalle;

    if (tipo == 'V') nombrePantalla = 'Vacaciones';
    if (tipo == 'PE') nombrePantalla = 'Permisos';
    if (tipo == 'PR') nombrePantalla = 'Uniformes';
    if (tipo == 'A') nombrePantalla = 'Articulos';

    Future.microtask(() 
    {
      ref.invalidate(estatusSeleccionadoProvider);
      ref.invalidate(listarNotifierProvider(tipo));

      ref.read(estatusSeleccionadoProvider.notifier).state = 'E';
    });
  }

  @override
  void dispose() 
  {
    panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
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
            onPressed: () 
            {
              context.go('/dashboard');
            },
          ),
        ),
        bottomNavigationBar: BotonesFiltradoEstado(
          estadoSeleccionado: estatus,
          onEstadoSeleccionado: (nuevoStatus) 
          {
            ref.read(estatusSeleccionadoProvider.notifier).state = nuevoStatus;
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: 
          [
            BusquedaExpandible(
              initialValue: incidenciasState.busqueda,
              hintText: 'Buscar por nombre',
              searchTooltip: 'Buscar por nombre',
              onChanged: (value) 
              {
                ref.read(listarNotifierProvider(tipo).notifier).setBusqueda(value);
              },
            ),
          ],
        ),
        body: Stack(
          children: 
          [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: _buildLista(incidenciasState),
                    ),
                  ),
                ],
              ),
            ),
            PanelFiltroFecha(
              controller: panelController,
              fechaInicio: fechaIni!,
              fechaFin: fechaFin!,
              onSeleccionarFechaInicio: seleccionarFechaInicio,
              onSeleccionarFechaFin: seleccionarFechaFin,
              onConsultar: buscar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(ListarState incidenciasState) 
  {
    return Builder(
      builder: (context) 
      {
        if (incidenciasState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filtradas = incidenciasState.filtradasPor(estatus);

        if (filtradas.isEmpty) 
        {
          return Align(
            alignment: Alignment(0, -0.25),
            child: EstadoInicialBusqueda(
              icono: Icons.manage_search_rounded,
              titulo: 'Consulta de $nombrePantalla',
              subtitulo: 'Desliza el panel inferior y utiliza los filtros para consultar registros.',
            ),
          );
        }

        return Column(
          children: 
          [
            Expanded(
              child: ListaTarjetaGenerica<Incidencia>(
                items: filtradas,
                getTitle: (incidencia) =>'${incidencia.nombreSolicitante} ${incidencia.primerApSolicitante} ${incidencia.segundoApSolicitante}',
                getSubtitle: (incidencia) => 'Registrado el ${FormatUtil.stringToStandard(incidencia.fechaCaptura)}',
                getRoute: (incidencia) => '/$rutaDetalle/${incidencia.idIncidencia}/${incidencia.codigoTipoIncidencia}/$fechaIni/$fechaFin',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> buscar() async 
  {
    FocusScope.of(context).unfocus();

    await ref.read(listarNotifierProvider(tipo).notifier).cargarInicidencias(fechaIni!, fechaFin!);

    if (mounted) {
      panelController.animateTo(0.12, duration: const Duration(milliseconds: 400), curve: Curves.ease);
    }
  }

  Future<void> seleccionarFechaInicio() async 
  {
    final hoy = DateTime.now();

    final fecha = await customDatePicker(
      context: context,
      initialDate: fechaIni!.isAfter(hoy) ? hoy : fechaIni!,
      firstDate: DateTime(2000),
      lastDate: hoy,
    );

    if (fecha != null) {
      setState(() {
        fechaIni = fecha;

        if (fechaFin!.isBefore(fechaIni!)) {
          fechaFin = fechaIni;
        }
      });
    }
  }

  Future<void> seleccionarFechaFin() async 
  {
    final hoy = DateTime.now();

    final fecha = await customDatePicker(
      context: context,
      initialDate: fechaFin!.isAfter(hoy) ? hoy : fechaFin!,
      firstDate: fechaIni!,
      lastDate: hoy,
    );

    if (fecha != null) {
      setState(() => fechaFin = fecha);
    }
  }
}
