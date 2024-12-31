import 'package:esteladevega_tfg_cubex/components/cube_type_menu.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

class AnimatedIconWidget extends StatefulWidget {
  final AnimatedIconData animatedIconData;

  const AnimatedIconWidget({super.key, required this.animatedIconData});

  @override
  _AnimatedIconWidgetState createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  bool isMenuVisible = false; // COMPROBAR SI EL MENU ESTA VISIBLE O NO
  late AnimationController animationController; // CONTROLADOR DE LA ANIMACIÓN
  OverlayEntry? _overlayEntry; // MANEJAR EL MENU COMO OVERLAY

  @override
  void initState() {
    super.initState();
    // SE INCIALIZA EL CONTROLADOR DE LA ANIMACIÓN CON UNA DURACION DE 1 SEGUNDO
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this, // VSYNC HACE QUE SOLO TENGA UNA ANIMACION A LA VEZ
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // SE CREA EL ICONO CON UNA ANIMACION DE ABRIR Y CERRAR EL MENU
      icon: AnimatedIcon(
        icon: widget.animatedIconData,
        progress: animationController,
        color: AppColors.darkPurpleColor,
        size: 20.0,
      ),
      onPressed: () {
        if (isMenuVisible) {
          // SI EL MENU ESTA VISIBLE, SE OCULTA
          _removeOverlay(); // SE ELIMINA EL OVERLAY
          animationController.reverse();
        } else {
          // SI EL MENU NO ESTA VISIBLE, SE MUESTRA
          _showOverlay(); // MOSTRAR EL OVERLAY
          animationController.forward();
        } // CUANDO SE PRESIONE EL ICONO, SE AGREGA/QUITA EL  MENU DEL OVERLAY
      },
    );
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry(); // SE INICIALIZA EL OVERLAYENTRY
    // SE INSERTA EL OVERLAY
    Overlay.of(context)?.insert(_overlayEntry!);

    setState(() {
      isMenuVisible = true;
    }); // SE ACUTALIZA EL ESTADO VISIBLE
  } // METODO PARA MOSTRAR EL OVERLAY CON EL CubeTypeMenu

  void _removeOverlay() {
    _overlayEntry?.remove(); // SE ELIMINA EL OVERLAY
    setState(() {
      isMenuVisible = false;
    }); // SE ACTUALIZA EL ESTADO VISIBLE
  } // METODO PARA ELIMINAR EL OVERLAY

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // AL TOCAR FUERA, SE CIERRA EL MENU
            _removeOverlay(); // ELIMINAR EL OVERLAY
            animationController.reverse(); // VOLVER AL ESTADO INICIAL
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  // SE PONE EL FONDO MEDIO OSCURO CUANDO APARECE EL MENU
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Center(
                child: Container(
                  width: 289,
                  height: 376,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red,
                  ),
                  child: const CubeTypeMenu(), // MENÚ DE TIPOS DE CUBOS
                ),
              ),
            ],
          ),
        );
      },
    );
  } // CREAR EL OVERLAYENTRY PARA MOSTRAR EL CubeTypeMenu

  @override
  void dispose() {
    // SE DESCARTA EL CONTROLADOR DE LA ANIMACION CUANDO YA NO SE NECESITE
    animationController.dispose();
    super.dispose();
  }
}
