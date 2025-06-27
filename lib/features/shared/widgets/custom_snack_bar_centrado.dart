import 'dart:async';
import 'package:flutter/material.dart';

enum SnackbarTipo{success, error, info}

class CustomSnackBarCentrado 
{
  static Future<void> mostrar(
    BuildContext context, {
    required String mensaje,
    SnackbarTipo tipo = SnackbarTipo.info,
    Duration duration = const Duration(seconds: 4),
  }) async {
    final overlay = Overlay.of(context);
    final completer = Completer<void>();

    final config = _obtenerEstilosPorTipo(tipo);
    final overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarCentradoWidget(
        mensaje: mensaje,
        icono: config.icono,
        backgroundColor: config.backgroundColor,
        textColor: config.textColor,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () 
    {
      overlayEntry.remove();
      completer.complete();
    });

    return completer.future;
  }

  static _SnackbarEstilo _obtenerEstilosPorTipo(SnackbarTipo tipo) 
  {
    switch (tipo) {
      case SnackbarTipo.success:
        return _SnackbarEstilo(
          icono: Icons.check_circle,
          backgroundColor: Colors.green.shade700,
          textColor: Colors.white,
        );
      case SnackbarTipo.error:
        return _SnackbarEstilo(
          icono: Icons.error,
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
        );
      case SnackbarTipo.info:
        return _SnackbarEstilo(
          icono: Icons.info,
          backgroundColor: Colors.blueGrey.shade800,
          textColor: Colors.white,
        );
    }
  }
}

class _SnackbarEstilo 
{
  final IconData icono;
  final Color backgroundColor;
  final Color textColor;

  _SnackbarEstilo({
    required this.icono,
    required this.backgroundColor,
    required this.textColor,
  });
}

class _SnackbarCentradoWidget extends StatelessWidget 
{
  final String mensaje;
  final IconData icono;
  final Color backgroundColor;
  final Color textColor;

  const _SnackbarCentradoWidget({
    required this.mensaje,
    required this.icono,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icono, color: textColor),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      mensaje,
                      style: TextStyle(color: textColor),
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
