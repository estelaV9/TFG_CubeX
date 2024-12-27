class Validator {
  static String? validatePassword(String? value){
    if (value == null || value.isEmpty) {
      return 'Please fill in this field.';
    } // VALIDAR CAMPOS VACIOS

    if(value.length < 8){
      return "Must be at least 8 characters.";
    } // VALIDAR QUE LA CONTRASEÑA CONTENGA AL MENSO 8 CARACTERES

    if(value.contains(' ')){
      return "Must not contain spaces.";
    } // VALIDAR QUE LA CONTRASEÑA NO CONTENGA ESPACIOS EN BLANCO

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Must add one special character.";
    } // DEBE CONTENER AL MENOS UN CARACTER ESPECIAL

    if(!RegExp(r'[0-9]').hasMatch(value)){
      return "Must add one number.";
    } // DEBE CONTENER AL MENOS UN NUMERO

    return null;
  } // VALIDACION PARA EL CAMPO DE CONTRASEÑA

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
}