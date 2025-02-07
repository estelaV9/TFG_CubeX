import 'package:flutter/material.dart';
import '../view/screen/settings.dart';

class CurrentLanguage extends ChangeNotifier {
  Locale locale =
      Locale(SettingsScreenState.preferences.getString("language") ?? "EN");

  void cambiarIdioma(String idioma) async {
    locale = Locale(idioma);
    await SettingsScreenState.preferences.setString("language", idioma);
    notifyListeners();
  }
}
