import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/utilities/change_screen.dart';
import 'package:flutter/material.dart';

import 'bottom_navigation.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String rutaImagen = "assets/default_user_image.png"; // IMAGEN DEFECTO

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
            title: Text(
              text,
              style: const TextStyle(
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

  Padding textTitleListTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        text,
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
            // AVATAR Y NOMBRE
            Container(
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
                  const Text(
                    "namelength12",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurpleColor,
                    ),
                  ),

                  // MAIL USUARIO
                  const Text(
                    "example@example.com",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.darkPurpleColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // OPCIONES DEL MENU
            Expanded(
              child: ListView(
                children: [
                  // OPCIONES GENERALES
                  textTitleListTile("General"),
                  listTileGenerator(
                      Icons.timer, "Timer", const BottomNavigation()),
                  listTileGenerator(
                      Icons.palette, "App theme", const BottomNavigation()),
                  listTileGenerator(
                      Icons.person, "My profile", const BottomNavigation()),

                  // VERSUS
                  textTitleListTile("Championship"),
                  listTileGenerator(
                      Icons.sports_kabaddi, "Versus", const BottomNavigation()),

                  // OTRAS OPCIONES
                  textTitleListTile("Other"),
                  listTileGenerator(
                      Icons.settings, "Settings", const BottomNavigation()),
                  listTileGenerator(
                      Icons.info, "About the app", const BottomNavigation()),
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
            listTileGenerator(
                Icons.logout, "Log out", const BottomNavigation()),
          ],
        ),
      ),
    );
  }
}
