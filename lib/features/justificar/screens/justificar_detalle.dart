import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/justificar.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

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

    Widget? renderEtiqueta(String label, String? value) {
      if (value == null || value.trim().isEmpty) return null;
      return EtiquetaRegistroWidget(label: label, value: value);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Justificación de "$titulo"',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 22),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ...[
                  renderEtiqueta('Empleado', '${detalle?.nombreEmpleado ?? ''} ${detalle?.primerApEmpleado ?? ''} ${detalle?.segundoApEmpleado ?? ''}'),
                  renderEtiqueta('Planta', detalle?.plantaEmpleado ?? ''),
                  calendarDayCard(detalle?.fechaEntrada, detalle?.fechaSalida),
                ].whereType<Widget>(),

                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      label: const Text(
                        'Regresar',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                      onPressed: () => {
                        context.pop(false),
                      },
                    ),

                    const SizedBox(width: 10),
                    
                    ElevatedButton.icon(
                      icon: const Icon(Icons.event_available, color: Colors.white),
                      label: const Text(
                        'Justificar',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
                            /*final messenger = ScaffoldMessenger.of(context);*/

                            if (state.errorMessage == null) {
                              /*messenger.showSnackBar(const SnackBar(content: Text('Registro justificado exitosamente'), duration: Duration(seconds: 2)));*/
                              CustomSnackBarCentrado.mostrar(
                                context,
                                mensaje: 'Registro justificado exitosamente',
                                tipo: SnackbarTipo.success,
                              );
                              await Future.delayed(const Duration(seconds: 2));

                              // Verifica de nuevo antes de navegar
                              if (!context.mounted) return;
                              
                              context.pop(true);
                              
                              /*messenger.showSnackBar(SnackBar(content: Text(state.errorMessage!)));*/
                              CustomSnackBarCentrado.mostrar(
                                context,
                                mensaje: state.errorMessage!,
                                tipo: SnackbarTipo.error,
                              );
                            }
                          },
                        );
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

Widget calendarDayCard(DateTime? fechaEntrada, DateTime? fechaSalida) {
  if (fechaEntrada == null) {
    return const Text("Sin fecha registrada");
  }

  DateTime? entrada = FormatUtil.dateFormatedWithHour(fechaEntrada);
  DateTime? salida = fechaSalida != null ? FormatUtil.dateFormatedWithHour(fechaSalida) : null;
  
  final dia = entrada.day;
  final mes = DateFormat('MMM', 'es').format(entrada).toUpperCase();
  
  final horaEntrada = DateFormat('HH:mm').format(entrada);
  final horaSalida = salida != null ? DateFormat('HH:mm').format(salida) : null;

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                mes, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '$dia', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Entrada: $horaEntrada", style: const TextStyle(fontSize: 16), ),

            if(horaSalida != null)
              Text("Salida: $horaSalida", style: const TextStyle(fontSize: 16), ),
          ],
        )
      ],
    ),
  );
}
