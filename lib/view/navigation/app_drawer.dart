import 'package:esteladevega_tfg_cubex/data/dao/supebase/user_dao_sb.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:esteladevega_tfg_cubex/view/screen/about_app_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/my_profile_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../viewmodel/current_user.dart';
import '../../view/navigation/bottom_navigation.dart';
import '../components/waves_painter/drawer_wave.dart';
import '../utilities/app_styles.dart';

/// Widget que representa el `Drawer` (menú lateral) de la aplicación.
///
/// El `AppDrawer` contiene información sobre el usuario, su avatar y correo,
/// y un conjunto de opciones que redirigen a diferentes pantallas de la aplicación.
/// Las opciones están localizadas, lo que significa que se ajustan según el idioma
/// seleccionado en la aplicación.
/// Además, se podrá visualizar la foto de perfil que tenga el usuario. En caso de no
/// tener, se visualizará la de por defecto.
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String rutaImagen = "assets/default_user_image.png"; // IMAGEN DEFECTO
  UserDaoSb userDaoSb = UserDaoSb();
  String mail = "";

  /// Método para obtener el nombre del usuario actualmente logueado.
  ///
  /// Obtiene el nombre del usuario desde el estado actual del contexto de la aplicación.
  /// Si el usuario no está definido, se devuelve "error".
  String returnName() {
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;
    return currentUser?.username ?? "error";
  } // METODO PARA RETORNAR EL NOMBRE DEL USUARIO QUE ACCEDIO

  /// Método para obtener el correo electrónico del usuario.
  ///
  /// Utiliza el `UserDao` para obtener el correo del usuario desde la base de datos.
  /// Luego, actualiza el estado con el correo del usuario. Si el correo es vacío,
  /// se muestra un mensaje de error en los logs.
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
    } // VERIFICAR QUE NO SEA NULO EL RESULTADO
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

  /// Metodo que cierra la sesión del usuario actual.
  ///
  /// Actualiza las preferencias compartidas para marcar que el usuario
  /// ya no está logueado ni registrado (`isLoggedIn` y `isSingup` se establecen en `false`).
  /// Luego se recarga las preferencias para que los cambios se apliquen.
  void _logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    await prefs.setBool("isSingup", false);
    await prefs.reload();
  }

  /// Método para generar un `ListTile` con un ícono, texto y una pantalla de destino.
  ///
  /// Este método sirve para evitar la duplicación de código al crear las opciones
  /// del menú lateral. Al pasar un ícono, texto y destino, genera un `ListTile` con un hover
  /// que cambia de pantalla al ser tocado.
  ///
  /// @param icon El ícono que representa la opción.
  /// @param text La clave del texto que será traducido.
  /// @param nameScreen La pantalla a la que se redirige al tocar la opción.
  Widget listTileGenerator(IconData icon, String text, Widget nameScreen) {
    bool isHovered = false; // ESTADO PARA DETECTAR EL HOVER
    // 'StatefulBuilder' PARA MANTENER EL ESTADO LOCAL EN CADA LISTTILE
    // SIN ESTO TODOS LOS ListTile SE CAMBIAN A LA VEZ
    return StatefulBuilder(builder: (context, setState) {
      return MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true; // CUANDO EL MOUSE ENTRA
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false; // CUANDO EL MOUSE SALE
          });
        },
        // SE USA CONTAINER PARA CAMBIAR EL COLOR DEL FONDO DE LISTTILE
        child: Container(
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // CUANDO EL MOUSE PASA POR ENCIMA, SE CAMBIA EL COLOR DE FONDO
            color: isHovered ? AppColors.listTileHover : null,
          ),
          child: ListTile(
            // PADDING
            contentPadding: const EdgeInsets.only(left: 30),
            leading: Icon(icon, color: AppColors.darkPurpleColor),
            title: Internationalization.internationalization.localizedTextOnlyKey(
              context,
              text,
              style: const TextStyle(
                color: AppColors.darkPurpleColor,
              ),
            ),
            onTap: () {
              // CAMBIAR VISTA AL TOCAR EL LISTILE
              if (text == "log_out") {
                _logoutUser();
              } // SI HA PUSLADO LA OPCION DE DESLOGEARSE SE ACTUALIZA LAS PREFERENCIAS
              ChangeScreen.changeScreen(nameScreen, context);
            },
          ),
        ),
      );
    });
  } // METODO QUE DEVUELVA UN LISTTILE Y ASI NO DUPLICAR CODIGO

  /// Método para generar un `Text` que actúa como título de una sección en el Drawer,
  /// evitando así, la duplicación de código.
  ///
  /// Este método se encarga de mostrar los títulos de las secciones en el Drawer
  /// (por ejemplo, "Opciones generales", "Versus", etc.), localizados según el idioma.
  ///
  /// @param text La clave del texto a mostrar como título.
  Padding textTitleListTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        Internationalization.internationalization
            .getLocalizations(context, text),
        style: AppStyles.darkPurple(15),
      ),
    );
  } // METODO PARA LOS TITULOS DEL LISTINER PARA NO DUPLICAR CODIGO

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200, // TAMAÑO DEL DRAWER
      child: Container(
        color: AppColors.purpleA172de, // COLOR DE FONDO DEL DRAWER
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox CON EL WAVE Y EL CICLERAVATAR
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    // LA WAVE SE UBICA EN LA PARTE SUPERIOR
                    top: 0,
                    left: 0,
                    child: CustomPaint(
                      painter: DrawerWave(
                        backgroundColor: AppColors.lightVioletColor,
                      ),
                      // TAMAÑO DEL WAVE
                      child: const SizedBox(
                        // OCUPA TODO_EL TAMAÑO DEL DRAWER
                        width: 200,
                        height: 110,
                      ),
                    ),
                  ),
                  // CIRCLEAVATAR
                  Positioned(
                    top: 30,
                    left: 20,
                    child: // IMAGEN DEL USUARIO
                        CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.imagenBg,
                            // SE MUESTRA LA IMAGEN A TRAVES DEL URL GUARDADO
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                            )),
                  ),

                  // NOMBRE Y MAIL DEL USUARIO
                  Positioned(
                    top: 140,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOMBRE USUARIO
                        Text(
                          returnName(),
                          style: AppStyles.darkPurpleAndBold(20),
                        ),

                        // MAIL USUARIO, SI EL NOMBRE DE USUARIO ES LARGO SE SALTA DE LINEA
                        Container(
                          constraints: const BoxConstraints(
                              maxWidth: 160, maxHeight: 10),
                          child: Text(
                            mail,
                            style: AppStyles.darkPurple(15).copyWith(
                              // ACERCAR LAS LINEAS
                              height: 1,
                            ),
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // OPCIONES DEL MENU
            Expanded(
              child: ListView(
                children: [
                  // OPCIONES GENERALES
                  textTitleListTile("general"),
                  listTileGenerator(
                      Icons.timer, "timer", const BottomNavigation()),
                  /*listTileGenerator(
                      Icons.palette, "app_theme", const BottomNavigation()),*/
                  listTileGenerator(
                      Icons.person, "my_profile", const MyProfileScreen()),

                  /*const SizedBox(height: 15),

                  // VERSUS
                  textTitleListTile("championship"),
                  listTileGenerator(
                      Icons.sports_kabaddi, "versus", const BottomNavigation()),*/

                  const SizedBox(height: 15),

                  // OTRAS OPCIONES
                  textTitleListTile("other"),
                  listTileGenerator(
                      Icons.settings, "settings", const SettingsScreen()),
                  listTileGenerator(
                      Icons.info, "about_the_app", const AboutAppScreen()),
                ],
              ),
            ),

            // SE MUEVE FUERA DEL DRAWER PARA QUE SE VAYA AL FONDO DE ESTE
            const Divider(
                // ALTURA DEL DIVIDER
                height: 3,
                // GROSOR DE LA LINEA
                thickness: 2,
                // ESPACIO DESDE EL BORDE IZQUIERDO HATA QUE COMIENZA EL DIVIDER
                indent: 20,
                // ESPACIADO DEL BORDE DERECHO HASTA QUE TERMINA EL DIVIDER
                endIndent: 20,
                color: AppColors.darkPurpleColor),

            // BOTON PARA CERRAR SESION
            Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: listTileGenerator(
                    Icons.logout, "log_out", const LoginScreen()))
          ],
        ),
      ),
    );
  }
}