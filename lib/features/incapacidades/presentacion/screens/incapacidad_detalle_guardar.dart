import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () 
            {
              context.pop(false);
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: const IncapacidadDetalleForm(),
                  ),
                ),
              ),
            ),
          ),
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
  final TextEditingController descripcionController = TextEditingController();

  EmpleadoIncapacidad? empleado;
  DateTime? fechaInicio;
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

      ref.listenManual<IncapacidadDetalleGuardarState>(incapacidadDetalleGuardarProvider, (prev, next) 
      {
        if (next.mostrarMensaje && next.errorMessage != null) {
          /*ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.error(next.errorMessage!));*/
          CustomSnackBarCentrado.mostrar(context, mensaje: next.errorMessage!, tipo: SnackbarTipo.error);
          ref.read(incapacidadDetalleGuardarProvider.notifier).marcarMensajeMostrado();
        } else if (prev?.isLoading == true && next.isLoading == false && next.errorMessage == null) {
          /*ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.success('Datos guardados correctamente'));*/
          CustomSnackBarCentrado.mostrar(context, mensaje: 'Datos guardados correctamente', tipo: SnackbarTipo.success);
          if (mounted) context.pop(true);
        }
      });
    });
  }

  @override
  void dispose() 
  {
    folioController.dispose();
    diasAutorizadosController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarFormulario() async 
  {
    if (!_formKey.currentState!.validate()) return;

    final usuarioDetalleState = ref.read(usuarioDetalleProvider).usuarioDetalle;
    if (usuarioDetalleState == null || empleado == null || tpIncapacidad == null || ctrIncapacidad == null) {
      /*ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.error('Faltan datos obligatorios'));*/
      await CustomSnackBarCentrado.mostrar(context, mensaje: 'Faltan datos obligatorios', tipo: SnackbarTipo.error);
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
      fechaInicio: FormatUtil.formatearFechaStringOffset(DateFormat('dd-MM-yyyy').format(fechaInicio!)),
      descripcion: descripcionController.text.trim(),
    );

    await ref.read(incapacidadDetalleGuardarProvider.notifier).guardarIncapacidad(incapacidad.toJson());
  }

  Future<EmpleadoIncapacidad?> _seleccionarEmpleado(List<EmpleadoIncapacidad> empleados) async 
  {
    return showModalBottomSheet<EmpleadoIncapacidad>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _EmpleadoSearchSheet(empleados: empleados, nombreEmpleado: _nombreEmpleado),
    );
  }

  String _nombreEmpleado(EmpleadoIncapacidad item) => [item.nombreEmpleado, item.primerApEmpleado, item.segundoApEmpleado].where((parte) => parte.trim().isNotEmpty).join(' ');

  Future<void> _mostrarDialogoConfirmacion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
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

    if (confirmar == true) {
      _guardarFormulario();
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final empleadoState = ref.watch(empleadoDetalleProvider);
    final tipoIncapacidadState = ref.watch(tipoIncapacidadDetalleProvider);
    final controlIncapacidadState = ref.watch(controlIncapacidadProvider);
    final riesgoTrabajoState = ref.watch(riesgoTrabajoProvider);
    final tipoRiesgoState = ref.watch(tipoRiesgoProvider);
    final guardarState = ref.watch(incapacidadDetalleGuardarProvider);

    final enableEmpleado = empleado?.idEmpleadoInc != null;
    final enableTpIncapacidad = tpIncapacidad?.clave.contains('ENFG') == true;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [
            Center(
              child: Column(
                children: 
                [
                  Text(
                    'Datos de la incapacidad',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Completa la información para registrar la incapacidad.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FormField<EmpleadoIncapacidad>(
              key: ValueKey(empleado?.idEmpleadoInc),
              initialValue: empleado,
              validator: (_) => empleado == null ? 'Selecciona un empleado' : null,
              builder: (field) {
                final selected = field.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: 
                  [
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: empleadoState.isLoading ? null : () 
                        async {
                          final item = await _seleccionarEmpleado(empleadoState.empleadoIncapacidad);
                          if (item == null || !mounted) return;
                          field.didChange(item);
                          setState(() => empleado = item);
                        },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                field.hasError ? colors.error : colors.outline,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: 
                          [
                            CircleAvatar(
                              backgroundColor: colors.primaryContainer,
                              foregroundColor: colors.onPrimaryContainer,
                              child: Text(selected == null || selected.nombreEmpleado.isEmpty ? '?' : selected.nombreEmpleado[0].toUpperCase()),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Empleado',
                                    style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    selected == null ? empleadoState.isLoading ? 'Cargando empleados...' : 'Buscar y seleccionar' : _nombreEmpleado(selected),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge?.copyWith(color: selected == null ? colors.onSurfaceVariant : colors.onSurface),
                                  ),
                                ],
                              ),
                            ),
                            if (empleadoState.isLoading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              Icon(Icons.search_rounded, color: colors.primary),
                          ],
                        ),
                      ),
                    ),
                    if (field.errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 6),
                        child: Text(
                          field.errorText!,
                          style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
                        ),
                      ),
                  ],
                );
              },
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
              validator: (v) => enableEmpleado && v == null ? 'Por favor selecciona un tipo de incapacidad' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<ControlIncapacidad>(
              items: controlIncapacidadState.controlIncapacidad,
              value: ctrIncapacidad,
              label: 'Control Incapacidad',
              enabled: enableEmpleado,
              iconDataBuilder: (_) => Icons.assignment,
              itemLabelBuilder: (control) => '${control.clave} - ${control.descripcion}',
              onChanged: enableEmpleado ? (nuevo) => setState(() => ctrIncapacidad = nuevo) : null,
              validator: (v) => enableEmpleado && v == null ? 'Por favor selecciona un control de incapacidad' : null,
            ),

            const SizedBox(height: 16),

            CustomDropdown<RiesgoTrabajo>(
              items: riesgoTrabajoState.riesgoTrabajo,
              value: rsgTrabajo,
              label: 'Riesgo de Trabajo',
              enabled: enableTpIncapacidad && enableEmpleado,
              iconDataBuilder: (_) => Icons.warning,
              itemLabelBuilder: (riesgo) => '${riesgo.clave} - ${riesgo.descripcion}',
              onChanged: (enableTpIncapacidad && enableEmpleado) ? (nuevo) => setState(() => rsgTrabajo = nuevo) : null,
              validator: (v) => enableTpIncapacidad && enableEmpleado && v == null ? 'Por favor selecciona un riesgo de trabajo' : null,
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
              validator: (v) => enableTpIncapacidad && enableEmpleado && v == null ? 'Por favor selecciona un tipo de riesgo' : null,
            ),

            const SizedBox(height: 16),

            _buildTextField(controller: folioController, label: 'Folio'),
            _buildTextField(controller: diasAutorizadosController, label: 'Días autorizados', keyboardType: TextInputType.number),
            FormField<DateTime>(
              initialValue: fechaInicio,
              validator: (value) => value == null ? 'Selecciona una fecha de inicio' : null,
              builder: (field) => 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: 
                    [
                      DateTileWidget(
                        label: 'Fecha de inicio',
                        date: field.value,
                        onTap: () async 
                        {
                          final picked = await customDatePicker(context: context, initialDate: field.value ?? DateTime.now(), firstDate: DateTime(1900));
                          if (picked == null) return;
                          field.didChange(picked);
                          setState(() => fechaInicio = picked);
                        },
                      ),
                      if (field.errorText != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 6),
                          child: Text(
                            field.errorText!,
                            style: theme.textTheme.bodySmall?.copyWith(color: colors.error),
                          ),
                        ),
                    ],
                  ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: descripcionController,
              label: 'Descripción',
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: guardarState.isLoading ? null : _mostrarDialogoConfirmacion,
                icon: guardarState.isLoading ? 
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ) : const Icon(Icons.save_outlined),
                label: Text(guardarState.isLoading ? 'Guardando...' : 'Guardar incapacidad'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmpleadoSearchSheet extends StatefulWidget 
{
  final List<EmpleadoIncapacidad> empleados;
  final String Function(EmpleadoIncapacidad) nombreEmpleado;

  const _EmpleadoSearchSheet({required this.empleados, required this.nombreEmpleado});

  @override
  State<_EmpleadoSearchSheet> createState() => _EmpleadoSearchSheetState();
}

class _EmpleadoSearchSheetState extends State<_EmpleadoSearchSheet> 
{
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() 
  {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final consulta = _controller.text.trim().toLowerCase();
    final resultados = widget.empleados.where((item) {return widget.nombreEmpleado(item).toLowerCase().contains(consulta);}).toList();

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: LayoutBuilder(
        builder: (context, constraints) 
        {
          final sheetHeight = constraints.maxHeight.isFinite ? constraints.maxHeight * 0.8 : MediaQuery.sizeOf(context).height * 0.65;

          return SizedBox(
            height: sheetHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: 
                [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selecciona un empleado',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o apellido',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _controller.text.isEmpty ? null : 
                        IconButton(
                          onPressed: () 
                          {
                            _controller.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded),
                          tooltip: 'Limpiar búsqueda',
                        ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: resultados.isEmpty?
                            Center(
                              child: Text(
                                widget.empleados.isEmpty ? 'No hay empleados disponibles.' : 'No se encontraron empleados.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium,
                              ),
                            )
                            : ListView.separated(
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: resultados.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 4),
                              itemBuilder: (context, index) {
                                final item = resultados[index];
                                final nombre = widget.nombreEmpleado(item);
                                final inicial = item.nombreEmpleado.isNotEmpty ? item.nombreEmpleado[0].toUpperCase() : '?';

                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: colors.primaryContainer,
                                    foregroundColor: colors.onPrimaryContainer,
                                    child: Text(inicial),
                                  ),
                                  title: Text(
                                    nombre,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right_rounded,
                                    color: colors.onSurfaceVariant,
                                  ),
                                  onTap: () => Navigator.of(context).pop(item),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildTextField({required TextEditingController controller, required String label, TextInputType? keyboardType, int maxLines = 1}) 
{
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.trim().isEmpty ? 'Por favor ingresa ${label.toLowerCase()}' : null,
    ),
  );
}
