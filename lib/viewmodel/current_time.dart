import 'package:esteladevega_tfg_cubex/model/time_training.dart';
import 'package:flutter/material.dart';

/// Provider para gestionar el **tiempo de resolución actual** en la aplicación.
///
/// Permite establecer, obtener y limpiar el tiempo realizado.
/// Notifica a los listeners cada vez que el estado cambia.
class CurrentTime extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL TIEMPO ACTUAL
  TimeTraining? _timeTraining;

  /// Obtiene el tiempo de resolución actual.
  TimeTraining? get timeTraining => _timeTraining;

  /// Establece el tiempo actual y notifica a los listeners.
  void setTimeTraining(TimeTraining timeTraining) {
    _timeTraining = timeTraining;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL TIEMPO ACTUAL

  /// Establece el tiempo actual null y notifica a los listeners.
  void setTimeTrainingNull() {
    _timeTraining = null;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL TIEMPO ACTUAL EN NULO

  @override
  String toString() {
    return 'CurrentTime{_timeTraining: $_timeTraining}';
  } // toString() PARA HACER PRUEBAS
}
