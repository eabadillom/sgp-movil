import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/incapacidades/controller/controller.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/widgets/etiqueta_registro_widget.dart';
import 'package:sgp_movil/features/shared/widgets/widgets.dart';

class IncapacidadDetalle extends ConsumerStatefulWidget 
{
  final int id;

  const IncapacidadDetalle({super.key, required this.id});

  @override
  ConsumerState<IncapacidadDetalle> createState() => _IncapacidadDetalleState();
}

class _IncapacidadDetalleState extends ConsumerState<IncapacidadDetalle>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final String titulo;
  late int idIncapacidad;

  @override
  void initState() 
  {
    super.initState();
    idIncapacidad = widget.id;
    titulo = 'Incapacidad Detalle';

    Future.microtask(() 
    {
      ref.read(incapacidadDetalleProvider.notifier).obtenerIncapacidad(idIncapacidad);
    });
  }
  
  @override
  Widget build(BuildContext context) 
  {
    final incapacidadState = ref.watch(incapacidadDetalleProvider);
    final detalleIncapacidad = incapacidadState.incapacidadDetalle;
    final usuarioDetalleState = ref.watch(usuarioDetalleProvider).usuarioDetalle;
    final bool botonesHabilitados = detalleIncapacidad?.estatusIncapacidad != 'Cancelada';

    if (incapacidadState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (incapacidadState.errorMessage != null) {
      return Scaffold(body: Center(child: Text('Error al cargar los datos')));
    }

    Widget? renderEtiqueta(String label, String? value) {
      if (value == null || value.trim().isEmpty) return null;
      return EtiquetaRegistroWidget(label: label, value: value);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titulo,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 22),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              [
                if(detalleIncapacidad?.nombreInc != null || detalleIncapacidad?.primerApInc != null || detalleIncapacidad?.segundoApInc != null)
                  EtiquetaRegistroWidget(
                    label: 'Empleado',
                    value: '${detalleIncapacidad?.nombreInc ?? ''} ${detalleIncapacidad?.primerApInc ?? ''} ${detalleIncapacidad?.segundoApInc ?? ''}',
                  ),

                ...[
                  renderEtiqueta('Tipo Incapacidad', detalleIncapacidad?.tipoIncapacidad),
                  renderEtiqueta('Control Incapacidad', detalleIncapacidad?.controlIncapacidad),
                  renderEtiqueta('Riesgo de Trabajo', detalleIncapacidad?.riesgoTrabajo),
                  renderEtiqueta('Tipo Riesgo', detalleIncapacidad?.tipoRiesgo),
                  renderEtiqueta('Folio', detalleIncapacidad?.folio),
                  renderEtiqueta('Dias Autorizado', detalleIncapacidad?.diasAutorizados.toString()),
                  renderEtiqueta('Descripcion', detalleIncapacidad?.descripcion),
                  renderEtiqueta('Fecha Inicio', FormatUtil.formatearFechaSimple(detalleIncapacidad?.fechaIni)),
                  renderEtiqueta('Fecha Fin', FormatUtil.formatearFechaSimple(detalleIncapacidad?.fechaFin)),
                  renderEtiqueta('Estatus', detalleIncapacidad?.estatusIncapacidad),
                ].whereType<Widget>(), // Elimina los null

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => {
                        context.pop(false),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                      label: const Text('Regresar', style: TextStyle(fontSize: 18.0, color: Colors.white),),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel_sharp, color: Colors.white),
                      onPressed: botonesHabilitados
                        ? () async {
                        final confirmar = await mostrarConfirmacion(context);

                        if(confirmar != true) return;

                        try {
                          await ref.read(incapacidadDetalleProvider.notifier).cancelarIncapacidad(
                            usuarioDetalleState!.numeroUsuario,
                            IncapacidadDetalleMapper.toJson(detalleIncapacidad!),
                          );

                          if (!context.mounted) return;

                          await CustomSnackBarCentrado.mostrar(
                            context,
                            mensaje: 'Incapacidad actualizada',
                            tipo: SnackbarTipo.success,
                          );

                          /*final snackBarController = ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.success('Incapacidad actualizada'));
                          await snackBarController.closed;*/

                          if(!context.mounted) return;

                          context.pop(true);
                        } catch (e) {
                          if (!context.mounted) return;

                          /*ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.error('Error: $e'));*/

                          await CustomSnackBarCentrado.mostrar(
                            context,
                            mensaje: 'Error: $e',
                            tipo: SnackbarTipo.error,
                          );
                        }
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                      label: const Text('Cancelar', style: TextStyle(fontSize: 18.0, color: Colors.white),),
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

  Future<bool?> mostrarConfirmacion(BuildContext context)
  {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cancelación incapacidad'),
        content: const Text('¿Estás seguro que deseas cancelar esta incapacidad?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

}
