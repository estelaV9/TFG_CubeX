import 'package:esteladevega_tfg_cubex/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/screen/timer_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/screen/signup_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/encrypt_password.dart';
import 'package:esteladevega_tfg_cubex/utilities/validator.dart';
import 'package:flutter/material.dart';

import '../components/password_field_row.dart';
import '../navigation/bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserDao userDao = UserDao();
  final _formKey = GlobalKey<FormState>();

  // CONTROLADORES
  /// nota: se crean y se pasan como parametro los controladores en esta vista
  /// para manejar mejor el acceso al texto del formulario
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _password = '';

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final usernameOrEmail = _usernameController.text;
      final password = _passwordController.text;
      final encryptedPassword = EncryptPassword.encryptPassword(password);

      if (await userDao.validateLogin(usernameOrEmail, encryptedPassword)) {
        // SI COINCIDEN LAS CREDENCIALES, ENTONCES IRA A LA PAGINA PRINCIPAL
        ChangeScreen.changeScreen(const BottomNavigation(), context);
      } else {
        // SI LAS CREDENCIALES FALLAN, SE MUESTRA UNA ALERTA
        AlertUtil.showSnackBarError(context,
            "The username or password you entered is incorrect. Please try again.");
      }
    }
  } // FUNCION LOGIN

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
                      AppColors.upLinearColor,
                      // COLOR DE ARRIBA DEL DEGRADADO
                      AppColors.downLinearColor,
                      // COLOR DE ABAJO DEL DEGRADADO
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontFamily: 'Gluten',
                            fontSize: 70,
                            color: AppColors.lightPurpleColor),
                      ),

                      const SizedBox(height: 10),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            FieldForm(
                              icon: IconClass.iconMaker(Icons.person, "Username"),
                              labelText: 'Username',
                              hintText: 'Enter your username',
                              controller: _usernameController,
                              validator: Validator.validateUsernameOrEmail,
                            ),
                            const SizedBox(height: 10),
                            PasswordFieldForm(
                              icon: IconClass.iconMaker(Icons.lock, "Password"),
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              controller: _passwordController,
                              validator: Validator.validatePassword,
                              passwordOnSaved: (value) => _password = value!,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // SE ALIMEA EL TEXTO A LA DERECHA
                      Align(
                          alignment: Alignment.centerRight,
                          // SE USA TEXT BUTTON PARA CUANDO PULSE EL TEXTO HAGA UNA ACCION
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot your password?",
                              style: TextStyle(
                                  color: AppColors.darkPurpleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )),

                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign in",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 45,
                                color: AppColors.darkPurpleColor),
                          ),
                          const SizedBox(width: 14),
                          ElevatedButton(
                              onPressed: () {
                                _login();
                              },
                              style: ElevatedButton.styleFrom(
                                // LE QUITAMOS EL PADDING DE DENTRO DEL BTON
                                padding: EdgeInsets.zero,
                              ),
                              child: IconClass.iconMaker(Icons.arrow_forward, "Enter app")),
                        ],
                      ),
                      const SizedBox(height: 70),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: AppColors.darkPurpleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // CAMBIAR A LA PANTALLA DE REGISTRO
                                ChangeScreen.changeScreen(
                                    const SignUpScreen(), context);
                              },
                              child: const Text(
                                "Sign up",
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
