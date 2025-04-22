import 'package:flutter/material.dart';
import '../../view/screen/settings.dart';

/// Provider para gestionar el **idioma actual** de la aplicación.
///
/// Permite cambiar el idioma y guarda la preferencia en `SharedPreferences`.
class CurrentLanguage extends ChangeNotifier {
  /// Idioma de la aplicación, iniciando por el idioma que se guardó en las preferencias de la aplicación.
  Locale locale =
      Locale(SettingsScreenState.preferences.getString("language") ?? "EN");

  /// Cambia el idioma de la aplicación y actualiza la preferencia guardada.
  void cambiarIdioma(String idioma) async {
    locale = Locale(idioma);
    await SettingsScreenState.preferences.setString("language", idioma);
    notifyListeners();
  }
}
