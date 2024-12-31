import 'package:flutter/material.dart';

import '../../utilities/app_color.dart';

class IconClass {
  static IconButton iconButton(
      VoidCallback function, String tooltip, IconData icon) {
    return IconButton(
        onPressed: () {
          function();
        },
        color: AppColors.darkPurpleColor,
        tooltip: tooltip,
        icon: Icon(icon));
  } // METODO QUE DEVUELVE UN ICONBUTTON

  static ElevatedButton iconButtonImage(
      VoidCallback function, String filePath) {
    return ElevatedButton(
        onPressed: () {
          function();
        },
        style: ElevatedButton.styleFrom(
          // SE QUITA EL COLOR DE FONDO Y LA SOMBRA PARA HACERLO TRANSPARENTE
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          // SE QUITA EL PADDIN QUE TIENE ALREDEDOR
          padding: EdgeInsets.zero,
          // SE LE DA UN TAMAÑO AL BOTON
          minimumSize: Size(5, 40),
        ),
        child: SizedBox(
            child: Image.asset(
          // SE LE DA UN TAMAÑO A LA IMAGEN
          width: 40,
          height: 40,
          filePath,
          color: AppColors.darkPurpleColor,
        )));
  } // METODO QUE DEVUELVE UN ICONBUTTON PERO POR IMAGEN
}
