import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
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

import '../../viewmodel/current_user.dart';
import '../../view/navigation/bottom_navigation.dart';

/// Widget que representa el `Drawer` (menú lateral) de la aplicación.
///
/// El `AppDrawer` contiene información sobre el usuario, su avatar y correo,
/// y un conjunto de opciones que redirigen a diferentes pantallas de la aplicación.
/// Las opciones están localizadas, lo que significa que se ajustan según el idioma
/// seleccionado en la aplicación.
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String rutaImagen = "assets/default_user_image.png"; // IMAGEN DEFECTO
  UserDao userDao = UserDao();
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // CUANDO EL MOUSE PASA POR ENCIMA, SE CAMBIA EL COLOR DE FONDO
            color: isHovered ? AppColors.listTileHover : null,
          ),
          child: ListTile(
            // PADDING
            contentPadding: const EdgeInsets.only(left: 30),
            leading: Icon(icon, color: AppColors.darkPurpleColor),
            title: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              text,
              text,
              text,
              const TextStyle(
                color: AppColors.darkPurpleColor,
              ),
            ),
            onTap: () {
              // CAMBIAR VISTA AL TOCAR EL LISTILE
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
        Internationalization.internationalization.getLocalizations(context, text),
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.darkPurpleColor,
        ),
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
            // LO METEMOS TODO_EN UNA FILA PARA EXPANDIR EL CONTAINER
            Row(
              children: [
                Expanded(
                  // AVATAR Y NOMBRE
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.imagenBg,
                          child: Image.asset(rutaImagen), // IAMGEN
                        ),
                        const SizedBox(height: 10),

                        // NOMBRE USUARIO
                        Text(
                          returnName(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkPurpleColor,
                          ),
                        ),

                        // MAIL USUARIO
                        Text(
                          mail,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.darkPurpleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                  listTileGenerator(
                      Icons.palette, "app_theme", const BottomNavigation()),
                  listTileGenerator(
                      Icons.person, "my_profile", const MyProfileScreen()),

                  // VERSUS
                  textTitleListTile("championship"),
                  listTileGenerator(
                      Icons.sports_kabaddi, "versus", const BottomNavigation()),

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
            listTileGenerator(Icons.logout, "log_out", const LoginScreen()),
          ],
        ),
      ),
    );
  }
}
