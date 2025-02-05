class TimeTraining {
  final int? idTimeTraining;
  final int? idSession;
  final String scramble;
  final double timeInSeconds;
  final String? comments; // POR DEFECTO SERA NULO
  final String? penalty; // POR DEFECTO SERA "none"
  final String registrationDate;

  // CONSTRUCTOR
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
