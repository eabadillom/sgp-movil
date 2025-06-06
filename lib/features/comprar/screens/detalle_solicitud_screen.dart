import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/conf/security/dio_client.dart';
import 'package:sgp_movil/features/comprar/providers/detalle_solicitud_provider.dart';
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
    // Llamar al notifier con los parámetros recibidos
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
    final DioClient httpService = DioClient(nameContext: 'NOMBRE');
    final baseUrl = httpService.dio.options.baseUrl;

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
        imagenUrl: '$baseUrl/${articulo.rutaImagen}${articulo.descripcion}.jgp',
        detalle: articulo.detalle,
        tipo: 'A',
        unidad: articulo.unidad,
        fechaCaptura: articulo.fechaCaptura,
        fechaModificacion: articulo.fechaModificacion,
        motivoRechazo: articulo.descripcionRechazo,
        disponibleInit: articulo.activo,
        estatus: articulo.estatusSolicitud,
        solicitante:
            '${articulo.nombreSolicitante} ${articulo.primerApSolicitante} ${articulo.segundoApSolicitante}',
      );
    } else if (state.solicitud is SolicitudPrendaDetalle) {
      final prenda = (state.solicitud as SolicitudPrendaDetalle).data;
      contenido = _buildContenido(
        descripcion: prenda.descripcion,
        imagenUrl: '$baseUrl/${prenda.rutaImagen}${prenda.descripcion}.jpg',
        detalle: prenda.detalle,
        tipo: 'PR',
        precio: prenda.precio,
        talla: prenda.talla,
        fechaCaptura: prenda.fechaCaptura,
        fechaModificacion: prenda.fechaModificacion,
        motivoRechazo: prenda.descripcionRechazo,
        disponibleInit: prenda.activo,
        estatus: prenda.estatusSolicitud,
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
  }) {
    if (_motivoRechazoController.text.isEmpty && motivoRechazo != null) {
      _motivoRechazoController.text = motivoRechazo;
    }
    disponible = disponibleInit;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImagenDesdeInternet(
              url: imagenUrl,
              ancho: 150,
              alto: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${tipo == 'PR' ? 'Uniforme' : 'Artículo'}: ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: descripcion,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (tipo == 'A' && unidad != null)
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Unidad: ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: unidad, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),

          if (tipo == 'PR' && precio != null)
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Precio: ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '\$${precio.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),

          if (tipo == 'PR' && talla != null)
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Talla: ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: talla, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),

          const SizedBox(height: 8),

          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Fecha de captura: ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: _formatDate(fechaCaptura),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Fecha de Modificación: ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: _formatDate(fechaModificacion!),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Solicitante:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                solicitante!,
                style: const TextStyle(fontSize: 20),
                softWrap: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (estatus == 'R')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Motivo de rechazo:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  motivoRechazo!,
                  style: const TextStyle(fontSize: 18),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 16),
              ],
            ),
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
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if ((estatus == 'E' || estatus == 'A') && estatus != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white, // texto blanco
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _rechazarSolicitud,
                  child: const Text('Rechazar'),
                ),
              if ((estatus == 'E' || estatus == 'R') && estatus != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white, // texto blanco
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _aceptarSolicitud,
                  child: const Text('Aceptar'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  void _rechazarSolicitud() {
    print('❌ Rechazada con motivo: ${_motivoRechazoController.text}');
    // Aquí podrías llamar al notifier para actualizar el estado
  }

  void _aceptarSolicitud() {
    print('✅ Aceptada. Disponible: $disponible');
    // Aquí podrías llamar al notifier para actualizar el estado
  }
}
