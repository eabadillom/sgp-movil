import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/features/atender/providers/incidencia_permiso_detalle_provider.dart';
import 'package:sgp_movil/features/atender/providers/listar_provider.dart';
import 'package:sgp_movil/features/atender/screens/screens.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/justificar.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class IncidenciaPermisoScreen extends ConsumerStatefulWidget 
{
  final int id;
  final String codigo;

  const IncidenciaPermisoScreen({
    super.key,
    required this.id,
    required this.codigo,
  });

  @override
  ConsumerState<IncidenciaPermisoScreen> createState() => _IncidenciaPermisoScreen();
}

class _IncidenciaPermisoScreen extends ConsumerState<IncidenciaPermisoScreen> 
{
  final Map<String, String> estados = {
    'E': 'Enviado',
    'A': 'Aprobado',
    'R': 'Rechazado',
    'C': 'Cancelado',
  };
  final TextEditingController _comentarioController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final String titulo;
  late int idIncidencia;
  late String codigoIncidencia;
  late DateTime? fechaIni;
  late DateTime? fechaFin;

  @override
  void initState() 
  {
    super.initState();
    idIncidencia = widget.id;
    codigoIncidencia = widget.codigo;

    titulo = codigoIncidencia.contains('PE') ? 'Permiso' : codigoIncidencia.contains('V') ? 'Vacaciones' : 'Incidencia';

    final hoy = DateTime.now();
    fechaFin = DateTime(hoy.year, hoy.month, hoy.day);
    fechaIni = fechaFin?.subtract(Duration(days: fechaFin!.weekday - DateTime.monday));

    Future.microtask(() 
    {
      ref.watch(incidenciaPermisoDetalleProvider.notifier).obtenerIncidenciaPermiso(idIncidencia);
    });
  }

  @override
  void dispose() 
  {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final incidenciaPermisoState = ref.watch(incidenciaPermisoDetalleProvider);
    final detalleIncidencia = incidenciaPermisoState.incidenciaPermisoDetalle;
    final puedeResolver = detalleIncidencia?.claveEstatus == 'E';
    final puedeCancelar = codigoIncidencia.contains('V') && detalleIncidencia?.claveEstatus == 'A';
    final usuario = ref.watch(usuarioDetalleProvider).usuarioDetalle;

    if (incidenciaPermisoState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (incidenciaPermisoState.errorMessage != null) 
    {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalle de $titulo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 22,
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
                  'No se pudo cargar el detalle de la solicitud.',
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

    final colors = Theme.of(context).colorScheme;
    final colorEstado = switch (detalleIncidencia?.claveEstatus) 
    {
      'A' => Colors.green.shade700,
      'R' || 'C' => Colors.red.shade700,
      _ => colors.primary,
    };

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Detalle de $titulo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                        EtiquetaRegistroWidget(
                          label: 'Empleado',
                          value: '${detalleIncidencia?.nombreEmpleado ?? ''} ${detalleIncidencia?.primerApEmpleado ?? ''} ${detalleIncidencia?.segundoApEmpleado ?? ''}'.trim(),
                        ),
                        if (detalleIncidencia != null && detalleIncidencia.periodo.isNotEmpty)
                          PeriodoCalendario(fechas: detalleIncidencia.periodo),
                        EtiquetaRegistroWidget(
                          label: 'Estatus',
                          value: estados[detalleIncidencia?.claveEstatus] ?? 'N/A',
                          backgroundColor: colorEstado,
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: 
                          [
                            if (puedeResolver) 
                            ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: 
                                [
                                  Expanded(
                                    child: FilledButton.icon(
                                      icon: const Icon(Icons.cancel),
                                      label: const Text('Rechazar'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red.shade700,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () 
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (context) => 
                                            DialogoConfirmacionRechazo(
                                              titulo: '¿Deseas rechazar esta incidencia?',
                                              icono: Icons.warning,
                                              color: Colors.blue,
                                              onConfirmar: (comentario) async 
                                              {
                                                await ref.read(incidenciaPermisoDetalleProvider.notifier).actualizarIncidenciaPermiso(idIncidencia, {'codigoEstado': 'R', 'descripcionRechazo': comentario, 'empleadoRev': usuario?.numeroUsuario});
                                                ref.read(listarNotifierProvider(codigoIncidencia).notifier).cargarInicidencias(fechaIni!, fechaFin!);
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                await CustomSnackBarCentrado.mostrar(
                                                  context,
                                                  mensaje: 'Incidencia rechazada',
                                                  tipo: SnackbarTipo.error,
                                                );
                                              },
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton.icon(
                                      icon: const Icon(Icons.check),
                                      label: const Text('Autorizar'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.green.shade700,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      ),
                                      onPressed: () 
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (context) => 
                                            DialogoConfirmacion(
                                              titulo: '¿Deseas aceptar esta incidencia?',
                                              icono: Icons.check_circle,
                                              color: Colors.blue,
                                              onConfirmar: () async 
                                              {
                                                await ref.read(incidenciaPermisoDetalleProvider.notifier).actualizarIncidenciaPermiso(idIncidencia, {'codigoEstado': 'A', 'empleadoRev': usuario ?.numeroUsuario});
                                                ref.read(listarNotifierProvider(codigoIncidencia).notifier).cargarInicidencias(fechaIni!, fechaFin!);
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                await CustomSnackBarCentrado.mostrar(context, mensaje: 'Incidencia aceptada', tipo: SnackbarTipo.success);
                                              },
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                            ],

                            Row(
                              mainAxisAlignment: puedeCancelar ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                              children: [
                                if (puedeCancelar)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text('Regresar'),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade600,
                                        foregroundColor: Colors.grey.shade200,
                                        side: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 1.5,
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      ),
                                      onPressed: () 
                                      {
                                        context.pop();
                                      },
                                    ),
                                  )
                                else
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Regresar'),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade600,
                                      foregroundColor: Colors.grey.shade200,
                                      side: BorderSide(
                                        color: Colors.grey.shade600,
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                    onPressed: () {
                                      context.pop();
                                    },
                                  ),

                                if (puedeCancelar)
                                  const SizedBox(width: 12),

                                if (puedeCancelar)
                                  Expanded(
                                    child: FilledButton.icon(
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Cancelar'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: colors.error,
                                        foregroundColor: colors.onError,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () 
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (context) => 
                                            DialogoConfirmacion(
                                              titulo: '¿Deseas cancelar esta incidencia?',
                                              icono: Icons.warning,
                                              color: Colors.blue,
                                              onConfirmar: () async 
                                              {
                                                String mensaje = '';
                                                SnackbarTipo tipo = SnackbarTipo.success;
                                                try {
                                                  await ref.read(incidenciaPermisoDetalleProvider.notifier).actualizarIncidenciaPermiso(idIncidencia, {'codigoEstado': 'C', 'empleadoRev': usuario?.numeroUsuario});
                                                  ref.read(listarNotifierProvider(codigoIncidencia).notifier).cargarInicidencias(fechaIni!, fechaFin!);
                                                  mensaje = 'Incidencia Cancelada correctamente';
                                                } catch (e) {
                                                  String mensjaeError = e.toString();
                                                  String mensajeFinal = mensjaeError.replaceAll('Exception: ', '');
                                                  mensaje = mensajeFinal;

                                                  tipo = SnackbarTipo.error;
                                                } finally {
                                                  if (context.mounted) {
                                                    await CustomSnackBarCentrado.mostrar(context, mensaje: mensaje, tipo: tipo);
                                                  }
                                                }
                                                if (!context.mounted) return;
                                                context.pop();
                                              },
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
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
      ),
    );
  }
}
