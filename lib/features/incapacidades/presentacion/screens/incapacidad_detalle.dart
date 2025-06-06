import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/incapacidades/controller/controller.dart';
import 'package:sgp_movil/features/incapacidades/presentacion/providers/incapacidad_detalle_provider.dart';
import 'package:sgp_movil/features/justificar/widgets/etiqueta_registro_widget.dart';
import 'package:sgp_movil/features/shared/widgets/side_menu.dart';

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
  void initState() {
    super.initState();
    idIncapacidad = widget.id;
    titulo = 'Incapacidad Detalle';

    Future.microtask(() {
      ref.read(incapacidadDetalleProvider.notifier).obtenerIncapacidad(idIncapacidad);
    });
  }
  @override
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
        title: Text(titulo),
        actions: [
          IconButton(
            icon: Icon(Icons.keyboard_return_sharp),
            onPressed: () 
            {
              context.pop();
            },
          ),
        ],
      ),
      drawer: SideMenu(scaffoldKey: _scaffoldKey),
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
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: botonesHabilitados ? () async 
                      {
                        await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar cancelación'),
                              content: const Text('¿Estás seguro que deseas cancelar esta incapacidad?'),
                              actions: [
                                TextButton(
                                  child: const Text('Sí'),
                                  onPressed: () {
                                    try {
                                      ref.read(incapacidadDetalleProvider.notifier)
                                        .cancelarIncapacidad(usuarioDetalleState!.numeroUsuario, IncapacidadDetalleMapper.toJson(detalleIncapacidad!));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Incapacidad actualizada')),
                                      );
                                      context.pop(true);
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$e')),
                                        );
                                        context.pop(true);
                                      }
                                    }
                                  },
                                ),
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () => context.pop(false),
                                ),
                              ],
                            );
                          },
                        );
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

                    const SizedBox(width: 10),
                    
                    ElevatedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => {
                        context.pop(),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                      label: const Text('Mantener', style: TextStyle(fontSize: 18.0, color: Colors.white),),
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

  Future<bool> mostrarConfirmacion({
    required BuildContext context,
    String titulo = 'Confirmación',
    String mensaje = '¿Estás seguro?',
    String textoAceptar = 'Sí',
    String textoCancelar = 'No',
  }) async 
  {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: Text(textoAceptar),
              onPressed: () { 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos actualizados correctamente')),
                );
                context.pop(true);
              },
            ),

            TextButton(
              child: Text(textoCancelar),
              onPressed: () => context.pop(false),
            ),
          ],
        );
      },
    );

    return resultado ?? false;
  }

}
