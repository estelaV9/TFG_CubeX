import 'package:flutter/material.dart';
import '../model/session.dart';

/// Provider para gestionar la **sesión actual** del usuario.
///
/// Permite establecer y obtener la sesión actual.
/// Notifica a los listeners cuando la sesión cambia.
class CurrentSession with ChangeNotifier {
  // ALMACENA LA SESION ACTUAL
  Session? _session;

  /// Obtiene la sesión actual.
  Session? get session => _session;

  /// Establece la sesión actual y notifica a los listeners.
  void setSession(Session newSessionName) {
    _session = newSessionName;
    // SE NOTIFICA A TODOS LOS LISTENERS CUANDO EL NOMBRE DE LA SESION CAMBIE
    notifyListeners();
  }
}
