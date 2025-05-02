import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/justificar/providers/justificar_list_provider.dart';
import 'package:sgp_movil/features/justificar/screens/justificar_detalle.dart';
import 'package:sgp_movil/features/registro/domain/domain.dart';

class JustificarListScreen extends ConsumerStatefulWidget 
{
  final DateTime fechaIni;
  final DateTime fechaFin;
  final String codigo;
  final String nombrePantalla;
  
  const JustificarListScreen({
    super.key,
    required this.fechaIni,
    required this.fechaFin,
    required this.codigo,
    required this.nombrePantalla,
  });

  @override
  ConsumerState<JustificarListScreen> createState() => _JustificarListState();
}

class _JustificarListState extends ConsumerState<JustificarListScreen>
{
  final TextEditingController _fechaController = TextEditingController();
  late DateTime fechaIni;
  late DateTime fechaFin;
  late String codigo;
  late String nombrePantalla;

  @override
  void initState() 
  {
    super.initState();
    fechaIni = FormatUtil.dateFormated(widget.fechaIni);
    fechaFin = FormatUtil.dateFormated(widget.fechaFin);
    codigo = widget.codigo;
    nombrePantalla = widget.nombrePantalla;
    
    Future.microtask(() 
    {
      ref.read(justificarNotifierProvider.notifier).cargarRegistros(fechaIni, fechaFin, codigo);
    });
  }

  @override
  void dispose() 
  {
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _cambiarFechaInicial() async 
  {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaIni,
      firstDate: DateTime(2000), //Cambiar fecha de inicio de calendario
      lastDate: DateTime(2100), //Cambiar fecha de fin de calendario
    );

    if(nuevaFecha != null) 
    {
      setState(() 
      {
        fechaIni = FormatUtil.dateFormated(nuevaFecha);
      });

      // Llamar manualmente al notifier
      ref.read(justificarNotifierProvider.notifier).cargarRegistros(nuevaFecha, fechaFin, codigo);
    }
  }

  Future<void> _cambiarFechaFinal() async 
  {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaFin,
      firstDate: DateTime(2000), //Cambiar fecha de inicio de calendario
      lastDate: DateTime(2100), //Cambiar fecha de fin de calendario
    );

    if(nuevaFecha != null) 
    {
      setState(() 
      {
        fechaFin = FormatUtil.dateFormated(nuevaFecha);
      });

      // Llamar manualmente al notifier
      ref.read(justificarNotifierProvider.notifier).cargarRegistros(fechaIni, nuevaFecha, codigo);
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final registroState = ref.watch(justificarNotifierProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(nombrePantalla)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuscarPorNombre(
                onChanged: (value) => ref.read(justificarNotifierProvider.notifier).setBusqueda(value),
              ),
              const SizedBox(height: 16),
              RangoFechas
              (
                fechaIni: fechaIni,
                fechaFin: fechaFin,
                onCambiarFechaIni: _cambiarFechaInicial,
                onCambiarFechaFin: _cambiarFechaFinal,
              ),
              const SizedBox(height: 16),
              if (registroState.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (registroState.registros.isEmpty)
                const Expanded(child: Center(child: Text('No hay registros disponibles.')))
              else
                Expanded(
                  child: ListaRegistrosWidget(registros: registroState.registrosFiltrados),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuscarPorNombre extends StatelessWidget 
{
  final void Function(String) onChanged;
  const BuscarPorNombre({
    super.key, 
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) 
  {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Buscar por nombre',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}

class RangoFechas extends StatelessWidget 
{
  final DateTime fechaIni;
  final DateTime fechaFin;
  final VoidCallback onCambiarFechaIni;
  final VoidCallback onCambiarFechaFin;

  const RangoFechas({
    super.key,
    required this.fechaIni,
    required this.fechaFin,
    required this.onCambiarFechaIni,
    required this.onCambiarFechaFin,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Row(
      children: 
      [
        const Text('Inicio'),
        const SizedBox(width: 3),
        Expanded(
          child: ElevatedButton(
            onPressed: onCambiarFechaIni,
            child: Text(FormatUtil.stringToStandard(fechaIni), overflow: TextOverflow.ellipsis),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Fin'),
        const SizedBox(width: 3),
        Expanded(
          child: ElevatedButton(
            onPressed: onCambiarFechaFin,
            child: Text(FormatUtil.stringToStandard(fechaFin), overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}

class ListaRegistrosWidget extends StatelessWidget 
{
  final List<Registro> registros;
  const ListaRegistrosWidget({
    super.key, 
    required this.registros
  });

  @override
  Widget build(BuildContext context) 
  {
    return ListView.builder
    (
      itemCount: registros.length,
      itemBuilder: (context, index) 
      {
        final registro = registros[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 4,
          shape: RoundedRectangleBorder
          (
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile
          (
            title: Text('${registro.nombreEmpleado} ${registro.primerApEmpleado} ${registro.segundoApEmpleado}'),
            subtitle: Text(FormatUtil.stringToStandard(registro.fechaEntrada)),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute
                (
                  builder: (_) => JusitificarDetalle(id: registro.id, codigo: registro.codigoRegistro),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
