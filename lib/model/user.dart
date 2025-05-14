import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa a un usuario en la aplicación.
///
/// Esta clase almacena toda la información relevante del usuario como su
/// nombre, correo, contraseña, imagen de perfil y estado de sesión (si se ha logeado
/// o creado una cuenta).
/// Además, permite guardar y recuperar esta información mediante `SharedPreferences`.
class UserClass {
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

  /// Indica si el usuario ha iniciado sesión.
  bool isLoggedIn = false;

  /// Indica si el usuario se ha registrado en la app.
  bool? isSingup = false;

  String? userUUID;

  /// Constructor principal del usuario.
  ///
  /// Si no se proporciona:
  /// - la fecha de creación, se usará la fecha actual.
  /// - la imagen, se usará una imagen de perfil por defecto.
  /// - el si esta logeado o se ha creado una cuenta, se negará el valor.
  UserClass(
      {this.idUser,
      required this.username,
      required this.mail,
      required this.password,
      String? creationDate, // POR DEFECTO ES LA FECHA DE HOY
      String? imageUrl, // OPCIONAL
      bool? isLoggedIn,
      bool? isSingup,
      this.userUUID})
      : // SI LA IMAGEN ES UNA SE LE ASIGNA UNA POR DEFECTO
        imageUrl = imageUrl ?? 'https://oaryfjaytowsszzckskk.supabase.co/storage/v1/object/public/avatars/users/default_user_image.png',
        creationDate = creationDate ?? DateTime.now().toString(),
        isLoggedIn = isLoggedIn ?? false,
        isSingup = isSingup ?? false;

  @override
  String toString() {
    return 'User{'
        'idUser: $idUser, '
        'username: $username,'
        'mail: $mail, '
        'password: $password, '
        'creationDate: $creationDate, '
        'imageUrl: $imageUrl, '
        'isSingup: $isSingup, '
        'isLoggedIn: $isLoggedIn, '
        'userUUID: $userUUID}';
  }

  /// Instancia de las preferencias compartidas.
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas con valores por defecto si aún no existen.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setBool("isLoggedIn", false);
      await preferences.setBool("isSingup", false);
      await preferences.setString("username", "");
      await preferences.setString("mail", "");
      await preferences.setString("password", "");
      await preferences.setString("creationDate", "");
      await preferences.setString("imageUrl", "");
      await preferences.setString("userUUID", "");
    }
  }

  /// Guarda los datos del usuario actual en [SharedPreferences].
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setBool("isLoggedIn", isLoggedIn);
    await prefs.setBool("isSingup", isSingup!);
    await prefs.setString("username", username);
    await prefs.setString("mail", mail);
    await prefs.setString("password", password);
    await prefs.setString("creationDate", creationDate);
    await prefs.setString("imageUrl", imageUrl);
    await prefs.setString("userUUID", userUUID!);
  }

  /// Recupera un objeto `User` desde los datos guardados en `SharedPreferences`.
  static UserClass loadFromPreferences(SharedPreferences prefs) {
    return UserClass(
      username: prefs.getString("username") ?? "",
      mail: prefs.getString("mail") ?? "",
      password: prefs.getString("password") ?? "",
      userUUID: prefs.getString("userUUID") ?? "",
      creationDate: prefs.getString("creationDate"),
      imageUrl: prefs.getString("imageUrl"),
      isLoggedIn: prefs.getBool("isLoggedIn") ?? false,
      isSingup: prefs.getBool("isSingup") ?? false,
    );
  }
} // CLASE USUARIO
