import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Clase que se utiliza para la **encriptación de contraseñas** en la aplicación.
///
/// Esta clase proporciona un método estático para encriptar contraseñas
/// utilizando el algoritmo de hash SHA-256, permitiendo  mantener la seguridad
/// de las credenciales de los usuarios sin necesidad de repetir el código en
/// diferentes partes de la app.
class EncryptPassword {
  /// Encripta una contraseña utilizando el algoritmo SHA-256.
  ///
  /// Este método toma una cadena de texto [password], la convierte en bytes
  /// utilizando UTF-8 y luego aplica la función hash SHA-256 para obtener
  /// una representación segura de la contraseña.
  ///
  /// - [password]: La contraseña que se desea encriptar.
  ///
  /// Retorna un `String` que representa la contraseña encriptada en formato hexadecimal.
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
