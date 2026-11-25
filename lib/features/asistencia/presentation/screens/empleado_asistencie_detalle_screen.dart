import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/features/asistencia/domain/domain.dart';
import 'package:sgp_movil/features/asistencia/presentation/providers/providers.dart';

class EmpleadoAsistencieDetalleScreen extends ConsumerStatefulWidget 
{
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int idEmpleado;

  const EmpleadoAsistencieDetalleScreen({super.key, required this.fechaInicio, required this.fechaFin, required this.idEmpleado});

  @override
  ConsumerState<EmpleadoAsistencieDetalleScreen> createState() => _EmpleadoAsistencieDetalleState();
}

class _EmpleadoAsistencieDetalleState extends ConsumerState<EmpleadoAsistencieDetalleScreen> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime fechaInicio;
  late DateTime fechaFin;
  late int idEmpleado;

  @override
  void initState() 
  {
    super.initState();

    fechaInicio = widget.fechaInicio;
    fechaFin = widget.fechaFin;
    idEmpleado = widget.idEmpleado;

    Future.microtask(() 
    {
      ref.read(empleadoDetalleNotifierProvider.notifier).obtenerEmpleadoDetalle(fechaInicio, fechaFin, idEmpleado);
      ref.read(estatusRegistroNotifierProvider.notifier).obtenerEstatusRegistros();
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final empleadoDetalle = ref.watch(empleadoDetalleNotifierProvider);
    final estatusRegistro = ref.watch(estatusRegistroNotifierProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Detalle del empleado",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: SafeArea(
          child: _buildContent(empleadoDetalle, estatusRegistro)
        ),
      ),
    );
  }

  Widget _buildContent(EmpleadoDetalleState empleadoState, EstatusRegistroState estatusState) 
  {
    if (empleadoState.isLoading) 
    {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (empleadoState.errorMessage != null) 
    {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            empleadoState.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    final empleado = empleadoState.empleadoDetalle;
    if (empleado == null) {
      return const Center(child: Text('No hay información del empleado.'));
    }

    final colorScheme = Theme.of(context).colorScheme;
    final formatoFecha = DateFormat('dd/MM/yyyy', 'es');
    final estatusPorCodigo = {
      for (final estatus in estatusState.estatusRegistro)
        estatus.codigo: estatus,
    };
    final registrosPorFecha = {
      for (final registro in empleado.registroAsistencia)
        _claveFecha(registro.fechaEntrada): registro,
    };
    final dias = _diasDelPeriodo();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: 
      [
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline_rounded)),
            title: Text(
              '${empleado.nombre} ${empleado.primerAp} ${empleado.segundoAp}'.trim(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Periodo de asistencia',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            '${_formatearFechaPeriodo(fechaInicio)} al ${_formatearFechaPeriodo(fechaFin)}',
            textAlign: TextAlign.center, 
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        if (estatusState.isLoading) 
        ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
        ],
        if (estatusState.errorMessage != null) 
        ...[
          const SizedBox(height: 12),
          Text(
            'No fue posible cargar las descripciones de los estados: '
            '${estatusState.errorMessage}',
            style: TextStyle(color: colorScheme.error),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          'Registros por día',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (dias.isEmpty)
          const Text('El periodo seleccionado no contiene fechas.')
        else
          for (final dia in dias)
            _buildRegistroDia(dia, registrosPorFecha[_claveFecha(dia)], estatusPorCodigo, formatoFecha, colorScheme),
      ],
    );
  }

  Widget _buildRegistroDia(DateTime dia, RegistroAsistencia? registro, Map<String, EstatusRegistro> estatusPorCodigo, DateFormat formatoFecha, ColorScheme colorScheme) 
  {
    final estatus = registro == null ? null : estatusPorCodigo[registro.codigoRegistro];
    final color = registro == null ? colorScheme.outline : _colorPorCodigo(registro.codigoRegistro, colorScheme);
    final etiqueta = registro == null ? 'Sin registro' : estatus?.descripcion ?? 'Código ${registro.codigoRegistro}';
    final nombreDia = DateFormat('EEEE', 'es').format(dia);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: Text('${dia.day}'),
        ),
        title: Text('${nombreDia[0].toUpperCase()}${nombreDia.substring(1)}'),
        subtitle: Text(formatoFecha.format(dia)),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                etiqueta,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DateTime> _diasDelPeriodo() 
  {
    final inicio = DateTime(fechaInicio.year, fechaInicio.month, fechaInicio.day);
    final fin = DateTime(fechaFin.year, fechaFin.month, fechaFin.day);
    final dias = <DateTime>[];

    for (
      var dia = inicio;
      !dia.isAfter(fin);
      dia = DateTime(dia.year, dia.month, dia.day + 1)
    ) {
      dias.add(dia);
    }

    return dias;
  }

  String _claveFecha(DateTime fecha) => '${fecha.year}-${fecha.month}-${fecha.day}';

  String _formatearFechaPeriodo(DateTime fecha) 
  {
    final nombreDia = DateFormat('EEE', 'es').format(fecha).toLowerCase();
    final fechaFormateada = DateFormat('dd/MM/yyyy', 'es').format(fecha);
    return '$nombreDia-$fechaFormateada';
  }

  Color _colorPorCodigo(String codigo, ColorScheme colorScheme) 
  {
    return switch (codigo) 
    {
      'T' => Colors.green,
      'R' => Colors.orange,
      'F' => Colors.red,
      'J' => Colors.lightGreen,
      'V' => Colors.lightBlue.shade400,
      'X' => Colors.brown.shade400,
      'D' => Colors.blueGrey.shade200,
      'P' => Colors.lightBlue.shade800,
      'I' => Colors.deepPurple,
      'O' => Colors.blueGrey.shade500,
      'N' => Colors.blueGrey.shade700,
      _ => colorScheme.secondary,
    };
  }
}
