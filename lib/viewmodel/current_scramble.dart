import 'package:esteladevega_tfg_cubex/utilities/ScrambleGenerator.dart';
import 'package:flutter/material.dart';

// CLASE PARA GESTIONAR EL SCRAMBLE ACTUAL
class CurrentScramble extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL SCRAMBLE ACTUAL
  String? _scramble;

  // GETTER PARA OBTENER EL SCRAMBLE ACTUAL
  String? get scramble => _scramble;

  void setScramble(String scramble) {
    _scramble = scramble;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL SCRAMBLE ACTUAL

  void clearScramble() {
    _scramble = null; // SE ESTABLECE EN NULO
    notifyListeners();
  } // METODO PARA LIMPIAR EL SCRAMBLE

  @override
  String toString() {
    return 'CurrentScramble: {scramble: $_scramble?}';
  } // toString() PARA HACER PRUEBAS
}
