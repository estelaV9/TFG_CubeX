import 'package:esteladevega_tfg_cubex/data/dao/supebase/method_dao_sb.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider encargado de gestionar la seleccion del metodo de resolucion
/// del cubo actualmente elegido.
///
/// Este provider se encarga de:
/// - Obtener los metodos disponibles con su ID desde la base de datos.
/// - Restaurar automaticamente el metodo seleccionado previamente
///   para cada tipo de cubo.
/// - Guardar las preferencias del usuario en `SharedPreferences`.
///
/// Cada cubo guarda su seleccion individual mediante la clave:
/// `selected_method_<cubeName>`
class MethodSelectionProvider with ChangeNotifier {
  final MethodDaoSb _methodDaoSb = MethodDaoSb();

  // LISTA DE METODOS DISPONIBLES PARA EL CUBO SELECCIONADO
  final List<String> _methods = [];

  // METODO ACTUALMENTE SELECCIONADO
  String _selectedMethod = "";

  // INDICA SI SE ESTAN CARGANDO LOS METODOS
  bool _isLoading = false;

  // ID DEL METODO ACTUAL
  int _idMethod = -1;

  /// Devuelve la lista de métodos disponibles
  List<String> get methods => _methods;

  /// Devuelve el método actualmente seleccionado
  String get selectedMethod => _selectedMethod;

  /// Devuelve si estan o no cargando los metodos
  bool get isLoading => _isLoading;

  /// Devuelve el ID del metodo seleccionado
  int get idMethod => _idMethod;

  /// Carga los metodos correspondientes al cubo especificado en [cubeName].
  ///
  /// Características:
  /// - Recupera los metodos desde la base de datos.
  /// - Internacionaliza los nombres.
  /// - Comprueba si existia una seleccion previa guardada.
  /// - Asigna el metodo guardado o, si no existe, el primero de la lista.
  Future<void> loadMethods(String cubeName, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final savedMethod = prefs.getString("selected_method_$cubeName");

    // OBTENER LOS METODOS DESDE LA BASE DE DATOS
    final loadedMethods = await _methodDaoSb.getMethods(cubeName);

    // LIMPIAR LA LISTA ACTUAL
    _methods.clear();

    for (final method in loadedMethods) {
      _methods.add(method.methodName);
    } // GUARDAR LOS METODOS

    if (savedMethod != null && _methods.contains(savedMethod)) {
      _selectedMethod = savedMethod;
    } else {
      // SI NO HAY NADA GUARDADO, SELECCIONAMOS EL PRIMERO
      _selectedMethod = _methods.isNotEmpty ? _methods.first : "";
    } // RESTAURAR LA SELECCION PREVIA SI ES VALIDA

    _isLoading = false;
    notifyListeners();
  }

  /// Establece el metodo seleccionado, notifica a los listeners
  /// y guarda la preferencia en [SharedPreferences].
  Future<void> setSelectedMethod(String method, String cubeName) async {
    _selectedMethod = method;
    notifyListeners();

    // GUARDA LAS PREFERENCIAS EN EL SHARED PREFERENCES
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_method_$cubeName', method);
  }

  /// Obtiene y guarda el **ID del método** según su nombre y el cubo seleccionado.
  ///
  /// Parámetros:
  /// - [methodName]: Nombre del método seleccionado.
  /// - [cubeName]: Nombre del cubo seleccionado.
  ///
  /// Si el ID es válido, lo asigna al provider, notifica a los listeners y lo
  /// almacena en [SharedPreferences].
  /// Si no es válido, registra un error.
  Future<void> setIdMethod(String methodName, String cubeName) async {
    int id = await _methodDaoSb.getIdByNameAndCube(methodName, cubeName);

    if (id != -1) {
      _idMethod = id;
      notifyListeners();

      // GUARDA LAS PREFERENCIAS EN EL SHARED PREFERENCES
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('idMethod', _idMethod);
    } else {
      DatabaseHelper.logger.e("Ocurrio un error con el id del metodo: "
          "$_idMethod  |  $id  |  $methodName  |  $cubeName");
    }
  }
}