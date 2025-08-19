import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/atender/providers/incidencia_permiso_detalle_provider.dart';
import 'package:sgp_movil/features/atender/providers/listar_provider.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/justificar.dart';
import 'package:sgp_movil/features/shared/shared.dart';

class IncidenciaPermisoScreen extends ConsumerStatefulWidget {
  final int id;
  final String codigo;

  const IncidenciaPermisoScreen({
    super.key,
    required this.id,
    required this.codigo,
  });

  @override
  ConsumerState<IncidenciaPermisoScreen> createState() =>
      _IncidenciaPermisoScreen();
}

class _IncidenciaPermisoScreen extends ConsumerState<IncidenciaPermisoScreen> {
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
  late DateTime fechaIni;
  late DateTime fechaFin;

  @override
  void initState() {
    super.initState();
    idIncidencia = widget.id;
    codigoIncidencia = widget.codigo;

    if (codigoIncidencia.contains('PE')) {
      titulo = 'Permiso';
    }
    if (codigoIncidencia.contains('V')) {
      titulo = 'Vacaciones';
    }

    fechaIni = FormatUtil.dateFormated(
      DateTime.now().subtract(const Duration(days: 7)),
    );
    fechaFin = FormatUtil.dateFormated(DateTime.now());

    /*titulo = codigoIncidencia.contains('PE')
        ? 'Permiso'
        : 'Vacaciones';*/

    Future.microtask(() {
      ref
          .watch(incidenciaPermisoDetalleProvider.notifier)
          .obtenerIncidenciaPermiso(idIncidencia);
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incidenciaPermisoState = ref.watch(incidenciaPermisoDetalleProvider);
    final detalleIncidencia = incidenciaPermisoState.incidenciaPermisoDetalle;
    final deshabilitarBotton =
        detalleIncidencia?.claveEstatus == 'R' ||
        detalleIncidencia?.claveEstatus == 'A';
    final usuario = ref.watch(usuarioDetalleProvider).usuarioDetalle;

    if (incidenciaPermisoState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /*if (incidenciaPermisoState.errorMessage != null) {
      return const Scaffold(
        body: Center(child: Text('Error al cargar el detalle de incidencia')),
      );
    }*/

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Detalle "$titulo"'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EtiquetaRegistroWidget(
                      label: 'Empleado',
                      value:
                          '${detalleIncidencia?.nombreEmpleado ?? ''} ${detalleIncidencia?.primerApEmpleado ?? ''} ${detalleIncidencia?.segundoApEmpleado ?? ''}',
                    ),
                    EtiquetaRegistroWidget(
                      label: 'Fecha Inicio',
                      value: FormatUtil.formatearFechaSimple(
                        detalleIncidencia?.fechaInicio,
                      ),
                    ),
                    EtiquetaRegistroWidget(
                      label: 'Fecha Fin',
                      value: FormatUtil.formatearFechaSimple(
                        detalleIncidencia?.fechaFin,
                      ),
                    ),
                    EtiquetaRegistroWidget(
                      label: 'Estatus',
                      value: estados[detalleIncidencia?.claveEstatus] ?? 'N/A',
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text('Autorizar'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                onPressed:
                                    deshabilitarBotton
                                        ? null
                                        : () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (
                                                  context,
                                                ) => DialogoConfirmacion(
                                                  titulo:
                                                      '¿Deseas aceptar esta incidencia?',
                                                  icono: Icons.check_circle,
                                                  color: Colors.blue,
                                                  onConfirmar: () async {
                                                    await ref
                                                        .read(
                                                          incidenciaPermisoDetalleProvider
                                                              .notifier,
                                                        )
                                                        .actualizarIncidenciaPermiso(
                                                          idIncidencia,
                                                          {
                                                            'codigoEstado': 'A',
                                                            'empleadoRev':
                                                                usuario
                                                                    ?.numeroUsuario,
                                                          },
                                                        );
                                                    ref
                                                        .read(
                                                          listarNotifierProvider(
                                                            codigoIncidencia,
                                                          ).notifier,
                                                        )
                                                        .cargarInicidencias(
                                                          fechaIni,
                                                          fechaFin,
                                                        );
                                                    if (!context.mounted)
                                                      return;
                                                    await CustomSnackBarCentrado.mostrar(
                                                      context,
                                                      mensaje:
                                                          'Incidencia aceptada',
                                                      tipo:
                                                          SnackbarTipo.success,
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
                                icon: const Icon(Icons.cancel),
                                label: const Text('Rechazar'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                onPressed:
                                    deshabilitarBotton
                                        ? null
                                        : () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (
                                                  context,
                                                ) => DialogoConfirmacionRechazo(
                                                  titulo:
                                                      '¿Deseas rechazar esta incidencia?',
                                                  icono: Icons.warning,
                                                  color: Colors.blue,
                                                  onConfirmar: (
                                                    comentario,
                                                  ) async {
                                                    await ref
                                                        .read(
                                                          incidenciaPermisoDetalleProvider
                                                              .notifier,
                                                        )
                                                        .actualizarIncidenciaPermiso(
                                                          idIncidencia,
                                                          {
                                                            'codigoEstado': 'R',
                                                            'descripcionRechazo':
                                                                comentario,
                                                            'empleadoRev':
                                                                usuario
                                                                    ?.numeroUsuario,
                                                          },
                                                        );
                                                    ref
                                                        .read(
                                                          listarNotifierProvider(
                                                            codigoIncidencia,
                                                          ).notifier,
                                                        )
                                                        .cargarInicidencias(
                                                          fechaIni,
                                                          fechaFin,
                                                        );
                                                    if (!context.mounted)
                                                      return;
                                                    await CustomSnackBarCentrado.mostrar(
                                                      context,
                                                      mensaje:
                                                          'Incidencia rechazada',
                                                      tipo: SnackbarTipo.error,
                                                    );
                                                  },
                                                ),
                                          );
                                        },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment:
                              (detalleIncidencia?.claveEstatus == 'E' ||
                                      detalleIncidencia?.claveEstatus == 'R')
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.spaceBetween,
                          children: [
                            // Botón REGRESAR - usa Expanded solo si también se muestra el botón "Cancelar"
                            if (codigoIncidencia.contains('V') &&
                                detalleIncidencia?.claveEstatus == 'A')
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Regresar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    context.pop();
                                  },
                                ),
                              )
                            else
                              ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Regresar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                onPressed: () {
                                  context.pop();
                                },
                              ),

                            // Separador solo si se mostrará el botón "Cancelar"
                            if (codigoIncidencia.contains('V') &&
                                detalleIncidencia?.claveEstatus == 'A')
                              const SizedBox(width: 12),

                            // Botón CANCELAR - condicional
                            if (codigoIncidencia.contains('V') &&
                                detalleIncidencia?.claveEstatus == 'A')
                              Expanded(
                                child: FilledButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Cancelar'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    textStyle: const TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => DialogoConfirmacion(
                                            titulo:
                                                '¿Deseas cancelar esta incidencia?',
                                            icono: Icons.warning,
                                            color: Colors.blue,
                                            onConfirmar: () async {
                                              String mensaje = '';
                                              SnackbarTipo tipo =
                                                  SnackbarTipo.success;
                                              try {
                                                await ref
                                                    .read(
                                                      incidenciaPermisoDetalleProvider
                                                          .notifier,
                                                    )
                                                    .actualizarIncidenciaPermiso(
                                                      idIncidencia,
                                                      {
                                                        'codigoEstado': 'C',
                                                        'empleadoRev':
                                                            usuario
                                                                ?.numeroUsuario,
                                                      },
                                                    );
                                                ref
                                                    .read(
                                                      listarNotifierProvider(
                                                        codigoIncidencia,
                                                      ).notifier,
                                                    )
                                                    .cargarInicidencias(
                                                      fechaIni,
                                                      fechaFin,
                                                    );
                                                mensaje =
                                                    'Incidencia Cancelada correctamente';
                                              } catch (e) {
                                                mensaje = e.toString();
                                                tipo = SnackbarTipo.error;
                                              } finally {
                                                if (context.mounted) {
                                                  await CustomSnackBarCentrado.mostrar(
                                                    context,
                                                    mensaje: mensaje,
                                                    tipo: tipo,
                                                  );
                                                }
                                              }
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
    );
  }
}

class DialogoConfirmacion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final Future<void> Function() onConfirmar;

  const DialogoConfirmacion({
    super.key,
    required this.titulo,
    required this.icono,
    required this.color,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(icono, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(titulo, style: TextStyle(fontSize: 16.0))),
        ],
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: color),
          onPressed: () async {
            await onConfirmar(); // Espera antes de cerrar el diálogo
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Sí'),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(backgroundColor: Colors.red.shade400),
          onPressed: () => Navigator.pop(context),
          child: const Text('No', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
