import 'package:flutter/material.dart';

import '../utilities/app_color.dart';

/// Clase que dibuja una wave personalizada con un degradado y una sombra violeta.
///
/// Esta clase herada de [CustomPainter], permitiendo dibujar waves personalizadas en un widget.
/// La onda tiene tres secciones: una onda pequeña, una onda intermedia y una onda grande.
/// Ademas, se dibuja una sombra desplazada ligeramente hacia arriba para dar un contorno.
class WaveContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. SE CREA UN OBJETO PAINT QUE SE USA PARA DIBUJAR LA WAVE PRINCIPAL
    // SE LE ASIGNA UN DEGRADADO LINEAL QUE CAMBIA ENTRE DOS COLORES
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter, // EL DEGRADADO EMPIEZA DESDE ARRIBA
        end: Alignment.bottomCenter, // Y TERMINA ABAJO
        colors: [
          AppColors.upLinearColor, // COLOR SUPERIOR
          AppColors.downLinearColor, // COLOR INFERIOR
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill; // RELLENATODO EL AREA

    // 2. SE CREA UN PAINT PARA LA SOMBRA, USANDO UN COLOR SOLIDO
    final shadowPaint = Paint()
      ..color = AppColors.lightVioletColor // COLOR DE LA SOMBRA
      ..style = PaintingStyle.fill; // LA SOMBRA TAMBIEN SE RELLENA COMPLETA

    // 3. SE CREA UN OBJETO PATH PARA DIBUJAR LA WAVE PRINCIPAL
    final path = Path();

    // 4. SE CREA OTRO PATH PARA DIBUJAR LA SOMBRA
    final shadowPath = Path();

    // 5. DIBUJAMOS LA PRIMERA WAVE PEQUEÑA QUE EMPIEZA EN UN PUNTO MAS BAJO
    // moveTo() POSICIONA EL PUNTO INICIAL DEL CAMINO
    path.moveTo(0, size.height * 0.28);
    path.cubicTo(
        size.width * 0.2, // PRIMER PUNTO DE CONTROL X
        size.height * 0.15, // PRIMER PUNTO DE CONTROL Y
        size.width * 0.3, // SEGUNDO PUNTO DE CONTROL X
        size.height * 0.23, // SEGUNDO PUNTO DE CONTROL Y
        size.width * 0.45, // PUNTO FINAL X
        size.height * 0.23 // PUNTO FINAL Y
    );

    // 6. DIBUJAMOS LA WAVE INTERMEDIA QUE DESCIENDE UN POCO MAS
    // (es la ola que baja un poco y que une las dos waves principales)
    path.cubicTo(
        size.width * 0.45, // PRIMER PUNTO DE CONTROL X
        size.height * 0.229, // PRIMER PUNTO DE CONTROL Y
        size.width * 0.54, // SEGUNDO PUNTO DE CONTROL X
        size.height * 0.24, // SEGUNDO PUNTO DE CONTROL Y
        size.width * 0.6, // PUNTO FINAL X
        size.height * 0.2 // PUNTO FINAL Y
    );

    // 7. SE DIBUJA LA ONDA FINAL MAS GRANDE, QUE SUBE MAS ALTA
    path.cubicTo(
        size.width * 0.85, // PRIMER PUNTO DE CONTROL X
        size.height * 0.05, // PRIMER PUNTO DE CONTROL Y
        size.width * 0.9, // SEGUNDO PUNTO DE CONTROL X
        size.height * 0.15, // SEGUNDO PUNTO DE CONTROL Y
        size.width, // PUNTO FINAL X (BORDE DERECHO)
        size.height * 0.18 // PUNTO FINAL Y
    );

    // 8. SE CIERRA EL CAMINO BAJANDO HASTA LA PARTE INFERIOR
    path.lineTo(size.width, size.height); // LLEVA LA LINEA AL FONDO DERECHO
    path.lineTo(0, size.height); // LLEVA LA LINEA AL FONDO IZQUIERDO
    path.close(); // CIERRA EL CAMINO

    // 9. SE CREA LA SOMBRA DESPLAZANDO EL CAMINO PRINCIPAL HACIA ARRIBA
    shadowPath.addPath(path, Offset(0, -10)); // MUEVE EL CAMINO 10 PIXELES ARRIBA

    // 10. SE DIBUJA PRIMERO LA SOMBRA PARA QUE QUEDE DEBAJO DE LA WAVE
    canvas.drawPath(shadowPath, shadowPaint);

    // 11. SE DIBUJA LA WAVE PRINCIPAL ENCIMA DE LA SOMBRA
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // DEVUELVE FALSE PORQUE ESTA WAVE NO CAMBIA Y NO NECESITA REPINTARSE
    return false;
  }
}