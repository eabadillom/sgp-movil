import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';
import 'package:sgp_movil/features/shared/widgets/side_menu.dart';

class JusitificarDetalle extends ConsumerStatefulWidget {
  final int id;
  final String codigo;

  const JusitificarDetalle({
    required this.id,
    required this.codigo,
    super.key
  });

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
  void initState() 
  {
    super.initState();
    idRegistro = widget.id;
    codigoRegistro = widget.codigo;
    
    if(codigoRegistro.contains('F'))
    {
      titulo = 'Falta';
    }
    if(codigoRegistro.contains('R'))
    {
      titulo = 'Retardo';
    }
  }

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
            Text('id: $idRegistro'),
            const SizedBox(height: 8),

            /*Text(
              'Nombre: ${registroState.registro?.nombreEmpleado} ${registroState.registro?.primerApEmpleado} ${registroState.registro?.segundoApEmpleado}',
            ),
            const SizedBox(height: 8),
            Text('Lugar: ${registroState.registro?.plantaEmpleado}'),
            const SizedBox(height: 8),
            Text(
              'Fecha de entrada: ${formtearFecha(registroState.registro?.fechaEntrada)}',
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha de salida: ${formtearFecha(registroState.registro?.fechaSalida)}',
            ),*/
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
