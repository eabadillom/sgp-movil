import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/widgets/widgets.dart';
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
  //late final RegistroDetalle registroDetalle;
  late int idRegistro;
  late String codigoRegistro;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    idRegistro = widget.id;
    codigoRegistro = widget.codigo;

    if (codigoRegistro.contains('F')) {
      titulo = 'Falta';
    }
    if (codigoRegistro.contains('R')) {
      titulo = 'Retardo';
    }

    Future.microtask(() {
      ref.read(justificarDetalleProvider.notifier).cargarRegistro(idRegistro);
    });
  }

  String formtearFecha(DateTime? fecha) {
    return DateFormat('dd/MM/yyyy - HH:mm:ss').format(fecha ?? DateTime.now());
  }

  /*
  @override
  Widget build(BuildContext context) {
    final registroState = ref.watch(justificarDetalleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Justificacion de "$titulo"'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: SideMenu(scaffoldKey: _scaffoldKey),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /*Text('id: $idRegistro'),
            const SizedBox(height: 8),*/
            Text(
              'Nombre: ${registroState.registroDetalle?.nombreEmpleado} ${registroState.registroDetalle?.primerApEmpleado} ${registroState.registroDetalle?.segundoApEmpleado}',
            ),
            const SizedBox(height: 8),
            Text('Lugar: ${registroState.registroDetalle?.plantaEmpleado}'),
            const SizedBox(height: 8),
            Text(
              'Fecha de entrada: ${formtearFecha(registroState.registroDetalle?.fechaEntrada)}',
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha de salida: ${formtearFecha(registroState.registroDetalle?.fechaSalida)}',
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Justificar')),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Mantener'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }*/

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
                  value: formtearFecha(detalle?.fechaEntrada),
                ),
                EtiquetaRegistroWidget(
                  label: 'Salida',
                  value: formtearFecha(detalle?.fechaSalida),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Justificar'),
                      onPressed: () {
                        // Acción para justificar
                      },
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Mantener'),
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
