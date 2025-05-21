import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/data/database/supabase_helper.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:esteladevega_tfg_cubex/view/components/waves_painter/wave_container_painter.dart';
import 'package:esteladevega_tfg_cubex/view/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/icon_image_fieldrow.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/encrypt_password.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/validator.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/dao/supebase/cubetype_dao_sb.dart';
import '../../data/dao/supebase/session_dao_sb.dart';
import '../../data/dao/supebase/user_dao_sb.dart';
import '../components/Icon/icon.dart';
import '../../view/navigation/bottom_navigation.dart';
import '../components/password_field_row.dart';
import '../../viewmodel/current_user.dart';
import '../components/tooltip/tooltip_suggestion.dart';
import '../utilities/internationalization.dart';
import 'dart:math' as ran;

/// Pantalla de registro de usuario.
///
/// Esta pantalla permite a los usuarios crear una cuenta en la aplicación.
///
/// Solicita el nombre de usuario, el correo electrónico, la contraseña y la confirmación de esa contraseña.
/// Valida los datos ingresados, y si son correctos, crea un nuevo usuario
/// y lo guarda en la base de datos.
///
/// Si ese nombre ya existe en la base de datos, se genera uno nuevo con un numero
/// aleatorio de 4 cifras y se sugiere al usuario mediante un [PopOver].
///
/// Se configura unos tipos de cubos por defecto con su respectiva sesión por defecto 'Normal'
/// por cada usuario.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _password = ''; // ATRIBUTO PARA GUARDAR LA CONTRASEÑA
  bool isExisting = false;
  String newName = "";
  String nameController = "";
  bool isOnTapSuggestion = false;
  final userDaoSb = UserDaoSb();
  final sessionDaoSb = SessionDaoSb();
  final cubeTypeDaoSb = CubeTypeDaoSb();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    // SE INICIA LA ESCUCHA DEL ESTADO DE AUTENTICACION DE SUPABASE
    SupabaseHelper().getSession(context);
  }

  /// Abre la aplicacion movil o web en caso de fallar.
  ///
  /// Este metodo intenta abrir la app de gmail en dispositivos android usando un
  /// intent explicito. Si falla, intenta abrir el gmail en el navegador.
  ///
  /// En los demas dispositivos, directamente intenta abrir gmail en el navegador.
  Future<void> openGmailApp() async {
    // VERIFICAR SI EL DISPOSITIVO ES ANDROID
    if (Platform.isAndroid) {
      try {
        // CREAR UN INTENT EXPLICITO PARA ABRIR LA APP DE GMAIL
        const intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
          package: 'com.google.android.gm',
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        );

        // LANZA EL INTENT PARA ABRIR GMAIL
        await intent.launch();
      } catch (e) {
        // SI FALLA AL ABRIR LA APP DE GMAIL, ABRIR GMAIL EN EL NAVEGADOR
        DatabaseHelper.logger.w("No se pudo abrir la app de gmail: $e");

        final Uri gmailWeb = Uri.parse("https://mail.google.com");

        // VERIFICAR SI SE PUEDE ABRIR LA URL EN EL NAVEGADOR
        if (await canLaunchUrl(gmailWeb)) {
          await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
        } else {
          DatabaseHelper.logger.e("No se pudo abrir gmail app ni web");
        }
      }
    } else {
      // SI NO ES ANDROID, SE ABRE DIRECTAMENTE GMAIL EN EL NAVEGADOR
      final Uri gmailWeb = Uri.parse("https://mail.google.com");

      if (await canLaunchUrl(gmailWeb)) {
        await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
      } else {
        DatabaseHelper.logger.e("No se pudo abrir gmail web");
      }
    }
  } // METODO PARA ABRIR EL GMAIL

  /// Método encargado de registrar un nuevo usuario.
  ///
  /// - Valida los campos del formulario, encripta la contraseña y guarda los datos
  /// del usuario en la base de datos.
  /// - Crea una cuenta en Supabase, la cual tendra que autentificar.
  /// - Si la creación es exitosa, configura una sesión por defecto y crea los tipos de
  /// cubos asociados al usuario.
  ///
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

      final newUser = UserClass(username: username,
          mail: mail,
          password: encryptedPassword);

      if (!await userDaoSb.isExistsUsername(username)) {
        if (!await userDaoSb.isExistsEmail(mail)) {
          try {
            // REGISTRAR AL USUARIO EN SUPABASE
            final response = await SupabaseHelper.supabase.auth.signUp(
              emailRedirectTo: Platform.isWindows ? 'https://google.com' :
              kIsWeb ? null : 'io.supebase.cubex://login-callback',
              email: mail,
              password: _password,
              data: {
                'username': username,
                'mail': mail,
                'password': encryptedPassword,
              }
            );
            final snackBar =  SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey,
              action: SnackBarAction(
                label: Internationalization.internationalization
                    .getLocalizations(context, "Go"), // TEXTO BOTON
                textColor: Colors.yellow,
                onPressed: () async {
                  // SE ABRE LA APP DE GMAIL
                  await openGmailApp();
                },
              ),
              content: const Row(
                children: [
                  Icon(Icons.outgoing_mail),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "Cuenta creada, confirma tu email",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );

            // SE MUESTRA EL SNAKCBAR PARA IR AL GMAIL
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // OBTENER USUARIO DEVUELTO POR SUPABASE
            final user = response.user;
            if (user != null) {
              final idUser = await userDaoSb.getIdUserFromName(mail);

              if (idUser != -1) {
                // GUARDAR LOS DATOS DEL USURAIO EN EL ESTADO GLOBAL
                final currentUser = Provider.of<CurrentUser>(this.context, listen: false);
                newUser.isSingup = true;
                // SE ACTUALIZA EL ESTADO GLOBAL Y LAS PREFERENCIAS
                currentUser.setUser(newUser);

                final prefs = await SharedPreferences.getInstance();
                await newUser.saveToPreferences(prefs);
                await prefs.setBool("isLoggedIn", false);
                await prefs.setBool("isSingup", true);
                await prefs.reload();

                // CUBOS POR DEFECTO
                final cubeTypes = [
                  "2x2x2", "3x3x3", "4x4x4", "5x5x5", "6x6x6", "7x7x7",
                  "PYRAMINX", "SKEWB", "MEGAMINX", "SQUARE-1"
                ];

                for (final cube in cubeTypes) {
                  await cubeTypeDaoSb.insertNewType(cube, idUser);
                } // INSERTAR LOS TIPOS DE CUBO POR DEFECTO

                // OBTENER LOS TIPOS DE CUBO DEL USUARIO
                final userCubeTypes = await cubeTypeDaoSb.getCubeTypes(idUser);

                for (final type in userCubeTypes) {
                  if (type.idCube != null) {
                    final session = SessionClass(
                      idUser: idUser,
                      sessionName: "Normal",
                      idCubeType: type.idCube!,
                    );
                    await sessionDaoSb.insertSession(session);

                    if (type.cubeName == "3x3x3") {
                      final currentSession = Provider.of<CurrentSession>(context, listen: false);
                      final currentCube = Provider.of<CurrentCubeType>(context, listen: false);

                      currentSession.setSession(session);
                      currentCube.setCubeType(type);

                      final idSession = await sessionDaoSb.searchIdSessionByNameAndUser(idUser, session.sessionName);

                      if (idSession != -1) {
                        DatabaseHelper.logger.w("Sesión y cubo actuales seteados correctamente.");
                      } else {
                        DatabaseHelper.logger.w("No se encontró el ID de la sesión actual.");
                      } // VERIFICAR SI SE ENCONTRO EL ID CORRECTAMENTE
                    } // CONFIGURAR SESION SI EL TIPO DE CUBO ES 3X3
                  } else {
                    DatabaseHelper.logger.w("ID de tipo de cubo es null para $type");
                  } // VERIFICAR SI SE ENCONTRO EL ID DE CUBO CORRECTAMENTE
                } // SE RECCOORREN TODOS LOS TIPOS D ECUBOS

                // CAMBIAR A LA PANTALLA PRINCIPAL
                ChangeScreen.changeScreen(const BottomNavigation(), context);
              } else {
                AlertUtil.showSnackBarError(context, "error_creating_account");
              }
            } // VERIFICAMOS QUE EL USUARIO NO SEA NULL
          } catch (e) {
            if (!mounted) return;

            // MANEJO DE ERRORES DE SUPABASE
            if (e is AuthException && e.message.contains('otp_expired')) {
              AlertUtil.showSnackBarError(context, "El enlace ha caducado. Solicita uno nuevo.");
            } else {
              AlertUtil.showSnackBarError(context, "Ocurrió un error. Intenta nuevamente.");
            }

            DatabaseHelper.logger.e("Error en signUp: $e");
          }
        } else {
          AlertUtil.showSnackBarError(context, "account_email_exists");
        } // VERIFICAR SI EL CORREO YA EXISTE
      } else {
        // EL NOMBRE DE USUARIO YA EXISTE
        AlertUtil.showSnackBarError(context, "username_already_in_use");
        setState(() {
          isExisting = true;
        });
        // SE SUGIERE OTRO
        newName = await randomUsername();
      }
    }
  } // METODO PARA CREAR UNA CUENTA

  /// Método qeu genera un nombre de usuario aleatorio basado en el texto del `_usernameController`.
  ///
  /// Si el nombre generado ya existe en la base de datos, se intenta nuevamente
  /// con un nuevo número aleatorio de cuatro cifras hasta encontrar uno único.
  ///
  /// Devuelve un [String] con el nombre de usuario generado que no existe en la base de datos.
  Future<String> randomUsername() async {
    // GENERA UN NUMERO ALEATORIO ENTRE 1 Y 9999
    int number = ran.Random().nextInt(9999) + 1;

    // FORMATEA EL NUMERO PARA QUE SIEMPRE TENGA 4 CIFRAS (0001, 0034...)
    String formattedNumber = number.toString().padLeft(4, '0');

    // CREA EL NUEVO NOMBRE COMBINADO CON EL NUMERO GENERADO
    newName = "${_usernameController.text}$formattedNumber";
    while (await userDaoSb.isExistsUsername(newName)) {
      // SE VUELVE A GENERAR UN NUMERO HASTA QUE SEA UNICO EL NOMBRE
      number = ran.Random().nextInt(9999) + 1;
      formattedNumber = number.toString().padLeft(4, '0');
      newName = "${_usernameController.text}$formattedNumber";
    } // MIENTRAS EXISTA EN LA BASE DE DATOS

    // DEVUELVE EL NOMBRE UNICO
    return newName;
  }

  @override
  Widget build(BuildContext context) {
    // SE OBTIENE EL IDIOMA ACTUAL
    Locale currentLocale = Localizations.localeOf(context);
    // SI ES ESPAÑOL, SE BAJA EL TAMAÑO PARA NO CAUSAR OVERFLOW
    double fontSize = currentLocale.languageCode == 'es' ? 50 : 70;
    double fontSizeByButton = currentLocale.languageCode == 'es' ? 35 : 45;

    return GestureDetector(
        // CUANDO SE TOCA EN CUALQUIER LADO DE LA PANTALLA
        onTap: () {
          // SE QUITA EL FOCO DEL ELEMENTO ACTUAL, LO QUE CIERRA EL TECLADO SI ESTA ABIERTO
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          // EVITAMOS QUE EL CONTENIDO DE LA PANTALLA SE MUEVA HACIA ARRIBA CUANDO APARECE EL TECLADO
          // ASI LOS ELEMENTOS NO SE DESPLACEN (Y NO GENEREN OVERFLOW)
          resizeToAvoidBottomInset: false,
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

              // SE DEJA UN HUECO DONDE SE VE UN POCO LA PARTE DE ARRIBA

              Positioned.fill(
                  child: CustomPaint(
                painter: WaveContainerPainter(),
                // FORMULARIO
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 65),
                  child: Column(
                    children: [
                      // AÑADE UN ESPACIO GRANDE
                      const Spacer(),
                      // Sign up
                      Container(
                        margin: const EdgeInsets.only(top: 60),
                        // LIMITA EL ANCHO
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: StrokeText(
                          text: Internationalization.internationalization
                              .getLocalizations(context, "sign_up_button"),
                          textStyle: TextStyle(
                              fontFamily: 'Gluten',
                              fontSize: fontSize,
                              color: AppColors.lightPurpleColor),
                          // AÑADE PUNTOS SUSPNESIVOS
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          // DA CONTORNO AL TEXTO
                          strokeColor: AppColors.darkPurpleColor,
                          strokeWidth: 5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            if (isExisting)
                              const SizedBox(height: 35),

                            if (isExisting)
                              // SI EL NOMBRE EXISTE ENTONCES SE MUESTRA UN POPOVER
                              // CON EL NOMBRE SUGERIDO
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 60),
                                  child: CustomPopoverSuggestion(
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            !Platform.isAndroid && !Platform.isIOS ?
                                            isOnTapSuggestion = true
                                            : setState(() {
                                              _usernameController.text =
                                                  newName;
                                              isExisting = false;
                                            });
                                          });
                                        },
                                        child: !Platform.isAndroid && !Platform.isIOS ?
                                        MouseRegion(
                                            onHover: (_) {
                                              setState(() {
                                                _usernameController.text =
                                                    newName;
                                              });
                                            },
                                            onExit: (_) {
                                              if (!isOnTapSuggestion) {
                                                setState(() {
                                                  _usernameController.text =
                                                      nameController;
                                                });
                                              } else {
                                                setState(() {
                                                  _usernameController.text =
                                                      newName;
                                                  isExisting = false;
                                                });
                                              }
                                            },
                                            child: Text(newName)) : Text(newName)),
                                  ),
                                ),
                              ),

                            if (isExisting)
                              const SizedBox(height: 8),

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
                              validator: (value) {
                                String? errorKey =
                                    Validator.validateUsername(value);
                                if (errorKey != null) {
                                  return Internationalization
                                      .internationalization
                                      .getLocalizations(context, errorKey);
                                }
                              },
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
                              validator: (value) {
                                String? errorKey =
                                    Validator.validateEmail(value);
                                if (errorKey != null) {
                                  return Internationalization
                                      .internationalization
                                      .getLocalizations(context, errorKey);
                                }
                              },
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
                              validator: (value) {
                                String? errorKey =
                                    Validator.validatePassword(value);
                                if (errorKey != null) {
                                  return Internationalization
                                      .internationalization
                                      .getLocalizations(context, errorKey);
                                }
                              },
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
                              validator: (value) {
                                String? errorKey =
                                    Validator.validateConfirmPassword(
                                        value, _passwordController.text);
                                if (errorKey != null) {
                                  return Internationalization
                                      .internationalization
                                      .getLocalizations(context, errorKey);
                                }
                                return null;
                              },
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
                                setState(() {
                                  isExisting = false;
                                  // CUANDO PULSE AL BOTON DE CREAR CUENTA SE GUARDA
                                  // EL NOMBRE DE USUARIO MANDADO PARA GENERAR UNO
                                  // NUEVO A PARTIR DEL QUE HAYA PROPORCIONADO SI EL
                                  // NOMBRE YA EXISTE
                                  nameController = _usernameController.text;
                                });
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
        ));
  }
}
