class CubeType {
  int? idCube;
  String cubeName;
  int? idUser;

  CubeType({this.idCube, required this.cubeName, this.idUser});

  @override
  String toString() {
    return 'CubeType{idCube: $idCube, cubeName: $cubeName, idUser: $idUser}';
  }
}