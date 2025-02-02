import 'package:esteladevega_tfg_cubex/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/screen/signup_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/encrypt_password.dart';
import 'package:esteladevega_tfg_cubex/utilities/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/password_field_row.dart';
import '../model/user.dart';
import '../navigation/bottom_navigation.dart';
import '../viewmodel/current_user.dart';
import '../utilities/internationalization.dart';

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

      // SE CREA UN USUARIO
      final newUser = User(
          username: usernameOrEmail,
          mail: usernameOrEmail,
          password: encryptedPassword);

      if (await userDao.validateLogin(usernameOrEmail, encryptedPassword)) {
        // GUARDAR LOS DATOS DEL USURAIO EN EL ESTADO GLOBAL
        final currentUser =
            Provider.of<CurrentUser>(this.context, listen: false);
        currentUser.setUser(newUser); // SE ACTUALIZA EL ESTADO GLOBAL

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
                      // Log in
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "login_label",
                        "login_hint",
                        "login_label",
                        const TextStyle(
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
                              icon:
                                  IconClass.iconMaker(Icons.person, "Username"),
                              labelText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username"),
                              hintText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username_hint"),
                              controller: _usernameController,
                              validator: Validator.validateUsernameOrEmail,
                              labelSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username_label"),
                              hintSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username_hint"),
                            ),
                            const SizedBox(height: 10),
                            PasswordFieldForm(
                              icon: IconClass.iconMaker(Icons.lock, "Password"),
                              labelText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password"),
                              hintText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password_hint"),
                              controller: _passwordController,
                              validator: Validator.validatePassword,
                              passwordOnSaved: (value) => _password = value!,
                              labelSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password_label"),
                              hintSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password_hint"),
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
                          child:
                              // Forgot your password?
                              Internationalization.internationalization
                                  .createLocalizedSemantics(
                            context,
                            "forgot_password_label",
                            "forgot_password_hint",
                            "forgot_password",
                            const TextStyle(
                                color: AppColors.darkPurpleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sign in
                          Internationalization.internationalization
                              .createLocalizedSemantics(
                            context,
                            "sign_in_label",
                            "sign_in_hint",
                            "sign_in",
                            const TextStyle(
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
                              child: IconClass.iconMaker(
                                  Icons.arrow_forward, "Enter app")),
                        ],
                      ),
                      const SizedBox(height: 70),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Don't have an acccount?
                          Internationalization.internationalization
                              .createLocalizedSemantics(
                            context,
                            "no_account_label",
                            "no_account_hint",
                            "no_account",
                            const TextStyle(
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
                              child:
                                  // Sign Up
                                  Internationalization.internationalization
                                      .createLocalizedSemantics(
                                context,
                                "sign_up_button_label",
                                "sign_up_button_hint",
                                "sign_up_button",
                                const TextStyle(
                                    fontSize: 15,
                                    color: AppColors.darkPurpleColor,
                                    decoration: TextDecoration.underline),
                              )),
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
