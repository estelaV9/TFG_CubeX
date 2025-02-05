import 'package:flutter/material.dart';
import '../model/session.dart';

class CurrentSession with ChangeNotifier {
  Session? _session;

  Session? get session => _session;

  void setSession(Session newSessionName) {
    _session = newSessionName;
    // SE NOTIFICA A TODOS LOS LISTENERS CUANDO EL NOMBRE DE LA SESION CAMBIE
    notifyListeners();
  }
}
