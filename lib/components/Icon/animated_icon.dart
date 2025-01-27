import 'package:esteladevega_tfg_cubex/components/cube_type_menu.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../../model/cubetype.dart';

class AnimatedIconWidget extends StatefulWidget {
  final AnimatedIconData animatedIconData;
  final void Function(CubeType selectedCubeType) onCubeTypeSelected;

  const AnimatedIconWidget({
    super.key,
    required this.animatedIconData,
    required this.onCubeTypeSelected,
  });

  @override
  _AnimatedIconWidgetState createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  bool isMenuVisible = false; // COMPROBAR SI EL MENU ESTA VISIBLE O NO
  late AnimationController animationController; // CONTROLADOR DE LA ANIMACIÓN

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
      tooltip: "Choose cube type",
      // SE CREA EL ICONO CON UNA ANIMACION DE ABRIR Y CERRAR EL MENU
      icon: AnimatedIcon(
        icon: widget.animatedIconData,
        progress: animationController,
        color: AppColors.darkPurpleColor,
        size: 20.0,
      ),
      onPressed: () {
        if (isMenuVisible) {
          // SI EL MENU ESTA VISIBLE, SE EL MODAL
          Navigator.of(context).pop();
          animationController.reverse();
        } else {
          // SI EL MENU NO ESTA VISIBLE, SE MUESTRA
          _showOverlay(); // MOSTRAR EL OVERLAY
          animationController.forward(); // ANIMACION DE APERTURA
        } // CUANDO SE PRESIONE EL ICONO, SE AGREGA/QUITA EL modal
      },
    );
  }

  void _showOverlay() {
    showModalBottomSheet(
      // backgroundColor: AppColors.purpleIntroColor,
      context: context,
      builder: (BuildContext context) {
        return CubeTypeMenu(
          onCubeTypeSelected: widget.onCubeTypeSelected // PASA EL TIPO DE CUBO
        );
      },
    ).whenComplete(() {
      setState(() {
        isMenuVisible = false;
      });
      animationController.reverse(); // REVERTIMOS LA ANIMACION DE CIERRE
    }); // CUANDO EL MODAL SE HA CERRADO, REVERTIMOS LA ANIMACION

    setState(() {
      // CAMBIAMOS DE VALOR
      isMenuVisible = true;
    });
  }

  @override
  void dispose() {
    // SE DESCARTA EL CONTROLADOR DE LA ANIMACION CUANDO YA NO SE NECESITE
    animationController.dispose();
    super.dispose();
  }
}
