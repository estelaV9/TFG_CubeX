import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa un metodo de un tipo de cubo.
/// Contiene información básica como el nombre y el cubo asociado.
class Method {
  /// Identificador único del metodo
  int? idMethod;

  /// Nombre del metodo.
  String methodName;

  /// Identificador del tipo de cubo asociado al metodo (opcional).
  int? idCubeType;

  /// Constructor para inicializar un metodo.
  Method({this.idMethod, required this.methodName, this.idCubeType});

  @override
  String toString() {
    return 'Method{idMethod: $idMethod, methodName: $methodName, idCubeType: $idCubeType}';
  }

  /// Instancia de las preferencias.
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas con valores por defecto si aún no existen.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setInt("idMethod", -1);
      await preferences.setString("methodName", "");
      await preferences.setInt("idCubeType", -1);
    }
  }

  /// Guarda los datos del metodo actual en [SharedPreferences].
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setInt("idMethod", idMethod!);
    await prefs.setString("methodName", methodName);
    await prefs.setInt("idCubeType", idCubeType!);
  }

  /// Recupera un objeto `Method` desde los datos guardados en `SharedPreferences`.
  static Method loadFromPreferences(SharedPreferences prefs) {
    return Method(
      idMethod: prefs.getInt("idMethod") ?? -1,
      methodName: prefs.getString("methodName") ?? "",
      idCubeType: prefs.getInt("idCubeType") ?? -1,
    );
  }
}