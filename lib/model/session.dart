import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa una sesión para guardar los tiempos de un tipo de cubo.
class Session {
  /// Identificador único de la sesión (opcional).
  int? idSession;

  /// Identificador del usuario al que le pertenece la sesión.
  int idUser;

  /// Nombre de la sesión.
  String sessionName;

  /// Fecha de creación de la sesión
  String creationDate;

  /// Identificador del tipo de cubo asociado a la sesión.
  ///
  /// Una sesión esta relacionada con un tipo de cubo, asegurando que el
  /// usuario pueda entrenar una categoría y guardar sus tiempos en una sesión
  /// de la categoría elegida
  int idCubeType;

  /// Constructor para inicializar una sesión.
  ///
  /// Si no se introduce el campo de la fecha creación, se le asignará
  /// la fecha actual.
  Session({
    this.idSession,
    required this.idUser,
    required this.sessionName,
    String? creationDate,
    required this.idCubeType,
  }) : creationDate = creationDate ?? DateTime.now().toString();

  /// Constructor vacío para crear una sesión sin datos iniciales.
  Session.empty()
      : idSession = null,
        idUser = 0,
        sessionName = '',
        creationDate = DateTime.now().toString(),
        idCubeType = 0;

  @override
  String toString() {
    return 'Session{'
        'idSession: $idSession, '
        'idUser: $idUser, '
        'sessionName: $sessionName, '
        'creationDate: $creationDate, '
        'idCubeType: $idCubeType}';
  }

  /// Instancia de las preferencias compartidas.
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas con valores por defecto si aún no existen.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setInt("idSession", -1);
      await preferences.setInt("idUser", -1);
      await preferences.setString("sessionName", "");
      await preferences.setString("creationDate", "");
      await preferences.setInt("idCubeType", -1);
    }
  }

  /// Guarda los datos de la sesión actual en [SharedPreferences].
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setInt("idSession", idSession ?? -1);
    await prefs.setInt("idUser", idUser);
    await prefs.setString("sessionName", sessionName);
    await prefs.setString("creationDate", creationDate);
    await prefs.setInt("idCubeType", idCubeType);
  }

  /// Recupera un objeto `Session` desde los datos guardados en `SharedPreferences`.
  static Session loadFromPreferences(SharedPreferences prefs) {
    return Session(
      idSession: prefs.getInt("idSession") ?? -1,
      idUser: prefs.getInt("idUser") ?? -1,
      sessionName: prefs.getString("sessionName") ?? '',
      creationDate: prefs.getString("creationDate"),
      idCubeType: prefs.getInt("idCubeType") ?? -1,
    );
  }
}
