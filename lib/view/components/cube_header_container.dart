import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/view/components/session_menu.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_user.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/dao/cubetype_dao.dart';
import '../../model/cubetype.dart';
import '../../viewmodel/current_cube_type.dart';
import 'Icon/animated_icon.dart';

/// Encabezado tipo de cubo y sesión.
///
/// Esta clase se basa en un widget que maneja la visualización y la
/// interacción del encabezado del cubo con el tipo de cubo y la sesión activa.
class CubeHeaderContainer extends StatefulWidget {
  const CubeHeaderContainer({super.key});

  @override
  State<CubeHeaderContainer> createState() => _CubeHeaderContainerState();
}

class _CubeHeaderContainerState extends State<CubeHeaderContainer> {
  /// Tipo de cubo actual, inicializado con un valor por defecto.
  CubeType cubeType = CubeType(idCube: -1, cubeName: "3x3x3"); // VALOR INCIAL
  CubeTypeDao cubeTypeDao = CubeTypeDao();
  SessionDao sessionDao = SessionDao();
  List<Session> sessions = [];
  UserDao userDao = UserDao();

  /// La sesión activa actual, inicializada con una sesión vacía.
  Session session = Session.empty();

  /// Selección de un tipo de cubo.
  ///
  /// Actualiza el estado del widget y el estado global mediante el `Provider`.
  ///
  /// - `selectedCubeType`: El tipo de cubo que el usuario ha seleccionado.
  void onCubeTypeSelected(CubeType selectedCubeType) {
    setState(() {
      cubeType = selectedCubeType;
    });
    // SE ACTUALIZA EL TIPO DE CUBO EN EL PROVIDER
    final currentCubeType = Provider.of<CurrentCubeType>(this.context, listen: false);
    currentCubeType.setCubeType(cubeType); // SE ACTUALIZA EL ESTADO GLOBAL
    print(currentCubeType);
  }

  /// Selección de una sesión.
  ///
  /// - `sessionName`: El nombre de la sesión seleccionada por el usuario.
  void onSessionSelected(String sessionName) {
    setState(() {
      session.sessionName = sessionName;
    });
  }

  /// Método para inicializar la sesión con el nombre "Normal".
  ///
  /// Obtiene los datos del usuario actual, luego busca y establece la sesión activa.
  ///
  /// Devuelve el nombre de la sesión si se encuentra, o `null` si ocurre un error.
  Future<String?> initSession() async {
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
    // OBTENEMOS LA SESION Y EL TIPO DE CUBO ACTUAL
    final currentSession = context.read<CurrentSession>().session;
    final currentCube = context.read<CurrentCubeType>().cubeType;

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
                  // PARA ESCHCAHAR LOS CAMBIOS EN LOS PROVIDERS SE UTILIZA CONSUMER
                  // ASI LA UI SE ACTUALIZA AUTOMATICAMENTE
                  Consumer<CurrentCubeType>(
                    builder: (context, currentCube, child) {
                      return Text(
                        currentCube.cubeType!.cubeName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkPurpleColor
                        ),
                      );
                    },
                  ),

                  Consumer<CurrentSession>(
                    builder: (context, currentSession, child) {
                      return Text(currentSession.session!.sessionName);
                    },
                  ),

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

                  IconClass.iconButtonImage(context, () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SessionMenu(
                        onSessionSelected: onSessionSelected,
                      ),
                    );
                  }, "assets/session_icon.png", "choose_session"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
