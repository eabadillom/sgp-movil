import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/features/asistencia/presentation/providers/providers.dart';
import 'package:sgp_movil/features/asistencia/presentation/widgets/semana_corte.dart';
import 'package:sgp_movil/features/empresas/domain/entities/empresa.dart';
import 'package:sgp_movil/features/empresas/presentation/providers.dart';
import 'package:sgp_movil/features/plantas/domain/entities/planta.dart';
import 'package:sgp_movil/features/plantas/presentation/providers/providers.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class EmpleadoAsistenciaScreen extends ConsumerStatefulWidget 
{
  const EmpleadoAsistenciaScreen({super.key});

  @override
  ConsumerState<EmpleadoAsistenciaScreen> createState() => _EmpleadoAsistenciaState();
}

class _EmpleadoAsistenciaState extends ConsumerState<EmpleadoAsistenciaScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fechaController = TextEditingController();
  final panelController = DraggableScrollableController();

  late SemanaCorte _semana;
  SemanaCorte? _semanaConsultada;
  Planta? _plantaSeleccionada;
  Empresa? _empresaSeleccionada;
  bool _haBuscado = false;

  @override
  void initState() 
  {
    super.initState();
    _semana = SemanaCorte.actual();

    Future.microtask(() 
    {
      ref.read(plantaNotifierProvider.notifier).cargarPlantas();
      ref.read(empresaNotifierProvider.notifier).cargarEmpresas();
    });
  }

  @override
  void dispose() 
  {
    _fechaController.dispose();

    super.dispose();
  }

  void _cambiarSemana(SemanaCorte nueva) 
  {
    setState(() => _semana = nueva);
  }

  @override
  Widget build(BuildContext context) 
  {
    final empleadoState = ref.watch(empleadoNotifierProvider);
    final plantaState = ref.watch(plantaNotifierProvider);
    final empresaState = ref.watch(empresaNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<PlantaState>(plantaNotifierProvider, (previous, next) 
    {
      final mensaje = next.errorMessage;
      if (mensaje != null && mensaje != previous?.errorMessage) {
        CustomSnackBarCentrado.mostrar(
          context,
          mensaje: mensaje,
          tipo: SnackbarTipo.error,
        );
      }
    });

    ref.listen<EmpresaState>(empresaNotifierProvider, (previous, next) 
    {
      final mensaje = next.errorMessage;
      if (mensaje != null && mensaje != previous?.errorMessage) {
        CustomSnackBarCentrado.mostrar(
          context,
          mensaje: mensaje,
          tipo: SnackbarTipo.error,
        );
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Asistencia de Empleados"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () 
            {
              context.go('/dashboard');
            },
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: 
          [
            BusquedaExpandible(
              initialValue: empleadoState.busqueda,
              hintText: 'Buscar por nombre',
              searchTooltip: 'Buscar por nombre',
              onChanged: (value) 
              {
                ref.read(empleadoNotifierProvider.notifier).setBusqueda(value);
              },
            ),
          ],
        ),
        body: Stack(
          children: 
          [
            _buildMainContent(empleadoState),
            _buildFilterSheet(context, isDark, plantaState, empresaState, empleadoState),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(EmpleadoState empleadoState) 
  {
    Widget contenido;

    if (empleadoState.isLoading) {
      contenido = const Center(child: CircularProgressIndicator.adaptive());
    } else if (empleadoState.errorMessage != null) 
    {
      contenido = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            empleadoState.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    } else if (empleadoState.filtradasPor().isEmpty) 
    {
      contenido = Align(
        alignment: const Alignment(0, -0.25),
        child: EstadoInicialBusqueda(
          icono: Icons.manage_search_rounded,
          titulo: _haBuscado ? 'Sin resultados' : 'Consulta de Asistencia',
          subtitulo: _haBuscado ? 'No se encontraron empleados para los filtros seleccionados.' : 'Desliza el panel inferior y utiliza los filtros para consultar registros.',
        ),
      );
    } else 
    {
      final empleados = empleadoState.filtradasPor();
      contenido = Scrollbar(
        thumbVisibility: empleados.length > 1,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
          itemCount: empleados.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) 
          {
            if (index == 0) 
            {
              return Row(
                children: [
                  Text(
                    'Empleados encontrados',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${empleados.length}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }

            final empleado = empleados[index - 1];
            final nombre ='${empleado.nombre} ${empleado.primerAp} ${empleado.segundoAp}'.trim();
            final semanaConsultada = _semanaConsultada;
            final inicial = nombre.isEmpty ? '?' : nombre[0].toUpperCase();

            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  child: Text(
                    inicial,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: semanaConsultada == null ? null : const Icon(Icons.chevron_right_rounded),
                onTap: semanaConsultada == null ? null : () => 
                  context.pushNamed(
                    'detalleAsistenciaEmpleado',
                    queryParameters: 
                    {
                      'idEmpleado': empleado.id.toString(),
                      'fechaInicio': semanaConsultada.inicio.toIso8601String(),
                      'fechaFin': semanaConsultada.fin.toIso8601String(),
                    },
                  ),
              ),
            );
          },
        ),
      );
    }

    return Positioned.fill(child: contenido);
  }

  Widget _buildFilterSheet(BuildContext context, bool isDark, PlantaState plantaState, EmpresaState clienteState, EmpleadoState empleadoState) 
  {
    return DraggableScrollableSheet(
      controller: panelController,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.85,
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
                CustomDropdown<Planta>(
                  items: plantaState.plantas,
                  value: _plantaSeleccionada,
                  label: 'Planta',
                  itemLabelBuilder: (planta) => planta.descripcion,
                  onChanged: (planta) 
                  {
                    setState(() => _plantaSeleccionada = planta);
                  },
                  enabled: !plantaState.isLoading && plantaState.plantas.isNotEmpty,
                ),
                if (plantaState.isLoading) 
                ...[
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 16),
                CustomDropdown<Empresa>(
                  items: clienteState.empresas,
                  value: _empresaSeleccionada,
                  label: 'Empresa',
                  itemLabelBuilder: (empresa) => empresa.descripcion,
                  onChanged: (empresa) 
                  {
                    setState(() => _empresaSeleccionada = empresa);
                  },
                  enabled: !clienteState.isLoading && clienteState.empresas.isNotEmpty,
                ),
                if (clienteState.isLoading) 
                ...[
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(),
                ],
                const SizedBox(height: 16),
                _buildSelectorSemana(),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: empleadoState.isLoading || _plantaSeleccionada == null || _empresaSeleccionada == null ? null : buscar,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Buscar asistencia'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                if (_plantaSeleccionada == null || _empresaSeleccionada == null) 
                ...[
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona una planta y una empresa para buscar.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectorSemana() 
  {
    final f = DateFormat('EEE-dd/MM/yyyy', 'es');
    final esActual = !SemanaCorte.actual().inicio.isAfter(_semana.inicio);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: 
      [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _cambiarSemana(_semana.anterior()),
        ),
        Text(
          '${f.format(_semana.inicio)} al ${f.format(_semana.fin)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          // No permite avanzar más allá de la semana en curso
          onPressed: esActual ? null : () => _cambiarSemana(_semana.siguiente()),
        ),
      ],
    );
  }

  Future<void> buscar() async 
  {
    final planta = _plantaSeleccionada;
    final empresa = _empresaSeleccionada;
    if (planta == null || empresa == null) return;

    FocusScope.of(context).unfocus();
    final semanaConsultada = _semana;
    setState(() 
    {
      _haBuscado = true;
      _semanaConsultada = semanaConsultada;
    });

    await ref.read(empleadoNotifierProvider.notifier).cargarEmpleados(semanaConsultada.inicio, semanaConsultada.fin, planta.id, empresa.id);

    if (mounted) 
    {
      panelController.animateTo(0.12, duration: const Duration(milliseconds: 400), curve: Curves.ease);
    }
  }
}
