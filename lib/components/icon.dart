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

  // SE DEFINE EL CONTROLADOR DE LA ANIMACIÓN
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    // SE INCIALIZA EL CONTROLADOR DE LA ANIMACIÓN CON UNA DURACION DE 1 SEGUNDO
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this, // VSYNC HACE QUE SOLO TENGA UNA ANIMACION A LA VEZ
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // SE CREA EL ICONO CON UNA ANIMACION DE ABRIR Y CERRAR EL MENU
      icon: AnimatedIcon(
        icon: widget.animatedIconData, // ICONO
        progress: animationController, // PROGRESO DE LA ANIMACION
        color: AppColors.darkPurpleColor,
        size: 20.0,
      ),
      onPressed: () {
        // AL PRESIONAR EL ICONO, SE INICIA O REVIERTE LA ANIMACION
        if (animationController.isCompleted) {
          animationController.reverse(); // SE REVIERTE (CERRAR MENU)
        } else {
          animationController.forward(); // SE INICIA (ABRIR MENU)
        }
      },
    );
  }

  @override
  void dispose() {
    // SE DESCARTA EL CONTROLADOR DE LA ANIMACION CUANDO YA NO SE NECESITE
    animationController.dispose();
    super.dispose();
  }
}
