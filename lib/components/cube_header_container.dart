import 'package:esteladevega_tfg_cubex/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/components/session_menu.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_user.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/dao/cubetype_dao.dart';
import '../model/cubetype.dart';
import '../viewmodel/current_cube_type.dart';
import 'Icon/animated_icon.dart';
import 'cube_type_menu.dart';

class CubeHeaderContainer extends StatefulWidget {
  const CubeHeaderContainer({super.key});

  @override
  State<CubeHeaderContainer> createState() => _CubeHeaderContainerState();
}

class _CubeHeaderContainerState extends State<CubeHeaderContainer> {
  // SE AÑADE EN ESTA CLASE EL OVERLAY DEL MENU SESSION
  bool isMenuVisible = false; // COMPROBAR SI EL MENU ESTA VISIBLE O NO

  CubeType cubeType = CubeType(idCube: -1, cubeName: "3x3x3"); // VALOR INCIAL
  CubeTypeDao cubeTypeDao = CubeTypeDao();
  SessionDao sessionDao = SessionDao();
  List<Session> sessions = [];
  UserDao userDao = UserDao();

  Session session = Session.empty();

  void onCubeTypeSelected(CubeType selectedCubeType) {
    setState(() {
      cubeType = selectedCubeType;
    });
    // SE ACTUALIZA EL TIPO DE CUBO EN EL PROVIDER
    final currentCubeType = Provider.of<CurrentCubeType>(this.context, listen: false);
    currentCubeType.setCubeType(cubeType); // SE ACTUALIZA EL ESTADO GLOBAL
    print(currentCubeType);
  }

  void onSessionSelected(String sessionName) {
    setState(() {
      session.sessionName = sessionName;
    });
  }

  Future<String?> initSession() async {
    UserDao userDao = UserDao();
    SessionDao sessionDao = SessionDao();

    try {
      // OBTENEMOS LOS DATOS DEL USUARIO ACTUAL
      final currentUser = context.read<CurrentUser>().user;

      if (currentUser == null) {
        DatabaseHelper.logger.e("El usuario actual es nulo");
        return null;
      }

      // OBTENER EL ID DEL USUARIO POR SU NOMBRE
      int idUser = await userDao.getIdUserFromName(currentUser.username);

      if (idUser == -1) {
        DatabaseHelper.logger.e("Error al conseguir el ID del usuario actual.");
        return null;
      } // SI RETORNA -1, MOSTRAMOS UN MENSAJE DE ERROR

      // BUSCAR LA SESION DEL USUARIO POR ID Y NOMBRE DE SESION
      Session? aux = await sessionDao.getSessionByUserAndName(idUser, "Normal");

      if (aux != null) {
        // ACTUALIZAMOS EL ESTADO
        setState(() {
          session = aux;
        });
        // RETORNAMOS EL NOMBRE DE LA SESION
        return aux.sessionName;
      } else {
        // MENSAJE DE ERROR
        DatabaseHelper.logger.e(
            "Error al conseguir la sesión por el ID de usuario y el nombre de la sesión.");
        return null;
      } // VERIFICAR SI LA SESION DEVUELTA ES NULA
    } catch (e) {
      DatabaseHelper.logger.e("Error en initSession: $e");
      return null;
    }
  } // METODO PARA INICIAR CON LA SESION "Normal"

  @override
  void initState() {
    super.initState();
    initSession();
  } // AL INICIAR LLAMA A LA FUNCION PARA SETTEAR LA SESION "Normal"

  @override
  Widget build(BuildContext context) {
    // USA MediaQuery PARA OBTENER EL ANCHO DE LA VENTANA
    final screenWidth = MediaQuery.sizeOf(context).width;
    // WIDTH INICIAL DEL CONTAINER DEL HEADER
    double widthContainer = 0;

    if (screenWidth < 380) {
      // SI LA PANTALLA ES MENOR DE 380, EL TAMAÑO DEL CONTAINER SE ESTABLECE EN 245
      widthContainer = 245;
    } else{
      // SI NO, VA AUTOINCREMENTANDO SEGUN EL TAMAÑO DE LA PANTALLA
      widthContainer = screenWidth * 0.75;
    } // SEGUN EL TAMAÑO DE LA PANTALLA, AUMENTA EL TAMAÑO DEL CONTAINER


    return Container(
      width: widthContainer,
      decoration: BoxDecoration(
        color: AppColors.lightVioletColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            const SizedBox(width: 20),
            // CENTRAR EL CONTENIDO DE LA COLUMNA
            Expanded(
              child: Column(
                // ALINEAMOS AL CENTRO
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(
                    cubeType.cubeName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkPurpleColor),
                  ),
                  Text(session.sessionName)
                ],
              ),
            ),

            const SizedBox(width: 5),

            // LOS BOTONES LOS ANCLAMOS A LA PARTE DE LA DERECHA
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  AnimatedIconWidget(
                    // ICONO DE MENU CERRADO/ABIERTO
                    animatedIconData: AnimatedIcons.menu_close,
                    // LE PASA EL CALLBACK
                    onCubeTypeSelected: onCubeTypeSelected,
                  ),

                  const SizedBox(width: 5),

                  IconClass.iconButtonImage(() {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SessionMenu(
                        onSessionSelected: onSessionSelected,
                      ),
                    );
                  }, "assets/session_icon.png", "Choose session"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
