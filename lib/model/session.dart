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
}
