import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:esteladevega_tfg_cubex/view/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/encrypt_password.dart';
import 'package:esteladevega_tfg_cubex/utilities/validator.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/Icon/icon.dart';
import '../../view/navigation/bottom_navigation.dart';
import '../components/password_field_row.dart';
import '../../viewmodel/current_user.dart';
import '../../utilities/internationalization.dart';

/// Pantalla de registro de usuario.
///
/// Esta pantalla permite a los usuarios crear una cuenta en la aplicación.
///
/// Solicita el nombre de usuario, el correo electrónico, la contraseña y la confirmación de esa contraseña.
/// Valida los datos ingresados, y si son correctos, crea un nuevo usuario
/// y lo guarda en la base de datos.
///
/// Se configura unos tipos de cubos por defecto con su respectiva sesión por defecto 'Normal'
/// por cada usuario.
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

  /// Método encargado de registrar un nuevo usuario.
  ///
  /// Valida los campos del formulario, encripta la contraseña y guarda los datos
  /// del usuario en la base de datos.
  /// Si la creación es exitosa, configura una sesión por defecto y crea los tipos de
  /// cubos asociados al usuario.
  /// Además, maneja la navegación hacia la pantalla principal y muestra mensajes de
  /// éxito o error.
  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      // EJECUTA LAS FUNCIONES onSvaed DE LOS CAMPOS DEL FORMULARIO PORQUE
      // SI NO LA CONTRASEÑA NO SE ACTUALIZA
      _formKey.currentState?.save();

      final username = _usernameController.text;
      final mail = _mailController.text;
      String encryptedPassword = EncryptPassword.encryptPassword(_password);
      DatabaseHelper.logger.i('Encrypted password: $encryptedPassword');

      // SE CREA UN USUARIO
      final newUser =
          User(username: username, mail: mail, password: encryptedPassword);

      if (!await userDao.isExistsUsername(username)) {
        if (!await userDao.isExistsEmail(mail)) {
          if (await userDao.insertUser(newUser)) {
            // GUARDAR LOS DATOS DEL USURAIO EN EL ESTADO GLOBAL
            final currentUser =
                Provider.of<CurrentUser>(this.context, listen: false);
            currentUser.setUser(newUser); // SE ACTUALIZA EL ESTADO GLOBAL

            // SE MUESTRA UN SNACKBAR DE QUE SE HA CREADO CORRECTAMENTE
            // Y SE REDIRIGE A LA PANTALLA PRINCIPAL
            AlertUtil.showSnackBarInformation(
                this.context, "account_created_successfully");

            int idUser =
                await userDao.getIdUserFromName(currentUser.user!.username);

            if (idUser != -1) {
              // CUANDO SE INSERTA UN NUEVO USUARIO SE LE ASIGNA CUBOS POR DEFECTO
              CubeTypeDao cubeTypeDao = CubeTypeDao();
              SessionDao sessionDao = SessionDao();

              List<String> cubeTypes = [
                "2x2x2",
                "3x3x3",
                "4x4x4",
                "5x5x5",
                "6x6x6",
                "7x7x7",
                "PYRAMINX",
                "SKEWB",
                "MEGAMINX",
                "SQUARE-1"
              ];

              for (String type in cubeTypes) {
                cubeTypeDao.insertNewType(type, idUser);
              } // INSETAMOS LOS TIPOS DE CUBO EN LA BD

              for (String type in cubeTypes) {
                CubeType? cubeType = await cubeTypeDao.cubeTypeDefault(type);
                if (cubeType.idCube != null) {
                  Session session = Session(
                    idUser: idUser,
                    sessionName: "Normal",
                    idCubeType: cubeType.idCube!,
                  ); // CREAMOS LA SESION
                  await sessionDao.insertSession(session);

                  if (type == "3x3x3") {
                    // GUARDAR LOS DATOS DE LA SESION EN EL ESTADO GLOBAL
                    final currentSession = Provider.of<CurrentSession>(
                        this.context,
                        listen: false);
                    // SE ACTUALIZA EL ESTADO GLOBAL
                    currentSession.setSession(session);

                    int idSession =
                        await sessionDao.searchIdSessionByNameAndUser(
                            idUser, currentSession.session!.sessionName);

                    // GUARDAR LOS DATOS DEL TIPO DE CUBO EN EL ESTADO GLOBAL
                    final currentCube = Provider.of<CurrentCubeType>(
                        this.context,
                        listen: false);
                    // SE ACTUALIZA EL ESTADO GLOBAL
                    currentCube.setCubeType(cubeType);

                    if (idSession != -1) {
                      // SE MUESTRA UN MENSAJE DE QUE SE HA SETTEADO CORRECTAMENTE
                      DatabaseHelper.logger.i(
                          "Se han setteado correctamente el tipo de cubo y sesion acutales"
                          "\nSession actual: ${currentSession.session.toString()} con su id $idSession"
                          "\nTipo de cubo actual: ${currentCube.cubeType.toString()}");
                    } else {
                      DatabaseHelper.logger.e(
                          "No se encontro el id de la session actual: $idSession");
                    } // SE VERIFICA QUE SE BUSCO BIEN EL ID
                  } // SI EL TIPO DE CUBO ES 3X3 SE PONE SU SESION Y EL TIPO COMO LOS ACTUALES
                } else {
                  DatabaseHelper.logger
                      .e("Error al obtener el tipo de cubo: $type");
                } // VALIDAMOS QUE EL ID DE TIPO DE CUBO NO SEA NULO
              } // CREAMOS UNA SESION POR DEFECTO "NORMAL"PARA CADA TIPO DE CUBO

              /*List<Session> result = await sessionDao.sessionList();
              DatabaseHelper.logger.i("Sesiones: \n${result.join('\n')}");

              List<CubeType> result = await cubeTypeDao.getCubeTypes();
              DatabaseHelper.logger.i("TIPOS DE CUBOS obtenidas: \n${result.join('\n')}");
                // MENSAJE CON LA SESION
                DatabaseHelper.logger.w(session.sessionName);*/

              // CAMBIA A LA PANTALLA PRINCIPAL
              ChangeScreen.changeScreen(const BottomNavigation(), this.context);
            } else {
              // SE MUESTRA UN ERROR SI ES NULO
              DatabaseHelper.logger
                  .e("Error al pillar el id de tipo de cubo 3x3");
              // SE MUESTRA UN SNACKBARR MOSTRANDO QUE HA OCURRIDO UN ERROR PORQUE ES NULO
              AlertUtil.showSnackBarError(
                  this.context, "error_creating_account");
            } // VERIFICA SI EL ID DEL TIPO DE CUBO ES NULO
          } else {
            DatabaseHelper.logger.e("Error la obtener el id del usuario");
            // SE MUESTRA UN SNACKBARR MOSTRANDO QUE HA OCURRIDO UN ERROR AL BUSCAR EL ID
            AlertUtil.showSnackBarError(this.context, "error_creating_account");
          } // VERIFICAR EL ID DEL USUARIO
        } else {
          // SE MUESTRA UN SNACKBARR MOSTRANDO QUE HA OCURRIDO UN ERRO AL CREAR USUARIO
          AlertUtil.showSnackBarError(this.context, "error_creating_account");
        } // INSERTAR AL USUARIO
      } else {
        // SE MUESTRA UN SNACKBARR MOSTRANDO QUE EL MAIL DEL USUARIO YA EXISTE
        AlertUtil.showSnackBarError(this.context, "account_email_exists");
      } // VALIDAR QUE EL MAIL DEL USUARIO NO EXISTA
    } else {
      // SE MUESTRA UN SNACKBARR MOSTRANDO QUE EL NOMBRE DEL USUARIO YA EXISTE
      AlertUtil.showSnackBarError(this.context, "username_already_in_use");
    } // VALIDAR QUE EL NOMBRE DE USUARIO NO EXISTA
  } // SI TODOS LOS CAMPOS DEL FORMULARIO ESTAN CORRECTOS
