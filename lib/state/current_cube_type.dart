import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:flutter/material.dart';

// CLASE PARA GESTIONAR EL TIPO DE CUBO ACTUAL EN LA APLICACION
class CurrentCubeType extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL TIPO DE CUBO ACTUAL
  CubeType? _cubeType;

  // GETTER PARA OBTENER EL TIPO DE CUBO ACTUAL
  CubeType? get cubeType => _cubeType;

  void setCubeType(CubeType cubeType) {
    _cubeType = cubeType;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL TIPO DE CUBO ACTUAL

  void clearCubeType() {
    _cubeType = null;
    notifyListeners();
  } // MÉTODO PARA CERRAR SESSION Y LIMPIAR EL TIPO DE CUBO

  @override
  String toString() {
    return 'CurrentCubeType: {name: ${_cubeType?.cubeName}, id: ${_cubeType?.idCube}}';
  } // toString() PARA HACER PRUEBAS
}
