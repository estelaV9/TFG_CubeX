import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/view/screen/signup_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/encrypt_password.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/database_helper.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../components/password_field_row.dart';
import '../../model/user.dart';
import '../../view/navigation/bottom_navigation.dart';
import '../../viewmodel/current_user.dart';
import '../utilities/internationalization.dart';

/// Pantalla de inicio de sesión.
///
/// Esta pantalla permite a los usuarios iniciar sesión en la aplicación utilizando
/// su nombre de usuario o correo electrónico y su contraseña. Si las credenciales
/// son correctas, se redirige al usuario a la pantalla principal. Si las credenciales
/// son incorrectas, se muestra una alerta de error.
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

  /// Método encargado de validar las credenciales de inicio de sesión.
  ///
  /// Valida el formulario, encripta la contraseña ingresada, y verifica si las
  /// credenciales (nombre de usuario/correo electrónico y contraseña) son correctas.
  ///
  /// Si las credenciales son válidas, actualiza el estado global con los datos del
  /// usuario y redirige a la pantalla principal. Si son incorrectas, muestra un mensaje
  /// de error.
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

        // OBTENER EL ID DEL USUARIO
        int idUser = await userDao.getIdUserFromName(currentUser.user!.username);
        if (idUser == -1) {
          DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
        } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

        // SETEAMOS EL ESTADO GLOBAL DEL TIPO DE CUBO Y SESION Y LO
        // PONEMOS POR DEFECTO AL PRIMER TIPO DE CUBO
        final cubeTypeDao = CubeTypeDao();
        // LISTAMOS TODOS LOS TIPOS DE CUBO DEL USUARIO PARA COGER EL PRIMERO
        List<CubeType> listCube = await cubeTypeDao.getCubeTypes(idUser);

        print(listCube.toString());
        CubeType? cubeType = listCube[0];
        // GUARDAR LOS DATOS DEL TIPO DE CUBO EN EL ESTADO GLOBAL
        final currentCube = Provider.of<CurrentCubeType>(
            this.context,
            listen: false);
        // SE ACTUALIZA EL ESTADO GLOBAL
        currentCube.setCubeType(cubeType);

        if (cubeType.idCube != null) {
          // EL TIPO DE SESION ES LA DE POR DEFECTO 'Normal'
          Session session = Session(
            idUser: idUser,
            sessionName: "Normal",
            idCubeType: cubeType.idCube!,
          ); // CREAMOS LA SESION

          // GUARDAR LOS DATOS DE LA SESION EN EL ESTADO GLOBAL
          final currentSession = Provider.of<CurrentSession>(
              this.context,
              listen: false);
          // SE ACTUALIZA EL ESTADO GLOBAL
          currentSession.setSession(session);
        } else {
          print('deberia controlar que no se pueda eliminar todos los tipos de cubo y todas las sesiones');
        } // VERIFICAR QUE HAY UN TIPO DE CUBO


        // SI COINCIDEN LAS CREDENCIALES, ENTONCES IRA A LA PAGINA PRINCIPAL
        ChangeScreen.changeScreen(const BottomNavigation(), context);
      } else {
        // SI LAS CREDENCIALES FALLAN, SE MUESTRA UNA ALERTA
        AlertUtil.showSnackBarError(context, "incorrect_username_password");
      }
    }
  } // FUNCION LOGIN

  @override
  Widget build(BuildContext context) {
    // SE OBTIENE EL IDIOMA ACTUAL
    Locale currentLocale = Localizations.localeOf(context);
    // SI ES ESPAÑOL, SE BAJA EL TAMAÑO PARA NO CAUSAR OVERFLOW
    double fontSize = currentLocale.languageCode == 'es' ? 50 : 70;
    double fontSizeByButton = currentLocale.languageCode == 'es' ? 35 : 45;

    return Scaffold(
      key: const Key('loginScreenKey'),
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
                      Flexible(
                        child: Container(
                          // LIMITA EL ANCHO
                          constraints: const BoxConstraints(maxWidth: 250),
                          child: Text(
                            Internationalization.internationalization.getLocalizations(context, "login_label"),
                            style: TextStyle(
                              fontFamily: 'Gluten',
                              fontSize: fontSize,
                              color: AppColors.lightPurpleColor,
                            ),
                            // AÑADE PUNTOS SUSPENSIVOS
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            FieldForm(
                              key: const Key('usernameField'),
                              icon: IconClass.iconMaker(
                                  context, Icons.person, "username"),
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
                              key: const Key('passwordField'),
                              icon: IconClass.iconMaker(
                                  context, Icons.lock, "password"),
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
                              TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeByButton,
                                  color: AppColors.darkPurpleColor),
                            ),

                          const SizedBox(width: 14),
                          ElevatedButton(
                              key: const Key('loginButton'),
                              onPressed: () {
                                _login();
                              },
                              style: ElevatedButton.styleFrom(
                                // LE QUITAMOS EL PADDING DE DENTRO DEL BTON
                                padding: EdgeInsets.zero,
                              ),
                              child: IconClass.iconMaker(
                                  context, Icons.arrow_forward, "enter_app")),
                        ],
                      ),

                      // ANCLAMOS AL FINAL DE LA PANTALLA
                      Expanded(child: Container()),
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
