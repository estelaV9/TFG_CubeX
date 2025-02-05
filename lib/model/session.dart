class Session {
  int? idSession;
  int idUser;
  String sessionName;
  String creationDate;
  int idCubeType;

  Session({
    this.idSession,
    required this.idUser,
    required this.sessionName,
    String? creationDate,
    required this.idCubeType,
  }) : creationDate = creationDate ?? DateTime.now().toString();

  // CONSTRUCTOR VACIO
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
