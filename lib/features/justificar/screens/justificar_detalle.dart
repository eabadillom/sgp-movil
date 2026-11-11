import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/justificar.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

class JusitificarDetalle extends ConsumerStatefulWidget
{
  final int id;
  final String codigo;

  const JusitificarDetalle({required this.id, required this.codigo, super.key});

  @override
  ConsumerState<JusitificarDetalle> createState() => _JusitificarDetalleState();
}

class _JusitificarDetalleState extends ConsumerState<JusitificarDetalle>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final String titulo;
  late int idRegistro;
  late String codigoRegistro;

  @override
  void initState()
  {
    super.initState();
    idRegistro = widget.id;
    codigoRegistro = widget.codigo;

    titulo = codigoRegistro.contains('F') ? 'Ausencia' : codigoRegistro.contains('R') ? 'Retardo' : 'Registro';

    Future.microtask(() 
    {
      ref.read(justificarDetalleProvider.notifier).cargarRegistro(idRegistro);
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final registroState = ref.watch(justificarDetalleProvider);
    final colors = Theme.of(context).colorScheme;

    if (registroState.isLoading)
    {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (registroState.errorMessage != null)
    {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Justificar $titulo',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
              [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No se pudo cargar el detalle.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Regresar'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.grey.shade200,
                    side: BorderSide(color: Colors.grey.shade600, width: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final detalle = registroState.registroDetalle;

    Widget? renderEtiqueta(String label, String? value)
    {
      if (value == null || value.trim().isEmpty) return null;
      return EtiquetaRegistroWidget(label: label, value: value);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Justificar $titulo',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()
          {
            context.pop(false);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewPadding.bottom + 32,
        ),
        child: Card(
          elevation: 2,
          color: colors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                ...[
                  renderEtiqueta('Empleado', '${detalle?.nombreEmpleado ?? ''} ${detalle?.primerApEmpleado ?? ''} ${detalle?.segundoApEmpleado ?? ''}'),
                  renderEtiqueta('Planta', detalle?.plantaEmpleado ?? ''),
                  calendarDayCard(context, detalle?.fechaEntrada, detalle?.fechaSalida),
                ].whereType<Widget>(),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 16),

                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children:
                    [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Regresar'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.grey.shade200,
                          side: BorderSide(color: Colors.grey.shade600, width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        ),
                        onPressed: () => {context.pop(false)},
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.event_available),
                        label: const Text('Justificar'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        ),
                        onPressed: ()
                        {
                          // Acción para justificar
                          dialogoConfirmacion(context, '¿Estás seguro de que deseas justificar?', () async
                          {
                            final notifier = ref.read(justificarDetalleProvider.notifier);
                            await notifier.actualizarEstadoRegistro(idRegistro, {'codigoRegistro': 'J'});

                            if (!context.mounted) return;

                            final state = ref.read(justificarDetalleProvider);
                            if (state.errorMessage != null)
                            {
                              CustomSnackBarCentrado.mostrar(context, mensaje: state.errorMessage!, tipo: SnackbarTipo.error);
                              return;
                            }

                            CustomSnackBarCentrado.mostrar(context, mensaje: 'Registro justificado exitosamente', tipo: SnackbarTipo.success);
                            await Future.delayed(const Duration(seconds: 2));

                            if (!context.mounted) return;
                            context.pop(false);
                          },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget calendarDayCard(BuildContext context, DateTime? fechaEntrada, DateTime? fechaSalida)
{
  final colors = Theme.of(context).colorScheme;
  if (fechaEntrada == null)
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Text(
        'Sin fecha registrada',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }

  DateTime? entrada = FormatUtil.dateFormatedWithHour(fechaEntrada);
  DateTime? salida = fechaSalida != null ? FormatUtil.dateFormatedWithHour(fechaSalida) : null;

  final dia = entrada.day;
  final mes = DateFormat('MMM', 'es').format(entrada).toUpperCase();
  final anio = entrada.year.toString();
  final horaEntrada = DateFormat('HH:mm').format(entrada);
  final horaSalida = salida != null ? DateFormat('HH:mm').format(salida) : null;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.outlineVariant),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children:
            [
              Text(
                mes,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.onPrimaryContainer, fontWeight: FontWeight.w700),
              ),
              Text(
                '$dia',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: colors.onPrimaryContainer, fontWeight: FontWeight.w700),
              ),
              Text(
                anio,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onPrimaryContainer),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
          [
            Text(
              'Entrada',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
            Text(
              horaEntrada,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            if (horaSalida != null) 
            ...[
              const SizedBox(height: 8),
              Text(
                'Salida',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                horaSalida,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
