import 'package:flutter/material.dart';

/// Provider para gestionar el **scramble actual**.
///
/// Permite establecer y obtener el scramble actual.
/// Notifica a los listeners cuando el estado cambia.
// CLASE PARA GESTIONAR EL SCRAMBLE ACTUAL
class CurrentScramble extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL SCRAMBLE ACTUAL
  String? _scramble;

  /// Obtiene el scramble actual.
  String? get scramble => _scramble;

  /// Establece el scramble actual y notifica a los listeners.
  void setScramble(String scramble) {
    _scramble = scramble;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL SCRAMBLE ACTUAL

  @override
  String toString() {
    return 'CurrentScramble: {scramble: $_scramble?}';
  } // toString() PARA HACER PRUEBAS
}
