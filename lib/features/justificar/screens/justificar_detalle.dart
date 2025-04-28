import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/shared/widgets/side_menu.dart';

class JusitificarDetalle extends StatefulWidget {
  const JusitificarDetalle({super.key});

  @override
  State<JusitificarDetalle> createState() => _JusitificarDetalleState();
}

class _JusitificarDetalleState extends State<JusitificarDetalle> {
  late final String titulo;
  late final RegistroDetalle registroDetalle;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String formtearFecha(DateTime? fecha) {
    return DateFormat('dd/MM/yyyy - HH:mm:ss').format(fecha!);
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Nombre: ${registroDetalle.nombreEmpleado} ${registroDetalle.primerApEmpleado} ${registroDetalle.segundoApEmpleado}',
            ),
            const SizedBox(height: 8),
            Text('Lugar: ${registroDetalle.plantaEmpleado}'),
            const SizedBox(height: 8),
            Text(
              'Fecha de entrada: ${formtearFecha(registroDetalle.fechaEntrada)}',
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha de salida: ${formtearFecha(registroDetalle.fechaSalida)}',
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
  }
}
