import 'package:esteladevega_tfg_cubex/data/dao/supebase/user_dao_sb.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings_options/advanced_options_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings_options/configure_inspection_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings_options/configure_timer_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings_options/notification_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_styles.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/view/screen/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/database/database_helper.dart';
import '../components/appbar_class.dart';
import '../utilities/internationalization.dart';
import '../../viewmodel/current_user.dart';
import '../components/settings_container.dart';

/// Pantalla de configuración de la aplicación.
///
/// Esta pantalla permite al usuario personalizar su experiencia dentro de la app.
/// Desde aquí, el usuario podrá:
/// - Cambiar el idioma de la aplicación entre español e inglés.
/// - Acceder a su perfil personal.
/// - Activar o desactivar las notificaciones, además de personalizar cuáles desea recibir.
/// - Configurar las opciones del cronómetro, la inspección y otros ajustes avanzados.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String rutaImagen = "assets/default_user_image.png"; // IMAGEN DEFECTO
  UserDaoSb userDaoSb = UserDaoSb();
  String mail = "";

  // SHARED PREFEERNCES PARA EL IDIOMA
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas para guardar y cargar el idioma preferido.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setString("language", "en");
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
    String? result = await userDaoSb.getMailUserFromName(currentUser!.username);
    if (result != null) {
      setState(() {
        mail = result;
      });
      if (mail == "") {
        DatabaseHelper.logger.e("El mail es nulo. Mail: $mail");
      } // SI EL MAIL ES "", MUESTRA UN AVISO
    }
  } // METODO PARA RETORNAR EL MAIL DEL USUARIO QUE ACCEDIO

  // LA URL DE LA IMAGEN DEL USUARIO, QUE SE INICIALIZA CON LA IMAGEN POR DEFECTO
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    returnMail();
    _getImageUrl();
  }

  /// Método privado para obtener la URL de la imagen de perfil del usuario actual.
  ///
  /// Este método busca en la base de datos la imagen asociada al usuario actual y,
  /// si la encuentra, la asigna a la variable `imageUrl`.
  ///
  /// Procedimiento:
  /// - Obtiene el usuario actual y recupera el ID mediante su nombre.
  /// - Si el ID es válido, busca la URL de la imagen en la base de datos.
  /// - Si la imagen no es nula, actualiza el estado con la nueva URL.
  void _getImageUrl() async {
    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDaoSb.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
      return;
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    String? image = await userDaoSb.getImageUser(idUser);
    if (image != null) {
      setState(() {
        // SE ASIGNA EL VALOR DE LA URL DE LA IMAGEN
        imageUrl = image;
      });
    } // SI NO ES NULA, SE ASIGNA EL VALOR
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarClass.appBarWithBack(context, "settings"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppStyles.boxDecorationContainer(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IMAGEN DEL USUARIO
                    ClipOval(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 140,
                        height: 140,
                      ),
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

                          // MAIL USUARIO, SI EL NOMBRE DE USUARIO ES LARGO SE SALTA DE LINEA
                          Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              mail,
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.purpleIntroColor,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // GENERAL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Internationalization.internationalization
                      .localizedTextOnlyKey(
                    context,
                    "general",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightVioletColor),
                  ),
                ),

                // IDIOMAS
                SettingsContainer(
                  functionArrow: () {
                    AlertUtil.showChangeLanguague(context);
                  },
                  name: Internationalization.internationalization.getLocalizations(context, "languages"),
                  icon: Icons.language,
                  tooltip: Internationalization.internationalization.getLocalizations(context, "select_languages"),
                ),

                const SizedBox(height: 10),

                // NOTIFICACIONES
                SettingsContainer(
                  functionArrow: () {
                    // IR A LA PANTALLA DE NOTIFICACIONES
                    ChangeScreen.changeScreen(const NotificationScreen(), context);
                  },
                  name: Internationalization.internationalization.getLocalizations(context, "notification"),
                  icon: Icons.notifications,
                  tooltip: Internationalization.internationalization.getLocalizations(context, "select_notification"),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Internationalization.internationalization
                      .localizedTextOnlyKey(
                    context,
                    "time_configuration",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightVioletColor),
                  ),
                ),

                // CONFIGURAR TIMER
                SettingsContainer(
                  functionArrow: () {
                    // IR A LA PANTALLA DE NOTIFICACIONES
                    ChangeScreen.changeScreen(const ConfigureTimerScreen(), context);
                  },
                  name: Internationalization.internationalization.getLocalizations(context, "configure_timer"),
                  icon: Icons.timer,
                  tooltip: Internationalization.internationalization.getLocalizations(context, "configure_timer"),
                ),

                const SizedBox(height: 10),

                // CONFIGURAR INSPECCION
                SettingsContainer(
                  functionArrow: () {
                    // IR A LA PANTALLA DE CONFIGURAR INSPECCION
                    ChangeScreen.changeScreen(const ConfigureInspectionScreen(), context);
                  },
                  name: Internationalization.internationalization.getLocalizations(context, "inspection_title"),
                  icon: Icons.hourglass_top_rounded,
                  tooltip: Internationalization.internationalization.getLocalizations(context, "inspection_title"),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Internationalization.internationalization
                      .localizedTextOnlyKey(
                    context,
                    "account",
                    style: const TextStyle(
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

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Internationalization.internationalization
                      .localizedTextOnlyKey(
                    context,
                    "advanced_options_title",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightVioletColor),
                  ),
                ),

                // OPCIONES AVANZADAS
                SettingsContainer(
                  functionArrow: () {
                    // IR A LA PANTALLA DE OPCIONES AVANZADAS
                    ChangeScreen.changeScreen(const AdvancedOptionsScreen(), context);
                  },
                  name: Internationalization.internationalization
                      .getLocalizations(context, "advanced_options_title"),
                  icon: Icons.tune,
                  tooltip: Internationalization.internationalization
                      .getLocalizations(context, "advanced_options_title"),
                ),

                const SizedBox(height: 30),

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
                            .localizedTextOnlyKey(context, "name_github",
                                style: AppStyles.darkPurpleAndBold(30)))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}