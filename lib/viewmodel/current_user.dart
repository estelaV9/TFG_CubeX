import 'package:flutter/material.dart';
import '../model/user.dart';
/// Provider para gestionar el **usuario actual** en la aplicación.
///
/// Permite establecer y obtener el usuario actual.
/// Notifica a los listeners cuando el estado del usuario cambia.
// CLASE PARA GESTIONAR EL USUARIO ACTUAL EN LA APLICACIÓN
class CurrentUser extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL USUARIO ACTUAL
  UserClass? _user;

  /// Obtiene el usuario actual.
  UserClass? get user => _user;

  /// Establece el usuario actual y notifica a los listeners.
  void setUser(UserClass user) {
    _user = user;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL USUARIO ACTUAL

  @override
  String toString() {
    return 'CurrentUser: {username: ${_user?.username}, email: ${_user?.mail}}';
  } // toString() PARA HACER PRUEBAS
}
