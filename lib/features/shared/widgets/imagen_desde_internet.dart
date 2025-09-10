import 'package:flutter/material.dart';

class ImagenDesdeInternet extends StatelessWidget {
  final String? url;
  final double? ancho;
  final double? alto;
  final BoxFit fit;

  const ImagenDesdeInternet({
    super.key,
    required this.url,
    this.ancho,
    this.alto,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url!,
      width: ancho,
      height: alto,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/noImage.png',
          width: ancho,
          height: alto,
          fit: fit,
        );
      },
    );
  }
}
