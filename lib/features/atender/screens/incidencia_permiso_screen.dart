import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/atender/providers/incidencia_permiso_detalle_provider.dart';

class IncidenciaPermisoScreen extends ConsumerStatefulWidget
{
  final int idIncidencia;
  final String codigo;

  const IncidenciaPermisoScreen({super.key, required this.idIncidencia, required this.codigo});

  @override
  ConsumerState<IncidenciaPermisoScreen> createState() => _IncidenciaPermisoScreen();

}

class _IncidenciaPermisoScreen extends ConsumerState<IncidenciaPermisoScreen> 
{
  late final String titulo;
  late int idIncidencia;
  late String codigoIncidencia;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    idIncidencia = widget.idIncidencia;
    codigoIncidencia = widget.codigo;

    if (codigoIncidencia.contains('PE')) {
      titulo = 'Permiso';
    }
    if (codigoIncidencia.contains('V')) {
      titulo = 'Vacaciones';
    }
    
    Future.microtask(() {
      ref.watch(incidenciaPermisoDetalleProvider.notifier).obtenerIncidenciaPermiso(idIncidencia);
    });
  }
  @override
  Widget build(BuildContext context) 
  {
    final incidenciaPermisoState = ref.watch(incidenciaPermisoDetalleProvider);
    Map<String, dynamic> incidenciaPermisoRegistro;

    if(incidenciaPermisoState.isLoading){
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if(incidenciaPermisoState.errorMessage != null){
      return Scaffold(body: Center(child: Text('Error al cargar los datos')));
    }

    final detalleIncidencia = incidenciaPermisoState.incidenciaPermisoDetalle;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Incidencia de "$titulo"'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
      ),
    );
  }
}

