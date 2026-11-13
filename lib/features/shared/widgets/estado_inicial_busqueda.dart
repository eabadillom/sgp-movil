import 'package:flutter/material.dart';

class EstadoInicialBusqueda extends StatelessWidget 
{
  final IconData icono;
  final String titulo;
  final String subtitulo;

  const EstadoInicialBusqueda({super.key, required this.icono, required this.titulo, required this.subtitulo});

  @override
  Widget build(BuildContext context) 
  {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white30 : Colors.black54;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            Icon(icono, size: 80, color: textColor),
            const SizedBox(height: 20),
            Text( /// TITULO
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text( /// SUBTITULO
              subtitulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
