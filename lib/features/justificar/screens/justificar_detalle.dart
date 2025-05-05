import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/screens/justificar_list_screen.dart';
import 'package:sgp_movil/features/justificar/widgets/widgets.dart';
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
  late final String titulo;
  late int idRegistro;
  late String codigoRegistro;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
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
                            ref
                                .read(justificarDetalleProvider.notifier)
                                .actualizarEstadoRegistro(idRegistro, {
                                  'codigoRegistro': 'J',
                                });

                            final state = ref.read(justificarDetalleProvider);

                            if (state.errorMessage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Registro justificado exitosamente',
                                  ),
                                  duration: Duration(
                                    seconds: 2,
                                  ), // visible por 2 segundos
                                ),
                              );

                              await Future.delayed(Duration(seconds: 5));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JustificarListScreen(codigo: codigoRegistro),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                      onPressed: () {
                        Navigator.pop(context);
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
