import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:flutter/material.dart';

/// Provider para gestionar el **tipo de cubo actual** en la aplicación.
///
/// Permite establecer, obtener y limpiar el tipo de cubo seleccionado.
/// Notifica a los listeners cada vez que el estado cambia.
class CurrentCubeType extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL TIPO DE CUBO ACTUAL
  CubeType? _cubeType;

  /// Obtiene el tipo de cubo actual.
  CubeType? get cubeType => _cubeType;

  /// Establece el tipo de cubo actual y notifica a los listeners.
  void setCubeType(CubeType cubeType) {
    _cubeType = cubeType;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL TIPO DE CUBO ACTUAL

  @override
  String toString() {
    return 'CurrentCubeType: {name: ${_cubeType?.cubeName}, id: ${_cubeType?.idCube}}';
  } // toString() PARA HACER PRUEBAS
}
