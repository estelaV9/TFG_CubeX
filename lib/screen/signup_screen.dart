import 'package:esteladevega_tfg_cubex/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/main.dart';
import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:esteladevega_tfg_cubex/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/encrypt_password.dart';
import 'package:esteladevega_tfg_cubex/utilities/validator.dart';
import 'package:flutter/material.dart';

import '../components/password_field_row.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserDao userDao = UserDao();
  String _password = ''; // ATRIBUTO PARA GUARDAR LA CONTRASEÑA

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final mail = _mailController.text;
      String encryptedPassword = EncryptPassword.encryptPassword(_password);
      DatabaseHelper.logger.i('Encrypted password: $encryptedPassword');

      // SE CREA UN USUARIO
      User user =
          User(username: username, mail: mail, password: encryptedPassword);

      if (!await userDao.isExistsUsername(username)) {
        if(!await userDao.isExistsEmail(mail)) {
          if (await userDao.insertUser(user)) {
            // SE MUESTRA UN SNACKBAR DE QUE SE HA CREADO CORRECTAMENTE Y SE REDIRIGE A LA PANTALLA PRINCIPAL

            AlertUtil.showSnackBarInformation(
                context, "Account created\nsuccessfully.");
            ChangeScreen.changeScreen(IntroScreen(), context);
          } else {
            // SE MUESTRA UN SNACKBARR MOSTRANDO QUE HA OCURRIDO UN ERRO AL CREAR USUARIO
            AlertUtil.showSnackBarError(
                context, "An error occurred while\ncreating the account.");
          } // INSERTAR AL USUARIO
        } else {
          // SE MUESTRA UN SNACKBARR MOSTRANDO QUE EL MAIL DEL USUARIO YA EXISTE
          AlertUtil.showSnackBarError(
              context, "An account with this email\nalready exists.");
        } // VALIDAR QUE EL MAIL DEL USUARIO NO EXISTA
      } else {
        // SE MUESTRA UN SNACKBARR MOSTRANDO QUE EL NOMBRE DEL USUARIO YA EXISTE
        AlertUtil.showSnackBarError(
            context, "This username is already in use.");
      } // VALIDAR QUE EL NOMBRE DE USUARIO NO EXISTA
    } // SI TODOS LOS CAMPOS DEL FORMULARIO ESTAN CORRECTOS
  } // METODO PARA CREAR UNA CUENTA

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background_intro.jpeg"),
                fit: BoxFit.cover, // AJUSTAR LA IMAGEN AL TAMAÑO DE LA PANTALLA
              ),
            ),
          ),
          Positioned.fill(
              top: 150,
              // SE DEJA UN HUECO DONDE SE VE UN POCO LA PARTE DE ARRIBA
              child: Container(
                decoration: const BoxDecoration(
                  // COLOR DEGRADADO PARA EL FONDO
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, // DESDE ARRIBA
                    end: Alignment.bottomCenter, // HASTA ABAJO
                    colors: [
                      AppColors.upLinearColor, // COLOR DE ARRIBA DEL DEGRADADO
                      AppColors.downLinearColor, // COLOR DE ABAJO DEL DEGRADADO
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontFamily: 'Gluten',
                            fontSize: 70,
                            color: AppColors.lightPurpleColor),
                      ),
                      const SizedBox(height: 10),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            FieldForm(
                              icon: const Icon(Icons.person),
                              labelText: 'Username',
                              hintText: 'Write your username',
                              controller: _usernameController,
                              validator: (value) =>
                                  Validator.validateUsername(value),
                            ),

                            // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                            const SizedBox(height: 10),

                            FieldForm(
                              icon: const Icon(Icons.mail),
                              labelText: 'Mail',
                              hintText: 'Write your mail',
                              controller: _mailController,
                              validator: (value) =>
                                  Validator.validateEmail(value),
                            ),

                            // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                            const SizedBox(height: 10),

                            PasswordFieldForm(
                              icon: const Icon(Icons.lock),
                              labelText: 'Password',
                              hintText: 'Write your password',
                              controller: _passwordController,
                              validator: (value) =>
                                  Validator.validatePassword(value),
                              passwordOnSaved: (value) => _password = value!,
                            ),

                            // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                            const SizedBox(height: 10),

                            PasswordFieldForm(
                              icon: const Icon(Icons.check),
                              labelText: 'Confirm password',
                              hintText: 'Confirm password',
                              controller: _confirmPasswordController,
                              validator: (value) =>
                                  Validator.validateConfirmPassword(
                                      value, _passwordController.text),
                              passwordOnSaved: (value) => _password = value!,
                            ),
                          ])),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                                color: AppColors.darkPurpleColor),
                          ),
                          const SizedBox(width: 14),
                          ElevatedButton(
                              onPressed: () {
                                _signUp();
                              },
                              style: ElevatedButton.styleFrom(
                                // LE QUITAMOS EL PADDING DE DENTRO DEL BTON
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(Icons.arrow_forward)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                                color: AppColors.darkPurpleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // CAMBIAR A LA PANTALLA LOGIN
                                ChangeScreen.changeScreen(
                                    const LoginScreen(), context);
                              },
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.darkPurpleColor,
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
