import 'package:flutter/material.dart';

import '../../../utilities/app_color.dart';
import '../../../utilities/internationalization.dart';

/// Esta clase proporciona métodos estáticos para crear diferentes tipos de iconos
/// con Tooltips, como `Icon`, `IconButton` e `IconButton` con imágenes.
///
/// Los iconos y botones tienen una personalización básica para sus tamaños y mensajes
/// de Tooltips. Se utiliza la internacionalización para mostrar los textos correspondientes.
class IconClass {
  /// Crea un icono con un Tooltip asociado.
  ///
  /// El método devuelve un `Tooltip` que envuelve un `Icon`. Si no se especifica
  /// un tamaño, el valor por defecto es 25.
  ///
  /// Parametros:
  /// - `context`: El contexto de la aplicación.
  /// - `icon`: El icono que se va a mostrar.
  /// - `messageKey`: La clave de mensaje para obtener el texto del Tooltip.
  /// - `size`: El tamaño del icono. Si es `null`, el valor predeterminado es 25.
  static Tooltip iconMaker(BuildContext context, IconData icon, String messageKey, [double? size]){
    size ??= 25; // SI NO SE INTRODUCE UN TAMAÑO, POR DEFECTO SERA 25
    final messageTooltip = Internationalization.internationalization.getLocalizations(context, messageKey);
    return Tooltip(
      message: messageTooltip,
      child: Icon(icon, color: AppColors.darkPurpleColor, size: size),
    );
  } // METODO QUE DEVUELVE UN ICONO CON UN TOOLTIP

  /// Crea un `IconButton` con un Tooltip.
  ///
  /// El método devuelve un `IconButton` que contiene un `Icon`. Al hacer clic
  /// en el botón, se ejecuta la función proporcionada.
  ///
  /// Parametros:
  /// - `context`: El contexto de la aplicación.
  /// - `function`: La función que se ejecutará cuando el botón sea presionado.
  /// - `tooltip`: La clave de mensaje para obtener el texto del Tooltip.
  /// - `icon`: El icono que se va a mostrar en el `IconButton`.
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

  /// Crea un `IconButton` con una imagen como ícono, y un Tooltip asociado.
  ///
  /// El método devuelve un `Tooltip` que envuelve un `ElevatedButton` con una imagen
  /// como su ícono. El fondo y la sombra del botón son transparentes, lo que permite que
  /// se use solo la imagen.
  ///
  /// Parametros:
  /// - `context`: El contexto de la aplicación.
  /// - `function`: La función que se ejecutará cuando el botón sea presionado.
  /// - `filePath`: La ruta del archivo de la imagen que se va a mostrar en el botón.
  /// - `messageKey`: La clave de mensaje para obtener el texto del Tooltip.
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
