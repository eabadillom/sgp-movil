import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/justificar.dart';
import 'package:sgp_movil/features/shared/widgets/dialogo_confirmacion.dart';
import 'package:sgp_movil/features/shared/widgets/side_menu.dart';

class JusitificarDetalle extends ConsumerStatefulWidget {
  final int id;
  final String codigo;

  const JusitificarDetalle({required this.id, required this.codigo, super.key});

  @override
  ConsumerState<JusitificarDetalle> createState() => _JusitificarDetalleState();
}

class _JusitificarDetalleState extends ConsumerState<JusitificarDetalle> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final String titulo;
  late int idRegistro;
  late String codigoRegistro;

  @override
  void initState() {
    super.initState();
    idRegistro = widget.id;
    codigoRegistro = widget.codigo;

    if (codigoRegistro.contains('F')) {
      titulo = 'Ausencia';
    }
    if (codigoRegistro.contains('R')) {
      titulo = 'Retardo';
    }

    Future.microtask(() {
      ref.read(justificarDetalleProvider.notifier).cargarRegistro(idRegistro);
    });
  }

  @override
  Widget build(BuildContext context) {
    final registroState = ref.watch(justificarDetalleProvider);

    if (registroState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (registroState.errorMessage != null) {
      return Scaffold(body: Center(child: Text('Error al cargar los datos')));
    }

    final detalle = registroState.registroDetalle;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Justificación de "$titulo"'),
        actions: [
          IconButton(
            icon: Icon(Icons.keyboard_return_sharp),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      drawer: SideMenu(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
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
                      '${detalle?.nombreEmpleado ?? ''} ${detalle?.primerApEmpleado ?? ''} ${detalle?.segundoApEmpleado ?? ''}',
                ),
                EtiquetaRegistroWidget(
                  label: 'Planta',
                  value: detalle?.plantaEmpleado ?? '',
                ),
                EtiquetaRegistroWidget(
                  label: 'Entrada',
                  value: FormatUtil.formatearFecha(detalle?.fechaEntrada),
                ),
                EtiquetaRegistroWidget(
                  label: 'Salida',
                  value: FormatUtil.formatearFecha(detalle?.fechaSalida),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'Justificar',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Fondo azul
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                      onPressed: () {
                        // Acción para justificar
                        dialogoConfirmacion(
                          context,
                          '¿Estás seguro de que deseas justificar?',
                          () async {
                            final notifier = ref.read(justificarDetalleProvider.notifier);
                            await notifier.actualizarEstadoRegistro(idRegistro, {
                              'codigoRegistro': 'J',
                            });

                            // Verifica si el widget sigue montado
                            if (!context.mounted) return;

                            final state = ref.read(justificarDetalleProvider);
                            final messenger = ScaffoldMessenger.of(context);

                            if (state.errorMessage == null) {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Registro justificado exitosamente'),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              await Future.delayed(const Duration(seconds: 5));

                              // Verifica de nuevo antes de navegar
                              if (!context.mounted) return;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JustificarListScreen(codigo: codigoRegistro),
                                ),
                              );
                            } else {
                              messenger.showSnackBar(
                                SnackBar(content: Text(state.errorMessage!)),
                              );
                            }
                          },
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'Mantener',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey, // Fondo rojo
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                      onPressed: () => {
                        context.pop(),
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
