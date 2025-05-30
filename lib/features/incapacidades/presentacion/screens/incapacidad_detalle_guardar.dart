import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/providers.dart'; 
import 'package:sgp_movil/features/shared/widgets/custom_dropdown.dart';

class IncapacidadDetalleGuardar extends ConsumerStatefulWidget
{
  const IncapacidadDetalleGuardar({super.key});

  @override
  ConsumerState<IncapacidadDetalleGuardar> createState() => _IncapacidadDetalleState();
}

class _IncapacidadDetalleState extends ConsumerState<IncapacidadDetalleGuardar>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) 
  {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Guardar Incapacidad'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: IncapacidadDetalleForm(),
        ),
      ),
    );
  }
}

class IncapacidadDetalleForm extends ConsumerStatefulWidget 
{
  const IncapacidadDetalleForm({super.key});

  @override
  ConsumerState<IncapacidadDetalleForm> createState() => _IncapacidadDetalleFormState();
}

class _IncapacidadDetalleFormState extends ConsumerState<IncapacidadDetalleForm> 
{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController folioController = TextEditingController();
  final TextEditingController diasAutorizadosController = TextEditingController();

  EmpleadoIncapacidad? empleado;
  TipoIncapacidad? tpIncapacidad;
  ControlIncapacidad? ctrIncapacidad;
  RiesgoTrabajo? rsgTrabajo;
  TipoRiesgo? tpRiesgo;

  @override
  void initState() 
  {
    super.initState();
    Future.microtask(() 
    {
      ref.read(empleadoDetalleProvider.notifier).obtenerEmpleados();
      ref.read(tipoIncapacidadDetalleProvider.notifier).obtenerTipoIncapacidades();
      ref.read(controlIncapacidadProvider.notifier).obtenerControlIncapacidad();
      ref.read(riesgoTrabajoProvider.notifier).obtenerRiesgoTrabajo();
      ref.read(tipoRiesgoProvider.notifier).obtenerTipoRiesgo();
    });
  }

  void _guardarFormulario() 
  {
    if (_formKey.currentState!.validate()) 
    {
      print('IdEmpleado.: ${empleado?.idEmpleadoInc}');
      print('IdTipoIncapacidad: ${tpIncapacidad?.idTpIncapacidad}');
      print('IdControlIncapacidad ${ctrIncapacidad?.idControlIncapacidad}');
      print('IdRiesgoTrabajo ${rsgTrabajo?.idRiesgoTrabajo}');
      print('IdTipoRiesgo ${tpRiesgo?.idTipoRiesgo}');
      print('Folio: ${folioController.text}');
      print('Dias Autorizados: ${diasAutorizadosController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final empleadoState = ref.watch(empleadoDetalleProvider);
    final tipoIncapacidadState = ref.watch(tipoIncapacidadDetalleProvider);
    final controlIncapacidadState = ref.watch(controlIncapacidadProvider);
    final riesgoTrabajoState = ref.watch(riesgoTrabajoProvider);
    final tipoRiesgoState = ref.watch(tipoRiesgoProvider);

    final listEmpleados = empleadoState.empleadoIncapacidad;
    final listTipoIncapacidad = tipoIncapacidadState.tipoIncapacidad;
    final listControlIncapacidad = controlIncapacidadState.controlIncapacidad;
    final listRiesgoTrabajo = riesgoTrabajoState.riesgoTrabajo;
    final listTipoRiesgo = tipoRiesgoState.tipoRiesgo;

    return Form
    (
      key: _formKey,
      child: SingleChildScrollView
      (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown<EmpleadoIncapacidad>(
              items: listEmpleados,
              value: empleado,
              label: 'Empleado',
              itemLabelBuilder: (emp) => '${emp.nombreEmpleado} ${emp.primerApEmpleado} ${emp.segundoApEmpleado}',
              iconBuilder: (emp) => CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Text(
                  emp.nombreEmpleado.isNotEmpty ? emp.nombreEmpleado[0] : '?',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              onChanged: (nuevo) => setState(() => empleado = nuevo),
              validator: (v) => v == null ? 'Por favor selecciona un tipo de incapacidad' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<TipoIncapacidad>(
              items: listTipoIncapacidad,
              value: tpIncapacidad,
              label: 'Tipo de Incapacidad',
              iconDataBuilder: (_) => Icons.healing,
              itemLabelBuilder: (tipo) => '${tipo.clave} - ${tipo.descripcion}',
              onChanged: (nuevo) => setState(() => tpIncapacidad = nuevo),
              validator: (v) => v == null ? 'Por favor selecciona un tipo de incapacidad' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<ControlIncapacidad>(
              items: listControlIncapacidad,
              value: ctrIncapacidad,
              label: 'Control Incapacidad',
              iconDataBuilder: (_) => Icons.assignment,
              itemLabelBuilder: (control) => '${control.clave} - ${control.descripcion}',
              onChanged: (nuevo) => setState(() => ctrIncapacidad = nuevo),
              validator: (v) => v == null ? 'Por favor selecciona un control de incapacidad' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<RiesgoTrabajo>(
              items: listRiesgoTrabajo,
              value: rsgTrabajo,
              label: 'Riesgo de Trabajo',
              iconDataBuilder: (_) => Icons.warning,
              itemLabelBuilder: (riesgo) => '${riesgo.clave} - ${riesgo.descripcion}',
              onChanged: (nuevo) => setState(() => rsgTrabajo = nuevo),
              validator: (v) => v == null ? 'Por favor selecciona un riesgo de trabajo' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<TipoRiesgo>(
              items: listTipoRiesgo,
              value: tpRiesgo,
              label: 'Tipo de Riesgo',
              iconDataBuilder: (_) => Icons.security,
              itemLabelBuilder: (riesgo) => '${riesgo.clave} - ${riesgo.descripcion}',
              onChanged: (nuevo) => setState(() => tpRiesgo = nuevo),
              validator: (v) => v == null ? 'Por favor selecciona un tipo de riesgo' : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: folioController,
              decoration: const InputDecoration(labelText: 'Folio'),
              validator: (value) => value == null || value.isEmpty ? 'Ingresa el folio' : null,
            ),

            TextFormField(
              controller: diasAutorizadosController,
              decoration: const InputDecoration(labelText: 'Días Autorizados'),
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty ? 'Ingresa los días' : null,
            ),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: _guardarFormulario,
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
