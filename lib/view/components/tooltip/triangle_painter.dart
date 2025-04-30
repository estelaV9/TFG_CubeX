import 'package:flutter/material.dart';

/// Painter personalizado para dibujar una flecha triangular para el `Popover`.
///
/// Esta clase extiende de `CustomPainter` y permite dibujar una flecha triangular
/// que se utilizará para el indicador del popover.
/// El color de la flecha es configurable a través del parámetro `fillColor`, que se
/// pasa al constructor. La flecha se dibuja utilizando el `Canvas` para crear el
/// triángulo, que tiene una base en la parte inferior y un vértice en la parte superior.
///
/// Se dibuja un triángulo apuntando hacia arriba o hacia abajo segun el parametro
/// [isPointingUp].
class TrianglePainter extends CustomPainter {
  // COLOR QUE SE UTILIZA PARA RELLENAR EL TRIANGULO
  final Color fillColor;
  // SI ES TRUE, LA FLECHA APUNTA HACIA ARRIBA Y SI NO, HACIA ABAJO
  final bool isPointingUp;

  TrianglePainter({required this.fillColor, this.isPointingUp = true,});

  @override
  void paint(Canvas canvas, Size size) {
    // SE CREA UN OBJETO Paint PARA DEFINIR LAS PROPIEDADES DE ESTILO DEL TRIANGULO
    final paint = Paint()
      ..color = fillColor // ESTABLECE EL COLOR DEL TRIANGULO
      ..style = PaintingStyle.fill; // SE ESTABLECE EL ESTILO DE RELLENO (SIN BORDES)

    // OBJETO PATH PARA DIBUJAR LA FORMA DEL TRIANGULO
    final path = Path();

    // COMIENZA EL TRAZO DEL TRIANGULO DESDE LA ESQUINA INFERIOR IZQUIERDA
    path.moveTo(0, isPointingUp ? size.height : 0);

    // LINEA HACIA EL VERTICE SUPERIOR DEL TRIANGULO
    path.lineTo(size.width / 2, isPointingUp ? 0 : size.height);

    // LINEA DESDE EL VERTICE HASTA LA ESQUINA INFERIOR DERECHA
    path.lineTo(size.width, isPointingUp ? size.height : 0);

    // SE CIERRA EL TRIANGULO CONECTANDO EL ULTIMO PUNTO CON EL PRIMERO
    path.close();

    // SE DIBUJA EL TRIANGULO CON EL COLOR Y ESTILO DEFINIDO
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // NO ES NECESARIO REPINTAR, YA QEU EL TRIANGULO NO CAMBIA DESPUES DE SER DIBUJADO
    return false;
  }
}