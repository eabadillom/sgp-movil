import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/empleado_detalle_provider.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/tipo_incapacidad_detalle_provider.dart';

class IncapacidadDetalleGuardar extends ConsumerStatefulWidget
{
  const IncapacidadDetalleGuardar({super.key});

  @override
  ConsumerState<IncapacidadDetalleGuardar> createState() => _IncapacidadDetalleState();
}

class _IncapacidadDetalleState extends ConsumerState<IncapacidadDetalleGuardar>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late final String titulo;

  // Controladores de texto
  final TextEditingController folioController = TextEditingController();
  final TextEditingController diasAutorizadosController = TextEditingController();

  // Variables de dropdown
  EmpleadoIncapacidad? empleado;
  TipoIncapacidad? tpIncapacidad;

  @override
  void initState() 
  {
    super.initState();
    titulo = 'Guardar Incapacidad';

    Future.microtask(() 
    {
      ref.read(empleadoDetalleProvider.notifier).obtenerEmpleados();
      ref.read(tipoIncapacidadDetalleProvider.notifier).obtenerTipoIncapacidades();
    });
  }

  void _guardarFormulario() 
  {
    if (_formKey.currentState!.validate()) 
    {
      print('Folio: ${folioController.text}');
      print('Dias Autorizados: ${diasAutorizadosController.text}');
      print('Empleado Inc.: ${empleado?.nombreEmpleado}');
      print('Tipo Incapacidad: ${tpIncapacidad?.descripcion}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos guardados correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final empleadoState = ref.watch(empleadoDetalleProvider);
    final tipoIncapacidadState = ref.watch(tipoIncapacidadDetalleProvider);

    final empleados = empleadoState.empleadoIncapacidad;
    final tipoIncapacidad = tipoIncapacidadState.tipoIncapacidad;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(titulo),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  TextFormField(
                    controller: folioController,
                    decoration: InputDecoration(labelText: 'Folio'),
                    validator: (value) => value == null || value.isEmpty ? 'Ingresa el folio' : null,
                  ),

                  TextFormField(
                    controller: diasAutorizadosController,
                    decoration: InputDecoration(labelText: 'Días Autorizados'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Ingresa los días' : null,
                  ),

                  SizedBox(height: 16),

                  DropdownButtonFormField<EmpleadoIncapacidad>(
                    decoration: InputDecoration(
                      labelText: 'Empleado',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    value: empleado,
                    isExpanded: true,
                    items: empleados.map((emp) 
                    {
                      return DropdownMenuItem<EmpleadoIncapacidad>(
                        value: emp,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              child: Text(
                                emp.nombreEmpleado.isNotEmpty ? emp.nombreEmpleado[0] : '?',
                                style: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${emp.nombreEmpleado} ${emp.primerApEmpleado} ${emp.segundoApEmpleado}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (nuevoEmpleado) 
                    {
                      setState(() {
                        empleado = nuevoEmpleado;
                      });
                    },
                    validator: (value) => value == null ? 'Por favor selecciona un empleado' : null,
                  ),

                  SizedBox(height: 16),

                  DropdownButtonFormField<TipoIncapacidad>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de Incapacidad',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    value: tpIncapacidad,
                    isExpanded: true,
                    items: tipoIncapacidad.map((tipo) 
                    {
                      return DropdownMenuItem<TipoIncapacidad>(
                        value: tipo,
                        child: Row(
                          children: [
                            const Icon(Icons.healing, size: 12, color: Colors.blue),
                            Expanded(
                              child: Text(
                                tipo.descripcion,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ]
                        ),
                      );
                    }).toList(),
                    onChanged: (nuevoTipo) 
                    {
                      setState(() {
                        tpIncapacidad = nuevoTipo;
                      });
                    },
                    validator: (value) => value == null ? 'Por favor selecciona un tipo de incapacidad' : null,
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _guardarFormulario,
                      child: Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