//} // METODO PARA CREAR UNA CUENTA

  @override
  Widget build(BuildContext context) {
    // SE OBTIENE EL IDIOMA ACTUAL
    Locale currentLocale = Localizations.localeOf(context);
    // SI ES ESPAÑOL, SE BAJA EL TAMAÑO PARA NO CAUSAR OVERFLOW
    double fontSize = currentLocale.languageCode == 'es' ? 50 : 70;
    double fontSizeByButton = currentLocale.languageCode == 'es' ? 35 : 45;

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
                      // Sign up
                      Container(
                        // LIMITA EL ANCHO
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Text(
                          Internationalization.internationalization
                              .getLocalizations(
                                  context, "sign_up_button"),
                          style: TextStyle(
                              fontFamily: 'Gluten',
                              fontSize: fontSize,
                              color: AppColors.lightPurpleColor),
                          // AÑADE PUNTOS SUSPNESIVOS
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            FieldForm(
                              icon: IconClass.iconMaker(
                                  context, Icons.person, "username"),
                              labelText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username"),
                              hintText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username_hint"),
                              controller: _usernameController,
                              validator: (value) =>
                                  Validator.validateUsername(value),
                              labelSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username_label"),
                              hintSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "username_hint"),
                            ),

                            // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                            const SizedBox(height: 10),

                            FieldForm(
                              icon: IconClass.iconMaker(
                                  context, Icons.mail, "mail"),
                              labelText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "mail"),
                              hintText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "mail_hint"),
                              controller: _mailController,
                              validator: (value) =>
                                  Validator.validateEmail(value),
                              labelSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "mail_label"),
                              hintSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "mail_hint"),
                            ),

                            // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                            const SizedBox(height: 10),

                            PasswordFieldForm(
                              icon: IconClass.iconMaker(
                                  context, Icons.lock, "password"),
                              labelText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password"),
                              hintText: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password_hint"),
                              controller: _passwordController,
                              validator: (value) =>
                                  Validator.validatePassword(value),
                              passwordOnSaved: (value) => _password = value!,
                              labelSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password_label"),
                              hintSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(context, "password_hint"),
                            ),

                            // ESPACIO ENTRE LOS CAMPOS DEL FORMULARIO
                            const SizedBox(height: 10),

                            PasswordFieldForm(
                              icon: IconClass.iconMaker(
                                  context, Icons.check, "confirm_password"),
                              labelText: Internationalization
                                  .internationalization
                                  .getLocalizations(
                                      context, "confirm_password"),
                              hintText: Internationalization
                                  .internationalization
                                  .getLocalizations(
                                      context, "confirm_password_hint"),
                              controller: _confirmPasswordController,
                              validator: (value) =>
                                  Validator.validateConfirmPassword(
                                      value, _passwordController.text),
                              passwordOnSaved: (value) => _password = value!,
                              labelSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(
                                      context, "confirm_password_label"),
                              hintSemantics: Internationalization
                                  .internationalization
                                  .getLocalizations(
                                      context, "confirm_password_hint"),
                            ),
                          ])),

                      // ANCLAMOS AL FINAL DE LA PANTALLA
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sign up
                          Internationalization.internationalization
                              .createLocalizedSemantics(
                            context,
                            "sign_up_button_label",
                            "sign_up_button_hint",
                            "sign_up_button",
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeByButton,
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
                              child: IconClass.iconMaker(
                                  context, Icons.arrow_forward, "enter_app")),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Already have an account?
                          Internationalization.internationalization
                              .createLocalizedSemantics(
                            context,
                            "already_have_account_label",
                            "already_have_account_hint",
                            "already_have_account",
                            const TextStyle(
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
                              // Log in
                              child:
                                  // Already have an account?
                                  Internationalization.internationalization
                                      .createLocalizedSemantics(
                                context,
                                "login_link_label",
                                "login_link_hint",
                                "login_link",
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
