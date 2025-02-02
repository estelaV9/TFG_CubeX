import 'package:flutter/material.dart';
import '../model/user.dart';

// CLASE PARA GESTIONAR EL USUARIO ACTUAL EN LA APLICACIÓN
class CurrentUser extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL USUARIO ACTUAL
  User? _user;

  // GETTER PARA OBTENER EL USUARIO ACTUAL
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL USUARIO ACTUAL

  void clearUser() {
    _user = null;
    notifyListeners();
  } // MÉTODO PARA CERRAR SESSION Y LIMPIAR EL USUARIO

  @override
  String toString() {
    return 'CurrentUser: {username: ${_user?.username}, email: ${_user?.mail}}';
  } // toString() PARA HACER PRUEBAS
}
