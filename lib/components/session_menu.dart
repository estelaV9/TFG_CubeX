import 'package:esteladevega_tfg_cubex/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database_helper.dart';
import '../model/session.dart';
import '../state/current_user.dart';

class SessionMenu extends StatefulWidget {
  const SessionMenu({super.key});

  @override
  State<SessionMenu> createState() => _SessionMenuState();
}

class _SessionMenuState extends State<SessionMenu> {
  List<Session> sessions = [];
  SessionDao sessionDao = SessionDao();
  String sessionName = "";

  void getSessionOfUser() async {
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;
    if (currentUser != null) {
      List<Session>? result =
          await sessionDao.getSessionOfUser(currentUser.idUser!);
      if (result != null) {
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
    getSessionOfUser();
  }

  void sessionList() async {
    final result = await sessionDao.sessionList();
    setState(() {
      sessions = result;
    });
    DatabaseHelper.logger.i("obtenidas: ${result.toString()}");
  }

  void createNewSession() async {
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
      // SE MUESTRA UN ALERT DE CONFIRMACION
      AlertUtil.showSnackBarInformation(context, "Session added successful");
    } // VALIDA SI LA SESION AÑADIDO ES NULO O NO
  } // METODO PARA CREAR UNA NUEVA SESION

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x00000000), // SIN FONDO
      body: Container(
        width: 245,
        decoration: BoxDecoration(
          color: AppColors.purpleIntroColor,
          borderRadius: BorderRadius.circular(30),
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
                      fontSize: 18),
                ), // TITULO

                // ESPACIO ENTRE EL TITULO Y EL LISTVIEW
                const SizedBox(height: 10),

                // EXPANDIR EL LISTVIEW
                Expanded(
                  child: GridView.count(
                    // UNA COLUMNA
                    crossAxisCount: 1,
                    // ESPACIADO HORIZONTAL ENTRE CONTAINERS
                    crossAxisSpacing: 10,
                    // ESPACIADO VERTICAL
                    mainAxisSpacing: 10,

                    // GENERAR LOS TIPOS DE CUBO QUE HAY EN LA BASE DE DATOS
                    children: sessions.map((session) {
                      // GESTURE DETECTOR PARA CUANDO PULSE EL TIPO DE CUBO
                      return GestureDetector(
                        /// cuando pulsa, se establece la sesion a la elegida y se ceirra
                        onTap: () {
                          setState(() {
                            // SE ACTUALIZA EL NOMBRE DE LA SESION ACTUAL ELEGIDA
                            sessionName == session.sessionName;
                          });
                          print(sessionName);
                        },
                        child: Container(
                          // MARGEN ENTRE SESION Y SESION
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          height: 50,
                          color: Colors.grey,
                          child: Center(
                              // SE MUESTRA LOS NOMBRES DE LA SESIONES
                              child: Text(session.sessionName)),
                        ),
                      );
                    }).toList(),
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
