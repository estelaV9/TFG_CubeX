import 'package:esteladevega_tfg_cubex/view/components/tooltip/triangle_painter.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';

/// Widget que muestra un popover personalizado que permite sugerir un nombre que
/// no este registrado en la base de datos.
///
/// Este widget usa un `Overlay` para mostrar un popover encima del campo del formulario
/// de nombre. El popover contiene el texto con el nombre. Al seleccionarlo, se cierra
/// el popover.
///
/// Parámetros:
/// - `child`: El widget que actúa como disparador para mostrar el popover.
class CustomPopoverSuggestion extends StatefulWidget {
  final Widget child;

  const CustomPopoverSuggestion({super.key, required this.child});

  @override
  State<CustomPopoverSuggestion> createState() =>
      _CustomPopoverSuggestionState();
}

class _CustomPopoverSuggestionState extends State<CustomPopoverSuggestion> {
  OverlayEntry? _overlayEntry;

  /// Método para mostrar el `Popover` al hacer `tap` sobre el widget.
  ///
  /// Este método calcula la posición del widget en la pantalla, ajusta el posicionamiento
  /// del popover y lo muestra en la interfaz.
  void _showPopover(BuildContext context) {
    // ENCUENTRA LA POSICION DEL WIDGET
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    // CALCULA LA POSICION HORIZONTAL PARA CENTRAR O ALINEAR EL POPOVER
    double calculateLeftPosition() {
      double left = offset.dx;
      if (left + 250 > screenWidth) {
        // SE ALINEA EL POPOVER A LA DERECHA
        left = screenWidth - 250 - 8;
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
            top: offset.dy + size.height - 40, // JUSTO ENCIMA DEL WIDGET
            left: calculateLeftPosition(),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CONTENIDO DEL POPOVER
                  Container(
                    width: 140,
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
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.popoverBackground.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        // SE MUESTRA EL TEXTO
                        child: Center(child: widget.child)),
                  ),

                  // FLECHA DEL POPOVER APUNTANDO HACIA ABAJO
                  CustomPaint(
                    painter: TrianglePainter(
                        fillColor: AppColors.vibrantPurple,
                        isPointingUp: false),
                    child: const SizedBox(
                      width: 16,
                      height: 10,
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

  @override
  void initState() {
    super.initState();
    // SE MUESTRA EL POPOVER AUTOMATICAMENTE CUANDO SE MONTA
    // EL WIDGET
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPopover(context);
    });
  }

  @override
  void dispose() {
    // CUANDO SE DESTRUYE, SE ELIMINA EL POPOVER
    _removePopover();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // (no hace nada)
    return Container();
  }
}