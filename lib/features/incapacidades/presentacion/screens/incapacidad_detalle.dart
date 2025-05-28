import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sgp_movil/conf/util/format_util.dart';
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
  Widget build(BuildContext context) 
  {
    final incapacidadState = ref.watch(incapacidadDetalleProvider);
    final detalleIncapacidad = incapacidadState.incapacidadDetalle;

    if (incapacidadState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (incapacidadState.errorMessage != null) {
      return Scaffold(body: Center(child: Text('Error al cargar los datos')));
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          IconButton(
            icon: Icon(Icons.keyboard_return_sharp),
            onPressed: () {
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
              children: [
                EtiquetaRegistroWidget (
                  label: 'Empleado',
                  value:
                    '${detalleIncapacidad?.nombreInc} ${detalleIncapacidad?.primerApInc} ${detalleIncapacidad?.segundoApInc}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Tipo Incapacidad',
                  value:
                      '${detalleIncapacidad?.tipoIncapacidad}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Control Incapacidad',
                  value:
                      '${detalleIncapacidad?.controlIncapacidad}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Riesgo de Trabajo',
                  value:
                      '${detalleIncapacidad?.riesgoTrabajo}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Tipo Riesgo',
                  value:
                      '${detalleIncapacidad?.tipoRiesgo}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Folio',
                  value:
                      '${detalleIncapacidad?.folio}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Dias Autorizado',
                  value:
                      '${detalleIncapacidad?.diasAutorizados}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Descripcion',
                  value:
                      '${detalleIncapacidad?.descripcion}',
                ),

                EtiquetaRegistroWidget(
                  label: 'Fecha Inicio',
                  value:
                      FormatUtil.formatearFechaSimple(detalleIncapacidad?.fechaIni),
                ),

                EtiquetaRegistroWidget(
                  label: 'Fecha Fin',
                  value:
                      FormatUtil.formatearFechaSimple(detalleIncapacidad?.fechaFin),
                ),

                EtiquetaRegistroWidget(
                  label: 'Estatus',
                  value:
                      '${detalleIncapacidad?.estatusIncapacidad}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
