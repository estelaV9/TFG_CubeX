import 'package:flutter/material.dart';

import '../../../utilities/app_color.dart';
import '../../../utilities/internationalization.dart';

class IconClass {

  static Tooltip iconMaker(BuildContext context, IconData icon, String messageKey, [double? size]){
    size ??= 25; // SI NO SE INTRODUCE UN TAMAÑO, POR DEFECTO SERA 25
    final messageTooltip = Internationalization.internationalization.getLocalizations(context, messageKey);
    return Tooltip(
      message: messageTooltip,
      child: Icon(icon, color: AppColors.darkPurpleColor, size: size),
    );
  } // METODO QUE DEVUELVE UN ICONO CON UN TOOLTIP

  static IconButton iconButton(BuildContext context,
      VoidCallback function, String tooltip, IconData icon) {
    final messageTooltip = Internationalization.internationalization.getLocalizations(context, tooltip);

    return IconButton(
        onPressed: () {
          function();
        },
        color: AppColors.darkPurpleColor,
        tooltip: messageTooltip,
        icon: Icon(icon));
  } // METODO QUE DEVUELVE UN ICONBUTTON

  static Tooltip iconButtonImage(BuildContext context,
      VoidCallback function, String filePath, String messageKey) {
    final messageTooltip = Internationalization.internationalization.getLocalizations(context, messageKey);

    return Tooltip(
      // CUANDO SE PASE EL MOUSE SALDRA UN TEXTO
      message: messageTooltip,
      child: ElevatedButton(
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
            minimumSize: const Size(5, 40),
          ),
          child: SizedBox(
              child: Image.asset(
            // SE LE DA UN TAMAÑO A LA IMAGEN
            width: 40,
            height: 40,
            filePath,
            color: AppColors.darkPurpleColor,
          ))),
    );
  } // METODO QUE DEVUELVE UN ICONBUTTON PERO POR IMAGEN
}
