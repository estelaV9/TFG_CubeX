import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';

/// La clase `DrawerWave` dibuja una wave personalizada con color de fondo violeta y una sombra morada oscura.
///
/// Esta clase extiende de [CustomPainter], para dibujar una wave personalizadas en el Drawer.
///
/// La onda tiene dos secciones: una onda pequeña y una onda grande.
/// Ademas, esta wave tiene un color de fondo configurable a través del parámetro [backgroundColor],
/// que, por defecto es un color violeta claro, y una sombra desplazada ligeramente hacia abajo
/// para dar un contorno.
class DrawerWave extends CustomPainter {
  /// Color de fondo de la wave.
  final Color backgroundColor;

  /// Constructor que permite definir el color de la wave.
  /// Por defecto, se usa un tono violeta claro.
  DrawerWave({this.backgroundColor = AppColors.lightVioletColor});

  @override
  void paint(Canvas canvas, Size size) {
    // SE CREA UN OBJETO PAINT QUE SE USA PARA DIBUJAR LA WAVE PRINCIPAL
    final paint = Paint()
      ..color = backgroundColor // COLOR DE LA ONDA
      ..style = PaintingStyle.fill; // RELLENATODO EL AREA

    // SE CREA UN PAINT PARA LA SOMBRA, USANDO UN COLOR SOLIDO
    final shadowPaint = Paint()
      ..color = AppColors.darkPurpleColor // COLOR DE LA SOMBRA
      ..style = PaintingStyle.fill; // LA SOMBRA TAMBIEN SE RELLENA COMPLETA

    // SE CREA UN OBJETO PATH PARA DIBUJAR LA WAVE PRINCIPAL
    final path = Path();
    // SE CREA OTRO PATH PARA DIBUJAR LA SOMBRA
    final shadowPath = Path();

    // DIBUJAMOS LA WAVE DESDE LA ESQUINA INFERIOR IZQUIERDA
    path.moveTo(0, size.height); // INICIO EN LA ESQUINA INFERIOR IZQUIERDA

    // PRIMERA CURVA DE LA ONDA
    path.cubicTo(
        size.width * 0.1, size.height * 1.14, // PRIMER PUNTO
        size.width * 0.4, size.height * 0.6, // SEGUNDO PUNTO
        size.width * 0.5, size.height * 1.0 // PUNTO FINAL DE LA PRIMERA CURVA
    );

    // SEGUNDA CURVA DE LA ONDA
    path.cubicTo(
        size.width * 0.65, size.height * 1.6, // PRIMER PUNTO
        size.width * 0.9, size.height * 0.69, // SEGUNDO PUNTO
        size.width, size.height * 1.1 // PUNTO FINAL DE LA SEGUNDA CURVA
    );

    // CERRAMOS LA FORMA UNIENDO EL BORDE SUPERIOR
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close(); // CIERRA EL CAMINO

    // SE CREA LA SOMBRA DESPLAZANDO EL CAMINO PRINCIPAL HACIA ARRIBA
    shadowPath.addPath(path, const Offset(0, 6));

    // SE DIBUJA PRIMERO LA SOMBRA PARA QUE QUEDE DEBAJO DE LA WAVE
    canvas.drawPath(shadowPath, shadowPaint);

    // SE DIBUJA LA WAVE PRINCIPAL ENCIMA DE LA SOMBRA
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // DEVUELVE FALSE PORQUE ESTA WAVE NO CAMBIA Y NO NECESITA REPINTARSE
    return false;
  }
}