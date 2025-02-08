/// Clase que representa un tiempo en una sesión.
class TimeTraining {
  /// Identificador único del tiempo (opcional).
  final int? idTimeTraining;

  /// Identificador de la sesión asociada.
  final int? idSession;

  /// Scramble utilizado para la resolución del tiempo.
  final String scramble;

  /// Tiempo registrado en segundos.
  final double timeInSeconds;

  /// Comentarios adicionales sobre el tiempo registrado (opcional).
  final String? comments;

  /// Penalización asociada al tiempo (por defecto "none").
  ///
  /// La penalización podrá ser:
  /// - None.
  /// - DNF (Did Not Finish).
  /// - +2.
  final String? penalty;

  /// Fecha de registro del tiempo.
  final String registrationDate;

  /// Constructor para inicializar un tiempo de entrenamiento.
  TimeTraining(
      {this.idTimeTraining,
      required this.idSession,
      required this.scramble,
      required this.timeInSeconds,
      this.comments,
      String? penalty,
      String? registrationDate})
      : registrationDate = registrationDate ?? DateTime.now().toString(),
        penalty = penalty ?? "none";

  @override
  String toString() {
    return 'TimeTraining{'
        'idTimeTraining: $idTimeTraining, '
        'idSession: $idSession, '
        'scramble: $scramble, '
        'timeInSeconds: $timeInSeconds, '
        'comments: $comments, '
        'penalty: $penalty, '
        'registrationDate: $registrationDate'
        '}';
  } // METODO TOSTRING
} // CLASE PARA LOS TIEMPOS DE UNA SESION
