import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_list_provider.dart';
import 'package:sgp_movil/features/justificar/screens/justificar_detalle.dart';
//import 'package:sgp_movil/conf/util/format_util.dart';

class JustificarListScreen extends ConsumerStatefulWidget 
{
  final DateTime fechaIni;
  final String codigo;
  final String nombrePantalla;
  
  const JustificarListScreen({
    super.key,
    required this.fechaIni,
    required this.codigo,
    required this.nombrePantalla,
  });

  @override
  ConsumerState<JustificarListScreen> createState() => _JustificarListState();
}

class _JustificarListState extends ConsumerState<JustificarListScreen>
{
  final TextEditingController _fechaController = TextEditingController();
  late DateTime fechaSeleccionada;
  late String codigo;
  late String nombrePantalla;

  @override
  void initState() 
  {
    super.initState();
    fechaSeleccionada = FormatUtil.dateFormated(widget.fechaIni);
    codigo = widget.codigo;
    nombrePantalla = widget.nombrePantalla;
    
    Future.microtask(() 
    {
      ref.read(justificarNotifierProvider.notifier).cargarRegistros(fechaSeleccionada, codigo);
    });
  }

  @override
  void dispose() 
  {
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _cambiarFecha() async 
  {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2000), //Cambiar fecha de inicio de calendario
      lastDate: DateTime(2100), //Cambiar fecha de fin de calendario
    );

    if (nuevaFecha != null) 
    {
      setState(() 
      {
        fechaSeleccionada = nuevaFecha;
      });

      // Llamar manualmente al notifier
      ref.read(justificarNotifierProvider.notifier).cargarRegistros(nuevaFecha, codigo);
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final registroState = ref.watch(justificarNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(nombrePantalla),
      ), 
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Campo de búsqueda dentro del Row
                Expanded
                (
                  child: TextField
                  (
                    decoration: const InputDecoration(
                      hintText: 'Buscar por nombre',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) 
                    {
                      ref.read(justificarNotifierProvider.notifier).setBusqueda(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Fecha:'),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _cambiarFecha,
                  child: Text(FormatUtil.stringDateFormated(fechaSeleccionada)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if(registroState.isLoading) 
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if(registroState.registros.isEmpty)
              const Center(child: Center(child: Text('No hay registros disponibles.')))
            else
              Expanded(// Lista de registros
                child: ListView.builder(
                  itemCount: registroState.registrosFiltrados.length,
                  itemBuilder: (context, index) 
                  {
                    final registro = registroState.registrosFiltrados[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 4, // sombra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('${registro.nombreEmpleado} ${registro.primerApEmpleado} ${registro.segundoApEmpleado}'),
                        subtitle: Text(FormatUtil.stringDateFormated(registro.fechaEntrada)),
                        leading: const Icon(Icons.person),
                        onTap: () 
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JusitificarDetalle(id: registro.id, codigo: registro.codigoRegistro),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

