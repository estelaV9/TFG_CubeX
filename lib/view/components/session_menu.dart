import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/time_training_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/database_helper.dart';
import '../../model/session.dart';
import '../utilities/internationalization.dart';
import '../../viewmodel/current_session.dart';
import '../../viewmodel/current_statistics.dart';
import '../../viewmodel/current_user.dart';
import '../screen/timer_screen.dart';

/// Menú de sesión.
///
/// Esta clase muestra el menú de sesiones de ese tipo de cubo para el usuario.
/// Permite seleccionar una sesión existente o crear una nueva sesión.
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
  /// Lista de sesiones asociadas al usuario y al tipo de cubo.
  List<Session> sessions = [];
  SessionDao sessionDao = SessionDao();
  UserDao userDao = UserDao();
  CubeTypeDao cubeTypeDao = CubeTypeDao();
  TimeTrainingDao timeTrainingDao = TimeTrainingDao();
  String sessionName = "";

  @override
  void initState() {
    super.initState();
    sessionList();
  }

  /// Filtra las sesiones por el tipo de cubo y las obtiene para el usuario actual.
  void sessionList() async {
    // OBTENEMOS EL CUBO SELECCIONADO
    CubeType? selectedCubeType = context.read<CurrentCubeType>().cubeType;
    int idCubeType = selectedCubeType?.idCube ?? -1;

    if (idCubeType == -1) {
      DatabaseHelper.logger.e("No se ha seleccionado ningún tipo de cubo.");
      return;
    }
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;

    if (currentUser != null) {
      // OBTENER EL ID DEL USUARIO QUE ENTRO EN LA APP
      int idUser = await userDao.getIdUserFromName(currentUser.username);

      // FILTRAMOS LAS SESIONES POR EL ID DEL CUBO
      List<Session> result =
          await sessionDao.searchSessionByCubeAndUser(idUser, idCubeType);

      setState(() {
        sessions = result;
      });

      DatabaseHelper.logger.i("Sesiones filtradas: \n${result.join('\n')}");
    } else {
      DatabaseHelper.logger.e("No se encontró usuario");
      return null;
    }
  } // METODO PARA LISTAR LAS SESIONES DE UN USUARIO Y DE UN TIPO DE CUBO

  @override
  void dispose() {
    super.dispose();
  }

  /// Método para crear una nueva sesión y agregarla a la base de datos.
  void createNewSession() async {
    // OBTENEMOS LOS DATOS DEL USUARIO
    final currentUser = context.read<CurrentUser>().user;

    // SE OBTIENE EL TIPO DE CUBO ACTUAL
    CubeType? selectedCubeType = context.read<CurrentCubeType>().cubeType;
    int idCubeType = selectedCubeType?.idCube ?? -1;
    print(idCubeType);

    String? newSession = await AlertUtil.showAlertForm(
        "create_new_session_label",
        "create_new_session_hint",
        "type_session_name",
        context);

    if (newSession == null) {
      // MENSAJE DE ERROR POR SI DEJA EL FORMULARIO VACIO
      AlertUtil.showSnackBarError(
          context, "add_session_name_empty");
    } else {
      setState(() {
        sessionName = newSession;
      }); // SE SETTEA EL NOMBRE DE LA SESSION AL AÑADIDO

      if (currentUser != null) {
        // OBTENER EL ID DEL USUARIO QUE ENTRO EN LA APP
        int idUser = await userDao.getIdUserFromName(currentUser.username);

        Session newSession = Session(
            idUser: idUser, sessionName: sessionName, idCubeType: idCubeType);
        // INSERTAMOS LA NUEVA SESIÓN EN LA BASE DE DATOS
        bool sessionInserted = await sessionDao.insertSession(newSession);

        if (sessionInserted) {
          // SE MUESTRA UN ALERT DE CONFIRMACION
          AlertUtil.showSnackBarInformation(
              context, "session_added_successful");
          sessionList(); // RECARGAMOS LA LISTA DE SESIONES
        } else {
          // MENSAJE DE ERROR SI LA SESION NO SE PUDO GUARDAR
          AlertUtil.showSnackBarError(
              context, "failed_create_session");
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
                Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  "select_session_label",
                  "select_session_label",
                  "select_session_label",
                  const TextStyle(
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
                          onLongPress: () {
                            // SI MANTIENE PULSADO LE SALDRA LA OPCION DE ELIMINAR LA SESION
                            AlertUtil.showDeleteSessionOrCube(
                                context,
                                "delete_session_label",
                                "delete_session_hint",
                                () async {
                              String sessionName = sessions[index].sessionName;
                              // OBTENEMOS LOS DATOS DEL USUARIO
                              final currentUser =
                                  context.read<CurrentUser>().user;
                              // CONSEGUIMOS EL ID DEL USUAIRO ACTUAL
                              int idUser = await userDao
                                  .getIdUserFromName(currentUser!.username);
                              if (idUser == -1) {
                                // SI NO SE OBTIENE EL ID DE USUARIO SE MUESTRA UN MENSAJE
                                DatabaseHelper.logger.e(
                                    "No se pudo conseguir el id del usuario actual $idUser");
                              } else {
                                // PILLAMOS EL ID DE LA SESION
                                int idSession = await sessionDao
                                    .searchIdSessionByNameAndUser(
                                        idUser, sessionName);
                                if (idSession == -1) {
                                  // SI NO SE ENCUENTRA EL ID DE LA SESION S EMUESTRA UN MENSAJE
                                  AlertUtil.showSnackBarError(
                                      context, "session_not_found");
                                } else {
                                  if (await sessionDao
                                      .deleteSession(idSession)) {
                                    AlertUtil.showSnackBarInformation(
                                        context, "session_deleted_successful");
                                    sessionList(); // VOLVEMOS A CARGAR LAS SESIONES
                                  } else {
                                    AlertUtil.showSnackBarError(context,
                                        "session_deletion_failed");
                                  } // SE ELIMINA LA SESION
                                } // BUSCAR EL ID DE LA SESION
                              } // BUSCAR EL ID DEL USUARIO
                            });
                          },
                          onTap: () async {
                            // OBTENER EL USUARIO ACTUAL
                            final currentUser = context.read<CurrentUser>().user;
                            // OBTENER EL ID DEL USUARIO
                            int idUser = await userDao.getIdUserFromName(currentUser!.username);
                            if (idUser == -1) {
                              DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
                              return;
                            } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO


                            // GUARDAR LOS DATOS DE LA SESION EN EL ESTADO GLOBAL
                            final currentSession = Provider.of<CurrentSession>(
                                this.context,
                                listen: false);
                            // SE ACTUALIZA EL ESTADO GLOBAL
                            currentSession.setSession(sessions[index]);

                            // BUSCAMOS EL TIPO DE CUBO QUE YA ESTABA ESTABLECIDO
                            final tipoCuboEstablecido = context.read<CurrentCubeType>().cubeType;
                            final cubo = await cubeTypeDao.cubeTypeDefault(tipoCuboEstablecido!.cubeName);

                            // BUSCAMOS EL TIPO DE CUBO QUE TIENE ESA SESION
                            Session? sessionTipoActual =
                              await sessionDao.getSessionByUserCubeName(idUser, currentSession.session!.sessionName, cubo.idCube);

                            // CUANDO SELECCIONE UNA SESION, SE BUSCA EL TIPO DE CUBO DE ESA SESION
                            // GUARDAR LOS DATOS DEL TIPO DE CUBO EN EL ESTADO GLOBAL
                            final currentCube = Provider.of<CurrentCubeType>(
                                this.context,
                                listen: false);

                            // SE BUSCA ESE TIPO DE CUBO POR ESE ID
                            CubeType? cubeType = await cubeTypeDao.getCubeById(sessionTipoActual!.idCubeType);
                            if(cubeType.idCube != -1){
                              // SE ACTUALIZA EL ESTADO GLOBAL
                              currentCube.setCubeType(cubeType);
                            } else{
                              DatabaseHelper.logger.e("No se encontro el tipo de cubo: ${cubeType.toString()}");
                            } // SE VERIFICA QUE SE HA RETORNADO EL TIPO DE CUBO CORRECTAMENTE

                            var timesList = await timeTrainingDao.getTimesOfSession(sessionTipoActual!.idSession);

                            // GUARDAR LOS DATOS DE LAS ESTADISTICAS EN EL ESTADO GLOBAL
                            final currentStatistics = Provider.of<CurrentStatistics>(
                                this.context, listen: false);
                            // SE ACTUALIZA EL ESTADO GLOBAL
                            currentStatistics.updateStatistics(timesListUpdate: timesList);


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
                    child: Internationalization.internationalization
                        .createLocalizedSemantics(
                      context,
                      "create_new_session_label",
                      "create_new_session_button",
                      "create_new_session_label",
                      const TextStyle(
                          fontSize: 16),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
