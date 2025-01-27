import 'package:esteladevega_tfg_cubex/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:esteladevega_tfg_cubex/state/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database_helper.dart';
import '../model/session.dart';
import '../state/current_user.dart';

class SessionMenu extends StatefulWidget {
  // FUNCION PARA ENVIAR LA SESION SELECCIONADA AL COMPONENTE QUE CREA
  // EL SessionMenu
  final void Function(String sessionName) onSessionSelected;

  const SessionMenu({
    super.key,
    required this.onSessionSelected,
  });

  @override
  State<SessionMenu> createState() => _SessionMenuState();
}

class _SessionMenuState extends State<SessionMenu> {
  List<Session> sessions = [];
  SessionDao sessionDao = SessionDao();
  UserDao userDao = UserDao();
  CubeTypeDao cubeTypeDao = CubeTypeDao();
  String sessionName = "";

  Future<void> getSessionOfUser() async {
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;

    if (currentUser != null) {
      // OBTENER EL ID DEL USUARIO QUE ENTRO EN LA APP
      int idUser = await userDao.getIdUserFromName(currentUser.username);
      // BUSCAR SESION POR ID DE USUARIO
      List<Session> result = await sessionDao.getSessionOfUser(idUser);

      if (result.isNotEmpty) {
        setState(() {
          sessions = result;
        });
      } else {
        // MENSAJE INTERNO DE ERROR
        DatabaseHelper.logger.e("Lista de sesiones nula");
      }
    } else {
      // MENSAJE INTERNO DE ERROR
      DatabaseHelper.logger.e("Current user nulo");
    }
  } // METODO PARA SETTEAR EL NUMERO DE SESIONES DE UN USUARIO

  @override
  void initState() {
    super.initState();
    sessionList();
  }

  void sessionList() async {
    List<Session> result = await sessionDao.sessionList();
    setState(() {
      sessions = result;
    });
    DatabaseHelper.logger.i("obtenidas: ${result.toString()}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void createNewSession() async {
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;

    // SE OBTIENE EL TIPO DE CUBO ACTUAL
    CubeType? selectedCubeType = context.read<CurrentCubeType>().cubeType;
    int idCubeType = selectedCubeType?.idCube ?? -1;
    print(idCubeType);

    String? newSession = await AlertUtil.showAlertForm(
        "Create a new session",
        "Please enter a name for your new session",
        "Type the session name",
        context);

    if (newSession == null) {
      // MENSAJE DE ERROR POR SI DEJA EL FORMULARIO VACIO
      AlertUtil.showSnackBarError(
          context, "Please add a session name that isn't empty.");
    } else {
      setState(() {
        sessionName = newSession;
      }); // SE SETTEA EL NOMBRE DE LA SESSION AL AÑADIDO

      if (currentUser != null) {
        // OBTENER EL ID DEL USUARIO QUE ENTRO EN LA APP
        int idUser = await userDao.getIdUserFromName(currentUser.username);
        print('********************** $idUser');
        print('********************** $currentUser');

        Session newSession = Session(
            idUser: idUser,
            sessionName: sessionName,
            idCubeType: idCubeType);
        // INSERTAMOS LA NUEVA SESIÓN EN LA BASE DE DATOS
        bool sessionInserted = await sessionDao.insertSession(newSession);

        if (sessionInserted) {
          // SE MUESTRA UN ALERT DE CONFIRMACION
          AlertUtil.showSnackBarInformation(
              context, "Session added successfully");
          sessionList(); // RECARGAMOS LA LISTA DE SESIONES
        } else {
          // MENSAJE DE ERROR SI LA SESION NO SE PUDO GUARDAR
          AlertUtil.showSnackBarError(
              context, "Failed to create the session. Please try again.");
        } // VALIDAR SI SE HA INSERTADO BIEN
      } else {
        // MENSAJE INTERNO DE ERROR
        DatabaseHelper.logger.e("Current user nulo");
      }
    } // VALIDA SI LA SESION AÑADIDO ES NULO O NO
  } // METODO PARA CREAR UNA NUEVA SESION

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00000000), // SIN FONDO
      body: Container(
        decoration: const BoxDecoration(
          // SE LE AGREGA BORDE CIRCULAR A LA PARTE DE ARRIBA SOLO
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.purpleIntroColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter, // CENTRAR EL TEXTO
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // CENTRADO
              children: [
                const Text(
                  "Select a session",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurpleColor,
                      fontSize: 25),
                ), // TITULO

                // ESPACIO ENTRE EL TITULO Y EL DIVIDER
                const SizedBox(height: 8),

                // LINEA DIVISORIA ENTRE EL TITULO Y EL ListView
                const Divider(
                  height: 10,
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                  color: AppColors.darkPurpleColor,
                ),

                // ESPACIO ENTRE EL DIVIDER Y EL GridView
                const SizedBox(height: 10),

                // ESPACIO ENTRE EL TITULO Y EL LISTVIEW
                const SizedBox(height: 10),

                // EXPANDIR EL LISTVIEW
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightVioletColor,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    // LISTVIEW BUILDER CON LAS SESIONES
                    child: ListView.builder(
                      // TOTAL SESIONES
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // NOMBRE DE LA SESION
                          title: Column(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    sessions[index].sessionName,
                                    style: const TextStyle(fontSize: 17),
                                  )),
                              const Divider(
                                height: 10,
                                thickness: 2,
                                indent: 10,
                                endIndent: 10,
                                color: AppColors.purpleA172de,
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              widget.onSessionSelected(
                                  sessions[index].sessionName);
                              // SE CIERRA EL MENU UNA VEZ ELIJA
                              Navigator.of(context).pop();
                            }); // CUANDO PULSE LA SESION, SE "ENVIARA" LA SESION ELEGIDA AL CONTENEDOR PRINCI
                          }, // CUANDO PULSA
                        );
                      },
                    ),
                  ),
                ),

                // ESPACIO ENTRE EL LISTVIEW Y EL BOTON
                const SizedBox(height: 10),

                // BOTON PARA CREAR NUEVA SESION
                ElevatedButton(
                    onPressed: () {
                      createNewSession();
                    },
                    child: const Text("Create a new session"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
