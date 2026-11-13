import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_list_provider.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class JustificarListScreen extends ConsumerStatefulWidget 
{
  final String codigo;

  const JustificarListScreen({super.key, required this.codigo});

  @override
  ConsumerState<JustificarListScreen> createState() => _JustificarListState();
}

class _JustificarListState extends ConsumerState<JustificarListScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DraggableScrollableController _panelController = DraggableScrollableController();
  late DateTime? fechaIni;
  late DateTime? fechaFin;
  late String codigo;
  late String nombrePantalla;

  @override
  void initState() 
  {
    super.initState();

    final hoy = DateTime.now();
    fechaFin = DateTime(hoy.year, hoy.month, hoy.day);
    fechaIni = fechaFin!.subtract(Duration(days: fechaFin!.weekday - DateTime.monday));
    codigo = widget.codigo;

    if (codigo == 'F') {
      nombrePantalla = 'Ausencias';
    } else if (codigo == 'R') {
      nombrePantalla = 'Retardos';
    }
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
    final registroState = ref.watch(justificarNotifierProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SideMenu(scaffoldKey: _scaffoldKey),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            nombrePantalla,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22),
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
              initialValue: registroState.busqueda,
              hintText: 'Buscar por nombre',
              searchTooltip: 'Buscar por nombre',
              onChanged: (value) 
              {
                ref.read(justificarNotifierProvider.notifier).setBusqueda(value);
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
                      child: _buildLista(registroState),
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

  Widget _buildLista(JustificarState state) 
  {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final registros = state.filtradasPor();

    if (registros.isEmpty) 
    {
      return EstadoInicialBusqueda(
        icono: Icons.manage_search_rounded,
        titulo: 'Consulta de $nombrePantalla',
        subtitulo: 'Desliza el panel inferior y utiliza los filtros para consultar registros.',
      );
    }

    return Column(
      children: 
      [
        Expanded(
          child: ListaTarjetaGenerica<Registro>(
            items: registros,
            getTitle: (registro) => '${registro.nombreEmpleado} ${registro.primerApEmpleado} ${registro.segundoApEmpleado}',
            getSubtitle: (registro) => 'Registrado el ${FormatUtil.stringToStandard(registro.fechaEntrada)}',
            onTap: (registro) async 
            {
              final result = await context.push('/detalle/${registro.id}/${registro.codigoRegistro}');
              if (result == true) {
                ref.read(justificarNotifierProvider.notifier).cargarRegistros(fechaIni!, fechaFin!, codigo);
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

    await ref.read(justificarNotifierProvider.notifier).cargarRegistros(fechaIni!, fechaFin!, codigo);

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
