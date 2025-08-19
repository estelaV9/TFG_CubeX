import 'package:flutter/material.dart';

/// Painter que dibuja una linea horizontal solida.
///
/// Se utiliza principalmente en el `StepperWidget` para mostrar
/// la conexion entre los pasos.
class SolidLinePainter extends CustomPainter {
  final Color color;

  SolidLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // DEFINIR EL PINCEL PARA DIBUJAR LA LINEA
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    // DIBUJAR UNA LINEA HORIZONTAL DESDE EL INICIO HASTA EL FINAL DEL CANVAS
    // SE UBICA EN EL CENTRO VERTICAL DEL AREA DISPONIBLE
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  } // paint

  // COMO LA LINEA NO CAMBIA DINAMICAMENTE, NO NECESITA REDIBUJARSE
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
