import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa un tipo de cubo de un usuario.
class CubeType {
  /// Identificador único del cubo (puede ser nulo si aún no está asignado).
  int? idCube;

  /// Nombre del tipo de cubo.
  String cubeName;

  /// Identificador del usuario asociado al cubo (opcional).
  ///
  /// Este campo vincula un tipo de cubo específico con un usuario en particular,
  /// asegurando que dicho tipo de cubo sea visible y accesible solo para ese usuario.
  /// De esta manera, se mantiene la privacidad y personalización de los datos del cubo.
  int? idUser;

  /// Constructor para inicializar un tipo de cubo.
  CubeType({this.idCube, required this.cubeName, this.idUser});

  @override
  String toString() {
    return 'CubeType{idCube: $idCube, cubeName: $cubeName, idUser: $idUser}';
  }

  /// Instancia de las preferencias compartidas.
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas con valores por defecto si aún no existen.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setInt("idCube", -1);
      await preferences.setInt("idUser", -1);
      await preferences.setString("cubeName", "");
    }
  }

  /// Guarda los datos del tipo de cubo actual en [SharedPreferences].
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setInt("idCube", idCube!);
    await prefs.setInt("idUser", idUser!);
    await prefs.setString("cubeName", cubeName);
  }

  /// Recupera un objeto `CubeType` desde los datos guardados en `SharedPreferences`.
  static CubeType loadFromPreferences(SharedPreferences prefs) {
    return CubeType(
      idCube: prefs.getInt("idCube") ?? -1,
      idUser: prefs.getInt("idUser") ?? -1,
      cubeName: prefs.getString("cubeName") ?? '',
    );
  }
}