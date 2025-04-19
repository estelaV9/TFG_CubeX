import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/internationalization.dart';

/// Widget que muestra un popover personalizado que permite ordenar los tiempos por fecha o tiempo.
///
/// Este widget usa un `Overlay` para mostrar un popover encima de los tiempos. El popover
/// contiene opciones para ordenar los tiempos de la sesión por fecha (ascendente o descendente)
/// o por tiempo (ascendente o descendente). Al seleccionar una opción, el estado se actualiza.
///
/// Parámetros:
/// - `child`: El widget que actúa como disparador para mostrar el popover. En este caso, es un boton de más opciones.
class CustomPopover extends StatefulWidget {
  final Widget child;

  const CustomPopover({super.key, required this.child});

  @override
  _CustomPopoverState createState() => _CustomPopoverState();
}

class _CustomPopoverState extends State<CustomPopover> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  /// Método para mostrar el `Popover` al hacer `tap` sobre el widget.
  ///
  /// Este método calcula la posición del widget en la pantalla, ajusta el posicionamiento
  /// del popover y lo muestra en la interfaz.
  void _showPopover(BuildContext context) {
    final currentTime = context.read<CurrentTime>();
    // ENCUENTRA LA POSICION DEL WIDGET
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    // CALCULA LA POSICION HORIZONTAL PARA CENTRAR O ALINEAR EL POPOVER
    double calculateLeftPosition() {
      double left = offset.dx;
      if (left + 250 > screenWidth) {
        left = screenWidth - 250 - 8; // Alinea el popover a la derecha
      }
      return left;
    }

    // CREA EL OVERLAY PARA MOSTRAR EL POPOVER
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // FONDO TRANSPARENTE PARA CERRAR EL POPOVER AL TOCAR FUERA
          Positioned.fill(
            child: GestureDetector(
              // ELIMINAR POPOVER
              onTap: _removePopover,
              child: Container(color: Colors.transparent),
            ),
          ),

          // POSICIONAMIENTO DEL POPOVER
          Positioned(
            top: offset.dy + size.height + 10, // JUSTO DEBAJO DEL WIDGET
            left: calculateLeftPosition(),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // FLECHA DEL POPOVER
                  Positioned(
                    left: offset.dx -
                        calculateLeftPosition() +
                        size.width / 2 -
                        8,
                    child: CustomPaint(
                      painter: TrianglePainter(
                        fillColor: AppColors.vibrantPurple,
                      ),
                      child: const SizedBox(
                        width: 16,
                        height: 10,
                      ),
                    ),
                  ),

                  // CONTENIDO DEL POPOVER
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: AppColors.popoverBackground,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.darkPurpleColor,
                            blurRadius: 10,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  AppColors.popoverBackground.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Internationalization.internationalization
                                    .localizedTextOnlyKey(
                                  context,
                                  "sort_by",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 23,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white24,
                                  height: 1,
                                  indent: 15,
                                  endIndent: 15,
                                ),

                                // EXPANSIONTILE DE FECHA
                                _buildExpansionTile(
                                  icon: Icons.calendar_month,
                                  title: "date",
                                  titleHint: "order_date_hint",
                                  onTapOption1: () {
                                    // ORDENAR POR FECHA ASCENDENTE
                                    currentTime.setDateAsc(true);
                                    currentTime.setTimeAsc(null);
                                  },
                                  onTapOption2: () {
                                    // ORDENAR POR FECHA DESCENDENTE
                                    currentTime.setDateAsc(false);
                                    currentTime.setTimeAsc(null);
                                  },
                                ),

                                // EXPANSIONTILE DE TIEMPO
                                _buildExpansionTile(
                                  icon: Icons.timer,
                                  title: "time",
                                  titleHint: "order_time_hint",
                                  onTapOption1: () {
                                    // ORDENAR POR TIEMPO ASCENDENTE
                                    currentTime.setTimeAsc(true);
                                    currentTime.setDateAsc(null);
                                  },
                                  onTapOption2: () {
                                    // ORDENAR POR TIEMPO DESCENDENTE
                                    currentTime.setTimeAsc(false);
                                    currentTime.setDateAsc(null);
                                  },
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: _removePopover,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: Internationalization
                                          .internationalization
                                          .createLocalizedSemantics(
                                        context, "close_popover", "close_popover_hint", "close_popover",
                                        const TextStyle(
                                            color: AppColors.vibrantPurple),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // MUESTRA EL OVERLAY
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Método para eliminar el popover actual de la vista.
  void _removePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Método auxiliar para construir un `ExpansionTile`
  ///
  /// Este método se utiliza para crear un `ExpansionTile` con las opciones de ordenar por
  /// fecha o tiempo y así, evitar la repetición de código.
  ///
  /// Parámetros:
  /// - `icon` (IconData): El ícono que se muestra al lado del título en el `ExpansionTile`. Este
  ///   ícono representa el tipo de orden (un calendario o un reloj).
  /// - `title` (String): El título que aparece en el `ExpansionTile`.
  /// - `titleHint` (String): El hint del titulo para los `Semantics`.
  /// - `onTapOption1` (Function()): La función que se ejecuta cuando el usuario selecciona la primera opción
  ///   (`option1`). Esta función debería realizar el cambio de estado correspondiente para ordenar los elementos.
  /// - `onTapOption2` (Function()): La función que se ejecuta cuando el usuario selecciona la segunda opción
  ///   (`option2`). Similar a `onTapOption1`, esta función cambia el estado para ordenar de otra forma.
  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required String titleHint,
    required Function() onTapOption1,
    required Function() onTapOption2,
  }) {
    return ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      leading: Icon(icon, color: Colors.white),
      title: Internationalization.internationalization.createLocalizedSemantics(
        context, title, titleHint, title,
        const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      collapsedBackgroundColor: AppColors.popoverBackground,
      backgroundColor: AppColors.purpleIntroColor,
      children: [
        ListTile(
          leading: const Icon(Icons.arrow_upward, color: Colors.white70),
          title: Internationalization.internationalization
              .createLocalizedSemantics(context, "ascending", "ascending_hint",
                  "ascending", const TextStyle(color: Colors.white)),
          onTap: onTapOption1,
        ),
        ListTile(
          leading: const Icon(Icons.arrow_downward, color: Colors.white70),
          title: Internationalization.internationalization
              .createLocalizedSemantics(
                  context, "descending", "descending_hint", "descending",
                  const TextStyle(color: Colors.white)),
          onTap: onTapOption2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: () => _showPopover(context),
      child: widget.child,
    );
  }
}

/// Painter personalizado para dibujar una flecha triangular para el `Popover`.
///
/// Esta clase extiende de `CustomPainter` y permite dibujar una flecha triangular
/// que se utilizará para el indicador del popover.
/// El color de la flecha es configurable a través del parámetro `fillColor`, que se
/// pasa al constructor. La flecha se dibuja utilizando el `Canvas` para crear el
/// triángulo, que tiene una base en la parte inferior y un vértice en la parte superior.
class TrianglePainter extends CustomPainter {
  // COLOR QUE SE UTILIZA PARA RELLENAR EL TRIANGULO
  final Color fillColor;

  TrianglePainter({required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    // SE CREA UN OBJETO Paint PARA DEFINIR LAS PROPIEDADES DE ESTILO DEL TRIANGULO
    final paint = Paint()
      ..color = fillColor // ESTABLECE EL COLOR DEL TRIANGULO
      ..style =
          PaintingStyle.fill; // SE ESTABLECE EL ESTILO DE RELLENO (SIN BORDES)

    // OBJETO PATH PARA DIBUJAR LA FORMA DEL TRIANGULO
    final path = Path();

    // COMIENZA EL TRAZO DEL TRIANGULO DESDE LA ESQUINA INFERIOR IZQUIERDA
    path.moveTo(0, size.height);

    // LINEA HACIA EL VERTICE SUPERIOR DEL TRIANGULO
    path.lineTo(size.width / 2, 0);

    // LINEA DESDE EL VERTICE HASTA LA ESQUINA INFERIOR DERECHA
    path.lineTo(size.width, size.height);

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