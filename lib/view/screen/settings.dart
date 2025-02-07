import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/view/screen/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/dao/user_dao.dart';
import '../../data/database/database_helper.dart';
import '../../utilities/internationalization.dart';
import '../../viewmodel/current_user.dart';
import '../components/settings_container.dart';

/// Pantalla de configuración de la aplicación.
///
/// Esta pantalla permite (por ahora) al usuario cambiar el idioma de la aplicación
/// entre español e inglés y acceder a su perfil personal.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String rutaImagen = "assets/default_user_image.png"; // IMAGEN DEFECTO
  UserDao userDao = UserDao();
  String mail = "";

  // SHARED PREFEERNCES PARA EL IDIOMA
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas para guardar y cargar el idioma preferido.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setString("language", "es");
    }
  }

  /// Obtiene el nombre del usuario actual.
  ///
  /// Este método accede al estado global para recuperar el nombre del usuario
  /// actualmente logueado.
  String returnName() {
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;
    return currentUser?.username ?? "error";
  } // METODO PARA RETORNAR EL NOMBRE DEL USUARIO QUE ACCEDIO

  /// Obtiene el correo electrónico del usuario actual.
  ///
  /// Este método consulta la base de datos para obtener el correo electrónico del usuario
  /// y lo actualiza en la interfaz.
  void returnMail() async {
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;
    String result = await userDao.getMailUserFromName(currentUser!.username);
    setState(() {
      mail = result;
    });
    if (mail == "") {
      DatabaseHelper.logger.e("El mail es nulo. Mail: $mail");
    } // SI EL MAIL ES "", MUESTRA UN AVISO
  } // METODO PARA RETORNAR EL MAIL DEL USUARIO QUE ACCEDIO

  @override
  void initState() {
    super.initState();
    returnMail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Internationalization.internationalization.createLocalizedSemantics(
          context,
          "settings",
          "settings",
          "settings",
          const TextStyle(fontFamily: 'Broadway', fontSize: 35),
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightVioletColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          // COLOR DEGRADADO PARA EL FONDO
          gradient: LinearGradient(
            begin: Alignment.topCenter, // DESDE ARRIBA
            end: Alignment.bottomCenter, // HASTA ABAJO
            colors: [
              // COLOR DE ARRIBA DEL DEGRADADO
              AppColors.upLinearColor,
              // COLOR DE ABAJO DEL DEGRADADO
              AppColors.downLinearColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IMAGEN DEL USUARIO
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.imagenBg,
                  child: Image.asset("assets/default_user_image.png"),
                ),

                // COLUMNA PARA EL NOMBRE Y EL MAIL DEL USUARIO
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    // SE ALINEA A LA IZQUIERDA
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOMBRE USUARIO
                      Text(
                        returnName(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.purpleIntroColor,
                        ),
                      ),

                      // MAIL USUARIO
                      Text(
                        mail,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.purpleIntroColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // GENERAL
            Align(
              alignment: Alignment.centerLeft,
              child: Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                "general",
                "general",
                "general",
                const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightVioletColor),
              ),
            ),

            // IDIOMAS
            SettingsContainer(
              functionArrow: () {
                AlertUtil.showChangeLanguague(context, "dsaf");
              },
              name: Internationalization.internationalization.getLocalizations(context, "languages"),
              icon: Icons.language,
              tooltip: Internationalization.internationalization.getLocalizations(context, "select_languages"),
            ),

            const SizedBox(
              height: 10,
            ),

            // NOTIFICACIONES
            SettingsContainer(
              functionArrow: () {},
              name: Internationalization.internationalization.getLocalizations(context, "notification"),
              icon: Icons.notifications,
              tooltip: Internationalization.internationalization.getLocalizations(context, "select_notification"),
            ),

            const SizedBox(
              height: 20,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                "time_configuration",
                "time_configuration",
                "time_configuration",
                const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightVioletColor),
              ),
            ),

            // CONFIGURAR TIMER
            SettingsContainer(
              functionArrow: () {},
              name: Internationalization.internationalization.getLocalizations(context, "configure_timer"),
              icon: Icons.timer,
              tooltip: Internationalization.internationalization.getLocalizations(context, "configure_timer"),
            ),

            const SizedBox(
              height: 20,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                "account",
                "account",
                "account",
                const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightVioletColor),
              ),
            ),

            // PERFIL
            SettingsContainer(
              functionArrow: () {
                ChangeScreen.changeScreen(const MyProfileScreen(), context);
              }, // CUANDO PULSE IRA A LA PANTALLA DE PERFIL
              name: Internationalization.internationalization.getLocalizations(context, "my_profile"),
              icon: Icons.person,
              tooltip: Internationalization.internationalization.getLocalizations(context, "my_profile"),
            ),

            // COLOCAMOS UN EXPANDED PARA OCUPAR EL ESPACIO RESSTANTE Y
            // COLOCAR EL GITHUB ABAJO DELTODO
            Expanded(child: Container()),

            // GITHUB
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconClass.iconMaker(
                    context, Icons.account_circle_sharp, "github", 40),
                TextButton(
                    onPressed: () async {
                      // CUANDO PULSE IRA A MI GITHUB
                      const url = 'https://github.com/estelaV9';

                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'No se pudo abrir la URL';
                      } // VERIFICA SI LA URL ES VALIDA
                    },
                    child: Internationalization.internationalization
                        .createLocalizedSemantics(
                      context,
                      "name_github",
                      "name_github",
                      "name_github",
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkPurpleColor,
                        fontSize: 30,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
