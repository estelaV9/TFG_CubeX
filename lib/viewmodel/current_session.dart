import 'package:flutter/material.dart';

class CurrentSession with ChangeNotifier {
  String _sessionName = "";

  String get sessionName => _sessionName;

  set sessionName(String newSessionName) {
    _sessionName = newSessionName;
    // SE NOTIFICA A TODOS LOS LISTENERS CUANDO EL NOMBRE DE LA SESION CAMBIE
    notifyListeners();
  }
}
