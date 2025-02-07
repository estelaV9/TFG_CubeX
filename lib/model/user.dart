/// Clase que representa a un usuario en la aplicación.
class User {
  /// Identificador único del usuario (opcional).
  final int? idUser;

  /// Nombre de usuario.
  final String username;

  /// Correo electrónico del usuario.
  final String mail;

  /// Contraseña del usuario.
  final String password;

  /// Fecha de creación del usuario.
  final String creationDate;

  /// URL de la imagen de perfil del usuario.
  final String imageUrl;

  /// Constructor para inicializar un usuario.
  ///
  /// Si no se especifica los campos de la fecha o de la imagen,
  /// se estableceran los valores de la fecha actual y de la imagen
  /// predeterminada.
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
