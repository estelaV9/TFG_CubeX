import 'package:esteladevega_tfg_cubex/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/components/session_menu.dart';
import 'package:esteladevega_tfg_cubex/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/state/current_session.dart';
import 'package:esteladevega_tfg_cubex/state/current_user.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dao/cubetype_dao.dart';
import '../model/cubetype.dart';
import '../state/current_cube_type.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
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
