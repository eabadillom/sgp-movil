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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DraggableScrollableController _panelController = DraggableScrollableController();
  final Map<String, Color> estados = {'A': Colors.greenAccent.shade100, 'C': Colors.redAccent.shade100};
  late DateTime? fechaIni;
  late DateTime? fechaFin;

  @override
  void initState() 
  {
    super.initState();

    final hoy = DateTime.now();
    fechaFin = DateTime(hoy.year, hoy.month, hoy.day);
    fechaIni = fechaFin!.subtract(Duration(days: fechaFin!.weekday - DateTime.monday));
  }

  @override
  void dispose() 
  {
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final incapacidadState = ref.watch(incapacidadNotifierProvider);
    final esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    final coloresEstado = esModoOscuro
        ? const <String, Color>{
            'A': Color(0xFF245A45),
            'C': Color(0xFF633B3B),
          }
        : estados;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SideMenu(scaffoldKey: _scaffoldKey),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Incapacidades',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 22),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: 
          [
            BusquedaExpandible(
              initialValue: incapacidadState.busqueda,
              hintText: 'Buscar por nombre',
              searchTooltip: 'Buscar por nombre',
              onChanged: (value) 
              {
                ref.read(incapacidadNotifierProvider.notifier).setBusqueda(value);
              },
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'agregarIncapacidad',
              tooltip: 'Agregar incapacidad',
              onPressed: () => context.push('/agregarIncapacidad'),
              child: const Icon(Icons.add),
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
                      child: _buildLista(incapacidadState, coloresEstado),
                    ),
                  ),
                ],
              ),
            ),
            PanelFiltroFecha(
              controller: _panelController,
              fechaInicio: fechaIni!,
              fechaFin: fechaFin!,
              onSeleccionarFechaInicio: _seleccionarFechaInicio,
              onSeleccionarFechaFin: _seleccionarFechaFin,
              onConsultar: _buscar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(IncapacidadState state, Map<String, Color> coloresEstado) 
  {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final registros = state.filtradasPor();

    if (registros.isEmpty) 
    {
      return const EstadoInicialBusqueda(
        icono: Icons.manage_search_rounded,
        titulo: 'Consulta de incapacidades',
        subtitulo: 'Desliza el panel inferior y utiliza los filtros para consultar registros.',
      );
    }

    return Column(
      children: 
      [
        Expanded(
          child: ListaTarjetaGenerica<Incapacidad>(
            items: registros,
            getTitle: (incapacidad) => '${incapacidad.nombreInc} ${incapacidad.primerApInc} ${incapacidad.segundoApInc}',
            getSubtitle: (incapacidad) => 'Registrado el ${FormatUtil.stringToStandard(incapacidad.fechaCaptura)}',
            getBackgroundColor: (incapacidad) => coloresEstado[incapacidad.clave],
            onTap: (incapacidad) async 
            {
              final result = await context.push('/incapacidadDetalle/${incapacidad.idIncapacidad}');
              
              if (result == true) {
                ref.read(incapacidadNotifierProvider.notifier).obtenerRegistros(fechaIni!, fechaFin!);
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _buscar() async 
  {
    FocusScope.of(context).unfocus();

    await ref.read(incapacidadNotifierProvider.notifier).obtenerRegistros(fechaIni!, fechaFin!);

    if (mounted) {
      _panelController.animateTo(0.12, duration: const Duration(milliseconds: 400), curve: Curves.ease);
    }
  }

  Future<void> _seleccionarFechaInicio() async 
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

  Future<void> _seleccionarFechaFin() async 
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
