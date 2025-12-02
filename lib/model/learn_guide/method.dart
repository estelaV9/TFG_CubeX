import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa un metodo de un tipo de cubo.
/// Contiene información básica como el nombre y el nombre del cubo asociado.
class Method {
  /// Identificador único del metodo
  int? idMethod;

  /// Nombre del metodo.
  String methodName;

  /// Nombre del tipo de cubo del metodo.
  String cubeTypeName;

  /// Constructor para inicializar un metodo.
  Method({this.idMethod, required this.methodName, required this.cubeTypeName});

  @override
  String toString() {
    return 'Method{idMethod: $idMethod, methodName: $methodName, cubeTypeName: $cubeTypeName}';
  }

  /// Instancia de las preferencias.
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas con valores por defecto si aún no existen.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setInt("idMethod", -1);
      await preferences.setString("methodName", "");
      await preferences.setString("cubeTypeName", "");
    }
  }

  /// Guarda los datos del metodo actual en [SharedPreferences].
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setInt("idMethod", idMethod!);
    await prefs.setString("methodName", methodName);
    await prefs.setString("cubeTypeName", cubeTypeName);
  }

  /// Recupera un objeto `Method` desde los datos guardados en `SharedPreferences`.
  static Method loadFromPreferences(SharedPreferences prefs) {
    return Method(
      idMethod: prefs.getInt("idMethod") ?? -1,
      methodName: prefs.getString("methodName") ?? "",
      cubeTypeName: prefs.getString("cubeTypeName") ?? "",
    );
  }
}