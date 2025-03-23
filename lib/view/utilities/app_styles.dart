import 'package:flutter/material.dart';

import 'app_color.dart';

/// Clase que contiene los estilos de texto utilizados en la aplicación.
/// (por ahora solo las del timer)
///
/// Esta clase define constantes de estilos de texto que se usan para los diferentes componentes de la aplicación,
/// incluyendo los botones, títulos y texto deshabilitado. Los estilos están basados en los colores definidos
/// en la clase `AppColors` y tienen variaciones para diferentes estados de los botones y elementos.
class AppStyles {
  /// Obtiene el estilo de texto para un botón según su estado.
  ///
  /// Este método devuelve un `TextStyle` dependiendo de si el botón está habilitado
  /// y si está seleccionado. Los estilos varían en color para reflejar el estado actual.
  ///
  /// **Características**:
  /// - Si el botón está deshabilitado (`isEnabled == false`), el texto se muestra con opacidad.
  /// - Si el botón está habilitado y seleccionado (`isSelected == true`), el color del texto es violeta claro.
  /// - Si el botón está habilitado pero no seleccionado, el color del texto es morado oscuro.
  ///
  /// **Parámetros**:
  /// - `isSelected` (`bool`): Indica si el botón está seleccionado.
  /// - `isEnabled` (`bool`): Indica si el botón está habilitado.
  ///
  /// **Retorna**:
  /// - Un objeto `TextStyle` con el tamaño de fuente, peso y color correspondientes.
  static TextStyle getButtonTextStyle(bool isSelected, bool isEnabled) {
    if (!isEnabled) {
      // SI NO HAY TIEMPO ACTUAL, SE PONE CON OPACIDAD
      return disabled;
    } // SI EL USUARIO TODAVIA NO HA HECHO NINGUN TIEMPO

    // SI ESTA SELECCIONADO, SE CAMBIA A VIOLETA Y SI NO ESTA SELECCIONADO
    // PERO HAY UN TIEMPO ACTUAL, SE PONE EN MORADO
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color:
          isSelected ? AppColors.lightVioletColor : AppColors.darkPurpleColor,
    );
  } // FUNCION PARA EL ESTILO DE TEXTO DEL BOTON

  /// Estilo de texto para los elementos deshabilitados.
  ///
  /// - Fuente en negrita, tamaño 20 y color morado con opacidad.
  static TextStyle disabled = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.darkPurpleOpacity);

  /// Estilo de texto para las estadísticas o textos generales de la aplicación.
  ///
  /// - Fuente en negrita, tamaño 15 y color morado oscuro.
  static const TextStyle statsTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.darkPurpleColor,
  );
}
