import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/config.dart';
import 'package:sgp_movil/features/comprar/providers/detalle_solicitud_provider.dart';
import 'package:sgp_movil/features/comprar/utils/solicitud_utils.dart';
import 'package:sgp_movil/features/comprar/widgets/boton_aceptar.dart';
import 'package:sgp_movil/features/comprar/widgets/widgets.dart';
import 'package:sgp_movil/features/dashboard/presentation/providers/usuario_detalle_provider.dart';
import 'package:sgp_movil/features/shared/widgets/imagen_desde_internet.dart';

class DetalleSolicitudScreen extends ConsumerStatefulWidget {
  final int idIncidencia;
  final String tipoIncidencia;

  const DetalleSolicitudScreen({
    super.key,
    required this.idIncidencia,
    required this.tipoIncidencia,
  });

  @override
  ConsumerState<DetalleSolicitudScreen> createState() =>
      _DetalleSolicitudScreenState();
}

class _DetalleSolicitudScreenState
    extends ConsumerState<DetalleSolicitudScreen> {
  final TextEditingController _motivoRechazoController =
      TextEditingController();
  bool disponible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(solicitudNotifierProvider.notifier)
          .obtenerSolicitud(widget.tipoIncidencia, widget.idIncidencia);
    });
  }

  @override
  void dispose() {
    _motivoRechazoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(solicitudNotifierProvider);
    DioClient http = DioClient();
    String baseUrl = http.dio.options.baseUrl;
    String contexto = Environment.obtenerUrlPorNombre('SGP');
    String url = '$baseUrl/$contexto';
    final usuarioDetalleState =
        ref.watch(usuarioDetalleProvider).usuarioDetalle;
    if (state.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(state.errorMessage!)),
      );
    }

    if (state.solicitud == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget contenido;

    if (state.solicitud is SolicitudArticuloDetalle) {
      final articulo = (state.solicitud as SolicitudArticuloDetalle).data;
      contenido = _buildContenido(
        descripcion: articulo.descripcion,
        imagenUrl: '$url/${articulo.rutaImagen}${articulo.descripcion}.jpg',
        detalle: articulo.detalle,
        tipo: 'A',
        unidad: articulo.unidad,
        fechaCaptura: articulo.fechaCaptura,
        fechaModificacion: articulo.fechaModificacion,
        motivoRechazo: articulo.descripcionRechazo,
        disponibleInit: articulo.activo,
        estatus: articulo.estatusSolicitud,
        numero: usuarioDetalleState?.numeroUsuario,
        solicitante:
            '${articulo.nombreSolicitante} ${articulo.primerApSolicitante} ${articulo.segundoApSolicitante}',
      );
    } else if (state.solicitud is SolicitudPrendaDetalle) {
      final prenda = (state.solicitud as SolicitudPrendaDetalle).data;
      contenido = _buildContenido(
        descripcion: prenda.descripcion,
        imagenUrl: '$url/${prenda.rutaImagen}${prenda.descripcion}.jpg',
        detalle: prenda.detalle,
        tipo: 'PR',
        precio: prenda.precio,
        talla: prenda.talla,
        fechaCaptura: prenda.fechaCaptura,
        fechaModificacion: prenda.fechaModificacion,
        motivoRechazo: prenda.descripcionRechazo,
        disponibleInit: prenda.activo,
        estatus: prenda.estatusSolicitud,
        numero: usuarioDetalleState?.numeroUsuario,
        solicitante:
            '${prenda.nombreSolicitante} ${prenda.primerApSolicitante} ${prenda.segundoApSolicitante}',
      );
    } else {
      return const Scaffold(
        body: Center(child: Text('Tipo de solicitud no soportado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de solicitud')),
      body: contenido,
    );
  }

  Widget _buildContenido({
    required String descripcion,
    required String? imagenUrl,
    required String detalle,
    required String tipo,
    String? unidad,
    Decimal? precio,
    String? talla,
    required DateTime fechaCaptura,
    DateTime? fechaModificacion,
    String? motivoRechazo,
    required bool disponibleInit,
    required String? estatus,
    required String? solicitante,
    required String? numero,
  }) {
    if (_motivoRechazoController.text.isEmpty && motivoRechazo != null) {
      _motivoRechazoController.text = motivoRechazo;
    }
    disponible = disponibleInit;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImagenDesdeInternet(
                url: imagenUrl,
                ancho: 200,
                alto: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),

            TextoRicoWidget(
              constante: '${tipo == 'PR' ? 'Uniforme' : 'Artículo'}: ',
              variable: descripcion,
            ),
            const SizedBox(height: 8),

            if (tipo == 'A' && unidad != null)
              TextoRicoWidget(constante: 'Unidad: ', variable: unidad),
            const SizedBox(height: 8),

            if (tipo == 'PR' && precio != null)
              TextoRicoWidget(
                constante: 'Precio: ',
                variable: '\$${precio.toStringAsFixed(2)}',
              ),
            const SizedBox(height: 8),

            if (tipo == 'PR' && talla != null)
              TextoRicoWidget(constante: 'Talla: ', variable: talla),
            const SizedBox(height: 8),
            TextoRicoWidget(
              constante: 'Fecha de captura: ',
              variable: formatDate(fechaCaptura),
            ),
            const SizedBox(height: 8),

            TextoRicoWidget(
              constante: 'Fecha de Modificacion: ',
              variable: formatDate(fechaModificacion!),
            ),
            const SizedBox(height: 8),

            SolicitanteWidget(
              constante: 'Solicitante:',
              variable: solicitante!,
            ),
            const SizedBox(height: 8),

            if (estatus == 'R' && motivoRechazo != null)
              MotivoRechazoWidget(
                constante: 'Motivo de rechazo:',
                variable: motivoRechazo,
              ),
            const SizedBox(height: 16),
            /* El switch para determinar si un articulo o prenda esta disponible, es un deseable. Ya que se le tiene que agregar la funcion para que a
            agregue el estado y rechace la solicitud por falta del objeto solicitado en la empresa.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Disponible',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: disponible,
                  onChanged: (value) => setState(() => disponible = value),
                ),
              ],
            ),
            const SizedBox(height: 24),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if ((estatus == 'E' || estatus == 'A') && estatus != null)
                  BotonRechazar(
                    idIncidencia: widget.idIncidencia,
                    tipo: tipo,
                    numeroRevisor: numero ?? '0001',
                  ),
                if ((estatus == 'E' || estatus == 'R') && estatus != null)
                  BotonAceptar(
                    idIncidencia: widget.idIncidencia,
                    tipo: tipo,
                    numeroRevisor: numero ?? '0001',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
