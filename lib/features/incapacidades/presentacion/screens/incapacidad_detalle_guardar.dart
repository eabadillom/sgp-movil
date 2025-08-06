import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/incapacidades/domain/domain.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/providers.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

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
          centerTitle: true,
          title: const Text(
            'Incapacidad',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 22),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop(false);
            },
          ),
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
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

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

      ref.listenManual<IncapacidadDetalleGuardarState>(
        incapacidadDetalleGuardarProvider,
        (prev, next) {
          if(next.mostrarMensaje && next.errorMessage != null) {
            /*ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.error(next.errorMessage!));*/
            CustomSnackBarCentrado.mostrar(
              context,
              mensaje: next.errorMessage!,
              tipo: SnackbarTipo.error,
            );
            ref.read(incapacidadDetalleGuardarProvider.notifier).marcarMensajeMostrado();
          } else if(prev?.isLoading == true && next.isLoading == false && next.errorMessage == null) {
            /*ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.success('Datos guardados correctamente'));*/
            CustomSnackBarCentrado.mostrar(
              context,
              mensaje: 'Datos guardados correctamente',
              tipo: SnackbarTipo.success,
            );
            if(mounted) context.pop(true);
          }
        },
      );
    });
  }

  @override
  void dispose() 
  {
    folioController.dispose();
    diasAutorizadosController.dispose();
    fechaInicioController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarFormulario() async 
  {
    if (!_formKey.currentState!.validate()) return;

    final usuarioDetalleState = ref.read(usuarioDetalleProvider).usuarioDetalle;
    if (usuarioDetalleState == null || empleado == null || tpIncapacidad == null || ctrIncapacidad == null) {
      /*ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.error('Faltan datos obligatorios'));*/
      await CustomSnackBarCentrado.mostrar(
        context,
        mensaje: 'Faltan datos obligatorios',
        tipo: SnackbarTipo.error,
      );
      return;
    }

    final incapacidad = IncapacidadGuardarDetalle(
      idEmpleadoInc: empleado!.idEmpleadoInc,
      idEmpleadoRev: usuarioDetalleState.numeroUsuario,
      tipoIncapacidad: tpIncapacidad!.idTpIncapacidad,
      controlIncapacidad: ctrIncapacidad!.idControlIncapacidad,
      riesgoTrabajo: rsgTrabajo?.idRiesgoTrabajo,
      tipoRiesgo: tpRiesgo?.idTipoRiesgo,
      folio: folioController.text.trim(),
      diasAutorizados: int.parse(diasAutorizadosController.text.trim()),
      fechaInicio: FormatUtil.formatearFechaStringOffset(fechaInicioController.text.trim()),
      descripcion: descripcionController.text.trim(),
    );

    await ref.read(incapacidadDetalleGuardarProvider.notifier).guardarIncapacidad(incapacidad.toJson());
  }

  Future<void> _mostrarDialogoConfirmacion() async 
  {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Estás seguro de que deseas guardar la incapacidad?'),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => context.pop(true),
            child: const Text('Sí'),
          ),

          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.black,
            ),
            onPressed: () => context.pop(false),
            child: const Text('No'),
          ),
        ],
      ),
    );

    if(confirmar == true) 
    {
      _guardarFormulario();
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

    final enableEmpleado = empleado?.idEmpleadoInc != null; 
    final enableTpIncapacidad = tpIncapacidad?.clave.contains('ENFG') == true;

    return Form
    (
      key: _formKey,
      child: SingleChildScrollView
      (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown<EmpleadoIncapacidad>(
              items: empleadoState.empleadoIncapacidad,
              value: empleado,
              label: 'Empleado',
              itemLabelBuilder: (emp) => '${emp.nombreEmpleado} ${emp.primerApEmpleado} ${emp.segundoApEmpleado}',
              iconBuilder: (emp) => CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Text(
                  emp.nombreEmpleado.isNotEmpty ? emp.nombreEmpleado[0] : '?', style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              onChanged: (nuevo) => setState(() => empleado = nuevo),
              validator: (v) => v == null ? 'Por favor selecciona un empleado' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<TipoIncapacidad>(
              items: tipoIncapacidadState.tipoIncapacidad,
              value: tpIncapacidad,
              label: 'Tipo de Incapacidad',
              enabled: enableEmpleado,
              iconDataBuilder: (_) => Icons.healing,
              itemLabelBuilder: (tipo) => '${tipo.clave} - ${tipo.descripcion}',
              onChanged: enableEmpleado ? (nuevo) => setState(() => tpIncapacidad = nuevo) : null,
              validator: (v) => enableEmpleado ? null : 'Por favor selecciona un tipo de incapacidad',
            ),

            const SizedBox(height: 16),

            CustomDropdown<ControlIncapacidad>(
              items: controlIncapacidadState.controlIncapacidad,
              value: ctrIncapacidad,
              label: 'Control Incapacidad',
              enabled: enableEmpleado,
              iconDataBuilder: (_) => Icons.assignment,
              itemLabelBuilder: (control) => '${control.clave} - ${control.descripcion}',
              onChanged:  enableEmpleado ? (nuevo) => setState(() => ctrIncapacidad = nuevo) : null,
              validator: (v) => enableEmpleado ? null : 'Por favor selecciona un control de incapacidad',
            ),

            const SizedBox(height: 16),

            CustomDropdown<RiesgoTrabajo>(
              items: riesgoTrabajoState.riesgoTrabajo,
              value: rsgTrabajo,
              label: 'Riesgo de Trabajo',
              enabled: enableTpIncapacidad && enableEmpleado,
              iconDataBuilder: (_) => Icons.warning,
              itemLabelBuilder: (riesgo) => '${riesgo.clave} - ${riesgo.descripcion}',
              onChanged: (enableTpIncapacidad && enableEmpleado) ? (nuevo) => setState(() => rsgTrabajo = nuevo): null,
              validator: (v) => (!enableTpIncapacidad && !enableEmpleado && v == null) ? 'Por favor selecciona un riesgo de trabajo' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<TipoRiesgo>(
              items: tipoRiesgoState.tipoRiesgo,
              value: tpRiesgo,
              label: 'Tipo de Riesgo',
              enabled: enableTpIncapacidad && enableEmpleado,
              iconDataBuilder: (_) => Icons.security,
              itemLabelBuilder: (riesgo) => '${riesgo.clave} - ${riesgo.descripcion}',
              onChanged: (enableTpIncapacidad && enableEmpleado) ? (nuevo) => setState(() => tpRiesgo = nuevo) : null,
              validator: (v) => (!enableTpIncapacidad && !enableEmpleado && v == null) ? 'Por favor selecciona un tipo de riesgo' : null,
            ),

            const SizedBox(height: 10),

            _buildTextField(controller: folioController, label: 'Folio'),
            _buildTextField(controller: diasAutorizadosController, label: 'Días Autorizados'),
            DatePickerField(
              controller: fechaInicioController,
              validator: (value) => value?.isEmpty ?? true ? 'Por favor selecciona una fecha' : null,
            ),
            _buildTextField(controller: descripcionController, label: 'Descripción'),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _mostrarDialogoConfirmacion,
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField({required TextEditingController controller, required String label, TextInputType? keyboardType}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(labelText: label),
    validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa ${label.toLowerCase()}' : null,
  );
}
