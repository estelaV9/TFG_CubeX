import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';

/// Clase que dibuja una onda pequeña personalizada con un color de fondo violeta.
///
/// Esta clase hereda de [CustomPainter], permitiendo dibujar waves personalizada en un widget.
/// La onda tiene dos secciones: una wave que sube y otra que baja.
/// Además, se permite configurar el color de fondo a través del parámetro [backgroundColor],
/// que, por defecto es un color violeta claro.
class SmallWaveContainerPainter extends CustomPainter {
  final Color backgroundColor;

  SmallWaveContainerPainter({this.backgroundColor = AppColors.lightVioletColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. SE CREA UN OBJETO PAINT PARA DIBUJAR LA WAVE PRINCIPAL
    // ASIGNANDOLE UN BG
    final paint = Paint()
      ..color = backgroundColor // COLOR DE FONDO
      ..style = PaintingStyle.fill; // RELLENA EL AREA COMPLETA

    // 2. SE CREA UN OBJETO PATH PARA DIBUJAR LA WAVE
    final path = Path();

    // 3. DIBUJAMOS LA WAVE DESDE LA ESQUINA INFERIOR IZQUIERDA
    path.moveTo(0, size.height); // INICIO EN LA ESQUINA INFERIOR IZQUIERDA

    // 4. PRIMERA OLA: UNA CURVA QUE SUBE DESDE LA PARTE INFERIOR
    path.cubicTo(
        size.width * 0.3, size.height * 1.14, // PRIMER PUNTO DE CONTROL
        size.width * 0.2, size.height * 0.6, // SEGUNDO PUNTO DE CONTROL
        size.width * 0.469, size.height * 0.3 // PUNTO FINAL
    );

    // 5. SEGUNDA OLA: CURVA QUE FINALIZA EN LA PARTE SUPERIOR
    path.cubicTo(
        size.width * 0.7, size.height * 0.12, // PRIMER PUNTO DE CONTROL
        size.width * 0.8, size.height * 0.59, // SEGUNDO PUNTO DE CONTROL
        size.width, 0 // PUNTO FINAL EN LA PARTE SUPERIOR DERECHA
    );

    // 6. CERRAMOS EL CAMINO LLEVANDO LA LINEA HASTA LA PARTE INFERIOR
    path.lineTo(size.width, 0); // LLEVA LA LINEA AL BORDE DERECHO ARRIBA
    path.lineTo(0, 0); // LLEVA LA LINEA AL BORDE IZQUIERDO ARRIBA
    path.close(); // CIERRA EL CAMINO

    // 7. SE DIBUJA LA WAVE EN EL CANVAS
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // DEVUELVE FALSE PORQUE ESTA WAVE NO CAMBIA Y NO NECESITA REPINTARSE
    return false;
  }
}