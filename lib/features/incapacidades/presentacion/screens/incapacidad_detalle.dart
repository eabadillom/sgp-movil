import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/incapacidades/controller/controller.dart';
import 'package:sgp_movil/features/incapacidades/domain/entities/incapacidad_detalle.dart'
    as incapacidad_model;
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/widgets/etiqueta_registro_widget.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

class IncapacidadDetalle extends ConsumerStatefulWidget 
{
  final int id;

  const IncapacidadDetalle({super.key, required this.id});

  @override
  ConsumerState<IncapacidadDetalle> createState() => _IncapacidadDetalleState();
}

class _IncapacidadDetalleState extends ConsumerState<IncapacidadDetalle> 
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final String titulo;
  late int idIncapacidad;

  @override
  void initState() 
  {
    super.initState();
    idIncapacidad = widget.id;
    titulo = 'Incapacidad Detalle';

    Future.microtask(() 
    {
      ref.read(incapacidadDetalleProvider.notifier).obtenerIncapacidad(idIncapacidad);
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final incapacidadState = ref.watch(incapacidadDetalleProvider);
    final detalleIncapacidad = incapacidadState.incapacidadDetalle;
    final usuarioDetalleState = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final bool botonesHabilitados = detalleIncapacidad?.estatusIncapacidad != 'Cancelada';
    final estatusIncapacidad = detalleIncapacidad?.estatusIncapacidad.toLowerCase() ?? '';
    final colorEstado = estatusIncapacidad.contains('cancel') ? Colors.red.shade700 : estatusIncapacidad.contains('aprob') || estatusIncapacidad.contains('acept') ||  estatusIncapacidad.contains('autoriz') ? Colors.green.shade700 : colors.tertiary;

    if (incapacidadState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (incapacidadState.errorMessage != null) 
    {
      return Scaffold(
        appBar: AppBar(title: Text(titulo)),
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
                  color: colors.error,
                ),
                const SizedBox(height: 12),
                Text(
                  'No se pudo cargar el detalle de la incapacidad.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.grey.shade200,
                    side: BorderSide(color: Colors.grey.shade600, width: 1.5),
                  ),
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Regresar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget? renderEtiqueta(String label, String? value, Color? backgroundColor) 
    {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      return EtiquetaRegistroWidget(label: label, value: value, backgroundColor: backgroundColor);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titulo,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () 
          {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewPadding.bottom + 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Card(
                color: colors.surfaceContainerLow,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colors.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: 
                    [
                      if (detalleIncapacidad?.nombreInc != null || detalleIncapacidad?.primerApInc != null || detalleIncapacidad?.segundoApInc != null)
                        EtiquetaRegistroWidget(
                          label: 'Empleado',
                          value: '${detalleIncapacidad?.nombreInc ?? ''} ${detalleIncapacidad?.primerApInc ?? ''} ${detalleIncapacidad?.segundoApInc ?? ''}'.trim(),
                        ),
                      ...[
                        renderEtiqueta( 'Tipo de incapacidad', detalleIncapacidad?.tipoIncapacidad, null),
                        renderEtiqueta('Control de incapacidad', detalleIncapacidad?.controlIncapacidad, null),
                        renderEtiqueta('Riesgo de trabajo', detalleIncapacidad?.riesgoTrabajo, null),
                        renderEtiqueta('Tipo de riesgo', detalleIncapacidad?.tipoRiesgo, null),
                        renderEtiqueta('Folio', detalleIncapacidad?.folio, null),
                        renderEtiqueta('Descripción', detalleIncapacidad?.descripcion, null),
                        if (detalleIncapacidad != null && detalleIncapacidad.periodo.isNotEmpty)
                          PeriodoCalendario(fechas: detalleIncapacidad.periodo),
                        renderEtiqueta('Estatus', detalleIncapacidad?.estatusIncapacidad, colorEstado),
                      ].whereType<Widget>(),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.pop(false),
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: const Text('Regresar'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.grey.shade600,
                                foregroundColor: Colors.grey.shade200,
                                side: BorderSide(color: Colors.grey.shade600, width: 1.5),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: botonesHabilitados && usuarioDetalleState != null && detalleIncapacidad != null ? () => _cancelarIncapacidad(context, usuarioDetalleState.numeroUsuario, detalleIncapacidad) : null,
                              icon: const Icon(Icons.cancel_outlined),
                              label: const Text(
                                'Cancelar',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: colors.error,
                                foregroundColor: colors.onError,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _cancelarIncapacidad(BuildContext context, String numeroUsuario, incapacidad_model.IncapacidadDetalle detalleIncapacidad) async 
  {
    final confirmar = await mostrarConfirmacion(context);
    if (confirmar != true || !context.mounted) return;

    try {
      await ref.read(incapacidadDetalleProvider.notifier).cancelarIncapacidad(numeroUsuario, IncapacidadDetalleMapper.toJson(detalleIncapacidad));

      if (!context.mounted) return;

      await CustomSnackBarCentrado.mostrar(context, mensaje: 'Incapacidad actualizada', tipo: SnackbarTipo.success);

      if (!context.mounted) return;
      context.pop(true);
    } catch (e) {
      if (!context.mounted) return;

      await CustomSnackBarCentrado.mostrar(context, mensaje: 'Error: $e', tipo: SnackbarTipo.error);
    }
  }

  Future<bool?> mostrarConfirmacion(BuildContext context) 
  {
    return showDialog<bool>(
      context: context,
      builder: (context) => 
        AlertDialog(
          title: const Text('Confirmar cancelación incapacidad'),
          content: const Text('¿Estás seguro que deseas cancelar esta incapacidad?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(true),
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('No'),
            ),
          ],
        ),
    );
  }
}
