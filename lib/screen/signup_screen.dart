import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:esteladevega_tfg_cubex/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/utilities/encrypt_password.dart';
import 'package:esteladevega_tfg_cubex/utilities/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/Icon/icon.dart';
import '../navigation/bottom_navigation.dart';
import '../components/password_field_row.dart';
import '../viewmodel/current_user.dart';
import '../utilities/internationalization.dart';

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
                this.context, "Account created successfully.");

            int idUser =
                await userDao.getIdUserFromName(currentUser.user!.username);

            print(idUser );
            if (idUser != -1) {
              // CUANDO SE INSERTA UN NUEVO USUARIO SE LE ASIGNA CUBOS POR DEFECTO
              CubeTypeDao cubeTypeDao = CubeTypeDao();
              cubeTypeDao.insertNewType("2x2x2", idUser);
              cubeTypeDao.insertNewType("3x3x3", idUser);
              cubeTypeDao.insertNewType("4x4x4", idUser);
              cubeTypeDao.insertNewType("5x5x5", idUser);
              cubeTypeDao.insertNewType("6x6x6", idUser);
              cubeTypeDao.insertNewType("7x7x7", idUser);
              cubeTypeDao.insertNewType("PYRAMINX", idUser);
              cubeTypeDao.insertNewType("SKEWB", idUser);
              cubeTypeDao.insertNewType("MEGAMINX", idUser);
              cubeTypeDao.insertNewType("SQUARE-1", idUser);

              /*List<CubeType> result = await cubeTypeDao.getCubeTypes();
              DatabaseHelper.logger.i("TIPOS DE CUBOS obtenidas: \n${result.join('\n')}");*/

              // Y SE INSERTA LA SESION POR DEFECTO "Normal"
              SessionDao sessionDao = SessionDao();
              // BUSCAMOS EL ID DEL TIPO DE CUBO 3X3
              CubeType cubeType = await cubeTypeDao.cubeTypeDefault("3x3x3");
              int? idCubeType = cubeType.idCube;
              if (idCubeType != null) {
                Session session = Session(
                    idUser: idUser,
                    sessionName: "Normal",
                    idCubeType: idCubeType);
                sessionDao.insertSession(session);

                // MENSAJE CON LA SESION
                DatabaseHelper.logger.w(session.sessionName);

                // CAMBIA A LA PANTALLA PRINCIPAL
                ChangeScreen.changeScreen(
                    const BottomNavigation(), this.context);
              } else {
                // SE MUESTRA UN ERROR SI ES NULO
                DatabaseHelper.logger
                    .e("Error al pillar el id de tipo de cubo 3x3");
                // SE MUESTRA UN SNACKBARR MOSTRANDO QUE HA OCURRIDO UN ERROR PORQUE ES NULO
                AlertUtil.showSnackBarError(this.context,
                    "An error occurred while creating the account.");
              } // VERIFICA SI EL ID DEL TIPO DE CUBO ES NULO
            } else {
              DatabaseHelper.logger.e("Error la obtener el id del usuario");
              // SE MUESTRA UN SNACKBARR MOSTRANDO QUE HA OCURRIDO UN ERROR AL BUSCAR EL ID
              AlertUtil.showSnackBarError(this.context,
                  "An error occurred while creating the account.");
            } // VERIFICAR EL ID DEL USUARIO
          } else {
            // SE MUESTRA UN SNACKBARR MOSTRANDO QUE HA OCURRIDO UN ERRO AL CREAR USUARIO
            AlertUtil.showSnackBarError(
                this.context, "An error occurred while creating the account.");
          } // INSERTAR AL USUARIO
        } else {
          // SE MUESTRA UN SNACKBARR MOSTRANDO QUE EL MAIL DEL USUARIO YA EXISTE
          AlertUtil.showSnackBarError(
              this.context, "An account with this email already exists.");
        } // VALIDAR QUE EL MAIL DEL USUARIO NO EXISTA
      } else {
        // SE MUESTRA UN SNACKBARR MOSTRANDO QUE EL NOMBRE DEL USUARIO YA EXISTE
        AlertUtil.showSnackBarError(
            this.context, "This username is already in use.");
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
                      // Sign up
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "sign_up_button_label",
                        "sign_up_button_hint",
                        "sign_up_button",
                        const TextStyle(
                            fontFamily: 'Gluten',
                            fontSize: 70,
                            color: AppColors.lightPurpleColor),
                      ),
                      const SizedBox(height: 10),
                      Form(
                          key: _formKey,
                          child: Column(children: [
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
                              icon: IconClass.iconMaker(Icons.mail, "Mail"),
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
                              icon: IconClass.iconMaker(Icons.lock, "Password"),
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
                                  Icons.check, "Confirm Password"),
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
                      const SizedBox(height: 15),
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
                            const TextStyle(
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
                              child: IconClass.iconMaker(
                                  Icons.arrow_forward, "Enter app")),
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
