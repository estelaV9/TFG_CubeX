import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider encargado de gestionar el **tipo de cubo** seleccionado
/// por el usuario en la guía de aprendizaje.
///
/// - Permite establecer y recuperar la selección actual.
/// - Guarda el valor en el [SharedPreferences].
/// - Notifica a los listeners cada vez que el valor cambia.
class CubeSelectionProvider with ChangeNotifier {
  // TIPO DE CUBO SELECCIONADO ACTUALMENTE (EL VALOR POR DEFECTO ES 3x3x3)
  String _selectedCube = "3x3x3";

  /// Devuelve el tipo de cubo actualmente seleccionado.
  String get selectedCube => _selectedCube;

  /// Establece el tipo de cubo seleccionado, notifica a los listeners
  /// y guarda la preferencia en [SharedPreferences].
  Future<void> setSelectedCube(String cube) async {
    _selectedCube = cube;
    notifyListeners();

    // GUARDA LAS PREFERENCIAS EN EL SHARED PREFERENCES
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_cube', cube);
  }

  /// Carga el tipo de cubo almacenado en [SharedPreferences].
  /// Si no hay ninguno guardado, usa "3x3x3" como valor por defecto.
  Future<void> loadSelectedCube() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCube = prefs.getString('selected_cube') ?? "3x3x3";
    notifyListeners();
  }
}
