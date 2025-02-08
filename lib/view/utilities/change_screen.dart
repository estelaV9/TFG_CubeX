import 'package:flutter/material.dart';

/// Clase que se utiliza para gestionar la **navegación entre pantallas** en la aplicación.
///
/// Esta clase proporciona un método estático para cambiar de una pantalla a otra
/// de forma sencilla, evitando la repetición de código en múltiples partes de la app.
class ChangeScreen {
  /// Navega a una nueva pantalla dentro de la aplicación.
  ///
  /// Este método utiliza el `Navigator.push` para colocar una nueva pantalla sobre
  /// la actual, permitiendo al usuario volver atrás si lo desea.
  ///
  /// - [nameScreen]: El widget de la pantalla de destino a la que se desea navegar.
  /// - [context]: El contexto de la aplicación necesario para gestionar la navegación.
  static void changeScreen(Widget nameScreen, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => nameScreen,
      ),
    );
  }
}
