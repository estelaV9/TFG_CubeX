import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/cupertino.dart';

import '../../model/user.dart';
import 'encrypt_password.dart';

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
  /// Valida el campo de contraseña.
  ///
  /// Este método se utiliza en varias partes de la aplicación para evitar duplicación de código.
  /// Admite varios parámetros opcionales para adaptar la validación según el contexto.
  ///
  /// ### Parámetros:
  /// - [value]: La contraseña ingresada por el usuario.
  /// - [oldPass] (opcional, `false` por defecto): Indica si la validación es para la
  /// verificación de la contraseña anterior en un diálogo.
  /// - [profilePass] (opcional, `false` por defecto): Indica si la validación es
  /// para el formulario del perfil (permite contraseña vacía).
  /// - [currentUser]: Objeto `User` que representa al usuario actual, usado para
  /// comparar la contraseña anterior en caso de ser necesario.
  /// - [context]: Contexto necesario para la internacionalización del mensaje de
  /// error cuando la contraseña antigua no coincide.
  ///
  /// ### Reglas de validación:
  /// Retorna un mensaje de error si la contraseña no cumple con:
  /// - No estar vacía (excepto en el formulario de perfil).
  /// - Tener un valor, no estar vacía (por la contraseña del profile).
  /// - Tener al menos 8 caracteres.
  /// - No contener espacios en blanco.
  /// - Incluir al menos un carácter especial.
  /// - Incluir al menos un número.
  /// - Si es el dialogo de la antigua contraseña, tiene que coincidir el valor
  /// proporcionado con la contraseña guardada, si no, mostrará un mensaje de error.
  ///
  /// Retorna la key o `null` si la contraseña es válida.
  static String? validatePassword(String? value,
      [bool oldPass = false,
      bool profilePass = false,
      UserClass? currentUser,
      BuildContext? context]) {
    if (!profilePass && (value == null || value.isEmpty)) {
      return "form_error_required_field";
    } // VALIDAR CAMPOS VACIOS (EXCEPTO SI ES DEL PROFILE)

    if (value!.isNotEmpty) {
      if (value.length < 8) {
        return "form_error_minimum_8_characters";
      } // VALIDAR QUE LA CONTRASEÑA CONTENGA AL MENSO 8 CARACTERES

      if (value.contains(' ')) {
        return "form_error_no_spaces_allowed";
      } // VALIDAR QUE LA CONTRASEÑA NO CONTENGA ESPACIOS EN BLANCO

      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return "form_error_special_character_required";
      } // DEBE CONTENER AL MENOS UN CARACTER ESPECIAL

      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return "form_error_number_required";
      } // DEBE CONTENER AL MENOS UN NUMERO
    } // VALIDAR SI HAY UN VALOR (por la contraseña del profile)

    if (oldPass) {
      if (EncryptPassword.encryptPassword(value) != currentUser!.password) {
        return Internationalization.internationalization
            .getLocalizations(context!, "old_pass_error");
      } // SI LA CONTRASEÑA NO COINCIDE, DEVUELVE MENSAJE DE ERROR
    } // CONTRASEÑA ANTIGUA
    return null;
  } // VALIDACION PARA EL CAMPO DE CONTRASEÑA

  /// Validar la confirmación de la contraseña.
  ///
  /// - [value]: La contraseña de confirmación ingresada.
  /// - [password]: La contraseña original con la que se debe comparar.
  /// - [isProfile] (`false` por defecto): Indica si la validación
  ///   es para el formulario del perfil. Si es `true`, el campo puede ser nulo.
  ///
  /// Realiza las mismas validaciones que `validatePassword` y, adicionalmente,
  /// verifica que ambas contraseñas coincidan.
  /// Si es para uso del Profile, puede ser nula.
  ///
  /// Retorna la key del mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateConfirmPassword(String? value, String? password,
      [bool isProfile = false]) {
    if (!isProfile && (value == null || value.isEmpty)) {
      // SI NO ESTAMOS EN LA PANTALLA DE PERFIL Y EL CAMPO ESTA VACIO, MOSTRAMOS UN MENSAJE
      return 'form_error_required_field';
    } else {
      // SI ESTAMOS EN LA PANTALLA DE PERFIL ENTONCES:
      // - SI EL VALUE ES NULO PERO PASSWORD NO LO ES
      // - O SI VALUE ESTA VACIO PERO PASSWORD NO LO ESTA
      // ENTONCES MOSTRAMOS MENSAJE DE VALIDACION
      if ((value == null && password != null) ||
          (value!.isEmpty && password!.isNotEmpty)) {
        return 'form_error_required_field';
      }
    } // VALIDAR CAMPOS VACIOS SI NO ES DEL PROFILE

    if (value!.isNotEmpty) {
      if (value!.length < 8) {
        return "form_error_minimum_8_characters";
      } // VALIDAR QUE LA CONTRASEÑA CONTENGA AL MENSO 8 CARACTERES

      if (value.contains(' ')) {
        return "form_error_no_spaces_allowed";
      } // VALIDAR QUE LA CONTRASEÑA NO CONTENGA ESPACIOS EN BLANCO

      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return "form_error_special_character_required";
      } // DEBE CONTENER AL MENOS UN CARACTER ESPECIAL

      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return "form_error_number_required";
      } // DEBE CONTENER AL MENOS UN NUMERO

      if (value != password) {
        return "form_error_passwords_do_not_match";
      } // VALIDA QUE LAS CONTRASEÑAS COINCIDAN
    } // VALIDAR SI HAY UN VALOR (por el confirmar contraseña del profile)
    return null;
  } // VALIDACION PARA CONFIRMAR EL CAMPO DE CONTRASEÑA

  /// Validar un campo que puede ser un nombre de usuario o un correo electrónico.
  ///
  /// - [value]: El valor ingresado por el usuario.
  ///
  /// Si contiene un '@', se valida como correo electrónico.
  /// Si no, se verifica que el nombre de usuario no exceda los 12 caracteres.
  ///
  /// Retorna la key del un mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateUsernameOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'form_error_required_field';
    } // VALIDAR CAMPOS VACIOS

    if (value.contains("@") &&
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
            .hasMatch(value)) {
      return 'form_error_invalid_email';
    } // VALIDAR EL CAMPO DEL EMAIL

    if (value.length > 12 && !value.contains("@")) {
      return "form_error_name_max_length";
    } // SE VALIDA EL NOMBRE, CUADNO NO CONTENGA UN '@' SE VALIDARA QUE NO SEA MAYOR DE 12 CARACTERES

    return null;
  } // VALIDACION PARA EL CAMPO DEL NOMBRE E EMAIL DEL USUARIO

  /// Validar un correo electrónico.
  ///
  /// - [value]: El correo electrónico ingresado por el usuario.
  ///
  /// Verifica que el campo no esté vacío y que el formato sea válido.
  ///
  /// Retorna la key del mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'form_error_required_field';
    } // VALIDAR CAMPOS VACIOS

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(value)) {
      return 'form_error_invalid_email';
    } // VALIDAR EL CAMPO DEL EMAIL

    return null;
  } // VALIDACION PARA EL CAMPO DEL EMAIL DEL USUARIO

  /// Validar un nombre de usuario.
  ///
  /// - [value]: El nombre de usuario ingresado por el usuario.
  /// - [isProfile] (opcional, `false` por defecto): Indica si la validación
  ///   es para el formulario del perfil. Si es `true`, el campo puede ser nulo.
  ///
  /// ### Reglas de validación:
  /// - No estar vacío (excepto en el formulario de perfil).
  /// - No exceder los 12 caracteres.
  ///
  /// Retorna la key del mensaje de error si la validación falla o `null` si es exitosa.
  static String? validateUsername(String? value, [bool isProfile = false]) {
    if (!isProfile && (value == null || value.isEmpty)) {
      return 'form_error_required_field';
    } // VALIDAR CAMPOS VACIOS SI NO ES DEL CAMPO DEL PROFILE

    if (value!.length > 12) {
      return "form_error_name_max_length";
    } // SE VALIDA QUE LOS CARACTERES QUE COMPONEN EL NOMRBE DEL USUARIO NO
    // SEA MAYOR DE 12 CARACTERES

    return null;
  } // VALIDACION PARA EL CAMPO DEL NOMBRE DEL USUARIO
}