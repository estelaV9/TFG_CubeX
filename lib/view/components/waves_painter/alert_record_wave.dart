import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';

/// Clase **AlertRecordWave** para dibujar una forma personalizada.
///
/// Esta clase permite personalizar el color de fondo y mostrar un mensaje dentro de esta figura.
/// (Todavia no esta implementada ya que no se ha logrado la forma)
///
/// Propiedades principales:
/// - `backgroundColor`: Color de fondo que será utilizado para pintar la forma.
/// - `message`: Mensaje que se mostrará dentro de la forma.
class AlertRecordWave extends CustomPainter {
  final Color backgroundColor;
  String message = "";

  AlertRecordWave({this.backgroundColor = AppColors.lightVioletColor, required String message});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. SE CREA UN OBJETO PAINT PARA DIBUJAR LA WAVE PRINCIPAL
    // ASIGNANDOLE UN BG
    final paint = Paint()
      ..color = backgroundColor // COLOR DE FONDO
      ..style = PaintingStyle.fill; // RELLENA EL AREA COMPLETA

    // 2. SE CREA UN OBJETO PATH PARA DIBUJAR LA WAVE
    final path = Path();

    path.moveTo(size.width * 0.5, 0);

    path.cubicTo(
        size.width * 0.8, 0,
        size.width, size.height * 0.2,
        size.width, size.height * 0.5);

    path.cubicTo(
        size.width * 0.5, size.height * 0.8,
        size.width * 0.89, size.height * 0.99,
        size.width * 0.2, size.height);

    path.cubicTo(
        size.width * 0.2, size.height,
        0, size.height * 0.9,
        0, size.height * 0.5);

    path.cubicTo(
        0, size.height * 0.3,
        size.width * 0.2, size.height * 0.3,
        size.width * 0.5, 0);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // DEVUELVE FALSE PORQUE ESTA WAVE NO CAMBIA Y NO NECESITA REPINTARSE
    return false;
  }
}