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
}