/// Clase que se utiliza para la **validación de campos** en formularios.
///
/// Proporciona métodos estáticos para validar:
/// - Contraseñas.
/// - Confirmación de contraseñas.
/// - Nombres de usuario.
/// - Correos electrónicos.
/// - Combinación de nombres de usuarios y correos.
/// Su objetivo es evitar la repetición del código de validación en diferentes pantallas de la aplicación.
class Validator {
  /// Validar el campo de contraseña.
  ///
  /// - [value]: La contraseña ingresada por el usuario.
  ///
  /// Retorna un mensaje de error si la contraseña no cumple con:
  /// - No estar vacía.
  /// - Tener al menos 8 caracteres.
  /// - No contener espacios en blanco.
  /// - Incluir al menos un carácter especial.
  /// - Incluir al menos un número.
  ///
  /// Retorna `null` si la validación es exitosa.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill in this field.';
    } // VALIDAR CAMPOS VACIOS

    if (value.length < 8) {
      return "Must be at least 8 characters.";
    } // VALIDAR QUE LA CONTRASEÑA CONTENGA AL MENSO 8 CARACTERES

    if (value.contains(' ')) {
      return "Must not contain spaces.";
    } // VALIDAR QUE LA CONTRASEÑA NO CONTENGA ESPACIOS EN BLANCO

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Must add one special character.";
    } // DEBE CONTENER AL MENOS UN CARACTER ESPECIAL

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must add one number.";
    } // DEBE CONTENER AL MENOS UN NUMERO

    return null;
  } // VALIDACION PARA EL CAMPO DE CONTRASEÑA

  /// Validar la confirmación de la contraseña.
  ///
  /// - [value]: La contraseña de confirmación ingresada.
  /// - [password]: La contraseña original con la que se debe comparar.
  ///
  /// Realiza las mismas validaciones que `validatePassword` y, adicionalmente,
  /// verifica que ambas contraseñas coincidan.
  ///
  /// Retorna un mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please fill in this field.';
    } // VALIDAR CAMPOS VACIOS

    if (value.length < 8) {
      return "Must be at least 8 characters.";
    } // VALIDAR QUE LA CONTRASEÑA CONTENGA AL MENSO 8 CARACTERES

    if (value.contains(' ')) {
      return "Must not contain spaces.";
    } // VALIDAR QUE LA CONTRASEÑA NO CONTENGA ESPACIOS EN BLANCO

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Must add one special character.";
    } // DEBE CONTENER AL MENOS UN CARACTER ESPECIAL

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must add one number.";
    } // DEBE CONTENER AL MENOS UN NUMERO

    if (value != password) {
      return "Passwords do not match.";
    } // VALIDA QUE LAS CONTRASEÑAS COINCIDAN

    return null;
  } // VALIDACION PARA CONFIRMAR EL CAMPO DE CONTRASEÑA

  /// Validar un campo que puede ser un nombre de usuario o un correo electrónico.
  ///
  /// - [value]: El valor ingresado por el usuario.
  ///
  /// Si contiene un '@', se valida como correo electrónico.
  /// Si no, se verifica que el nombre de usuario no exceda los 12 caracteres.
  ///
  /// Retorna un mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateUsernameOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill in this field.';
    } // VALIDAR CAMPOS VACIOS

    if (value.contains("@") &&
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
            .hasMatch(value)) {
      return 'Please enter a valid email';
    } // VALIDAR EL CAMPO DEL EMAIL

    if (value.length > 12 && !value.contains("@")) {
      return "Name mustn't exceed 12 characters.";
    } // SE VALIDA EL NOMBRE, CUADNO NO CONTENGA UN '@' SE VALIDARA QUE NO SEA MAYOR DE 12 CARACTERES

    return null;
  } // VALIDACION PARA EL CAMPO DEL NOMBRE E EMAIL DEL USUARIO

  /// Validar un correo electrónico.
  ///
  /// - [value]: El correo electrónico ingresado por el usuario.
  ///
  /// Verifica que el campo no esté vacío y que el formato sea válido.
  ///
  /// Retorna un mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill in this field.';
    } // VALIDAR CAMPOS VACIOS

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    } // VALIDAR EL CAMPO DEL EMAIL

    return null;
  } // VALIDACION PARA EL CAMPO DEL EMAIL DEL USUARIO

  /// Validar un nombre de usuario.
  ///
  /// - [value]: El nombre de usuario ingresado por el usuario.
  ///
  /// Verifica que el campo no esté vacío y que no exceda los 12 caracteres.
  ///
  /// Retorna un mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill in this field.';
    } // VALIDAR CAMPOS VACIOS

    if (value.length > 12) {
      return "Name mustn't exceed 12 characters.";
    } // SE VALIDA QUE LOS CARACTERES QUE COMPONEN EL NOMRBE DEL USUARIO NO
    // SEA MAYOR DE 12 CARACTERES

    return null;
  } // VALIDACION PARA EL CAMPO DEL NOMBRE DEL USUARIO
}