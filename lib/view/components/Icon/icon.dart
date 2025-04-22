import 'package:flutter/material.dart';

import '../../../view/utilities/app_color.dart';
import '../../utilities/internationalization.dart';

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
  /// - `color`: El color del icono. Si no se proporciona ningun color, será morado oscuro.
  static Tooltip iconMaker(
      BuildContext context, IconData icon, String messageKey,
      [double? size = 25, Color color = AppColors.darkPurpleColor]) {
    final messageTooltip = Internationalization.internationalization
        .getLocalizations(context, messageKey);
    return Tooltip(
      message: messageTooltip,
      child: Icon(icon, color: color, size: size),
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
  /// - `colors`: Color para el icono opcional, el cual por defecto será un morado oscuro.
  /// - `size`: El tamaño del icono del botón. Si es `null`, pondrá el valor predeterminado.
  /// - `padding`: Padding del botón. Si es `null`, aplica el padding predeterminado.
  static IconButton iconButton(
      BuildContext context, Function()? function, String tooltip, IconData icon,
      [Color? colors = AppColors.darkPurpleColor,
      double? size,
      EdgeInsetsGeometry? padding]) {
    final messageTooltip = Internationalization.internationalization
        .getLocalizations(context, tooltip);

    return IconButton(
        onPressed: function,
        color: colors,
        padding: padding,
        tooltip: messageTooltip,
        icon: Icon(icon, size: size));
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
  static Tooltip iconButtonImage(BuildContext context, VoidCallback function,
      String filePath, String messageKey,
      [double? size]) {
    final messageTooltip = Internationalization.internationalization
        .getLocalizations(context, messageKey);

    // SI EL TAMAÑO ES NULO, SE LE AÑADE UN VALOR POR DEFECTO
    size ??= 40;

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
            width: size,
            height: size,
            filePath,
            color: AppColors.darkPurpleColor,
          ))),
    );
  } // METODO QUE DEVUELVE UN ICONBUTTON PERO POR IMAGEN
}