class User {
  final int? idUser; // SERA AUTOINCREMENTAL
  final String username;
  final String mail;
  final String password;
  final String creationDate;
  final String imageUrl;

  // CONSTRUCTOR
  User({
    this.idUser,
    required this.username,
    required this.mail,
    required this.password,
    String? creationDate, // POR DEFECTO ES LA FECHA DE HOY
    String? imageUrl, // OPCIONAL
  })  : imageUrl = imageUrl ?? 'assets/default_user_image.png',
  // SI LA IMAGEN ES UNA SE LE ASIGNA UNA POR DEFECTO
        creationDate = creationDate ??
            DateTime.now().toString();

  @override
  String toString() {
    return 'User{'
        'idUser: $idUser, '
        'username: $username,'
        'mail: $mail, '
        'password: $password, '
        'creationDate: $creationDate, '
        'imageUrl: $imageUrl}';
  }
} // CLASE USUARIO
