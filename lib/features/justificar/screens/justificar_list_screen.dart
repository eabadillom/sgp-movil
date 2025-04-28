import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
//import 'package:sgp_movil/conf/util/format_util.dart';

class FaltasRetardosScreen extends StatefulWidget 
{
  const FaltasRetardosScreen({super.key,});

  /*@override
  Widget build(BuildContext context) 
  {
    //final scaffoldKey = GlobalKey<ScaffoldState>();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    final DateTime fechaIni = extra?['fecha'] ?? DateTime.now();
    final String codigo = extra?['codigo'] ?? 'Sin Código';
    final String nombrePantalla = extra?['nombrePantalla'] ?? 'Sin Nombre';

    return Scaffold(
      appBar: AppBar(
        title: Text(nombrePantalla),
      ),
      body: _FaltasRetardosView(
        fechaIni: fechaIni,
        codigo: codigo,
      ),
    );
  }*/
  @override
  State<FaltasRetardosScreen> createState() => _FaltasRetardosView();
}

class _FaltasRetardosView extends State<FaltasRetardosScreen>
{
  final TextEditingController _fechaController = TextEditingController();
  DateTime? fechaSeleccionada;

  @override
  void dispose() 
  {
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> seleccionarFecha({DateTime? fechaInicial}) async {
    final DateTime fechaMostrar = fechaInicial ?? DateTime.now();

    final DateTime? fechaEscogida = await showDatePicker(
      context: context,
      initialDate: fechaMostrar,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fechaEscogida != null) {
      setState(() {
        fechaSeleccionada = fechaEscogida;
        _fechaController.text = FormatUtil.formatearFecha(fechaEscogida);
      });
    }
  }


  @override
  Widget build(BuildContext context) 
  {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final DateTime fechaIni = extra?['fecha'] ?? DateTime.now();
    final String codigo = extra?['codigo'] ?? 'Sin Código';
    final String nombrePantalla = extra?['nombrePantalla'] ?? 'Sin Nombre';
    final String fecha = FormatUtil.formatearFecha(fechaIni);

    /*return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Código: $codigo', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text('Fecha hace una semana: ${FormatUtil.formatearFecha(fechaIni.toLocal())}', style: const TextStyle(fontSize: 20)),
          ],
        )
      ),
    );*/
    return Scaffold(
      appBar: AppBar(title: Text(nombrePantalla)), // aquí uso el parámetro "titulo"
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                controller: _fechaController,
                readOnly: true,
                onTap: () {
                  seleccionarFecha(fechaInicial: fechaIni); // aquí uso el parámetro "fechaBase"
                },
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  hintText: fecha,  
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Código: $codigo', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('Fecha hace una semana: ${FormatUtil.formatearFecha(fechaIni.toLocal())}', style: const TextStyle(fontSize: 20)),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

