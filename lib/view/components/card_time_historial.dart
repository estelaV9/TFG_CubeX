import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/dao/time_training_dao.dart';
import '../../data/database/database_helper.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../model/time_training.dart';
import '../../view/utilities/app_color.dart';
import '../../viewmodel/current_time.dart';

/// Widget que muestra una lista de tiempos registrados en un cubo de una sesión.
///
/// Este widget utiliza un `GridView` para mostrar los tiempos en forma de tarjetas.
/// Al seleccionar una tarjeta, se muestra un cuadro de diálogo con los detalles del
/// tiempo y la opción de eliminarlo o copiar el scramble con el que se realizó ese tiempo.
///
/// El tiempo se elimina de la base de datos y se actualiza la vista con un mensaje de
/// éxito o error. Además, se implementa un sistema donde los usuarios pueden mantener
/// presionado para seleccionar múltiples tiempos y eliminarlos directamente con el
/// botón flotante que aparece. Si el usuario quiere eliminar un tiempo de la selección
/// solo deberá pulsar la 'x' que aparece cuando se presiona un tiempo.
///
/// Se asegura que esté montado (`mounted`) antes de ejecutar `setState` o acciones con contexto.
class CardTimeHistorial extends StatefulWidget {
  const CardTimeHistorial({Key? key}) : super(key: key);

  @override
  State<CardTimeHistorial> createState() => _CardTimeHistorialState();
}

class _CardTimeHistorialState extends State<CardTimeHistorial> {
  List<TimeTraining> listTimes = [];
  final timeTrainingDao = TimeTrainingDao();
  String scramble = "";
  int? idSession;

  // ATRIBUTO PARA GUARDAR TODOS LOS INDEX DE TIEMPOS QUE EL USUARIO HA SELECCIONADO PARA ELIMINAR
  Set<int> selectedIndex = {};

  /// Método que elimina un tiempo específico de la base de datos.
  ///
  /// Este método obtiene el ID del tiempo a eliminar utilizando el scramble y
  /// el ID de la sesión.
  /// Si se elimina correctamente o si ocurre un error, se muestra un mensaje de éxito.
  ///
  /// Parámetros:
  /// - [isSelectedOnPress]: atributo opcional para saber si el usuario esta eliminando el tiempo
  /// directamente en los detalles del tiempo especifico o si esta eliminando varios tiempos al
  /// mantener presionada cada tiempo.
  Future<void> deleteTime([bool isSelectedOnPress = false]) async {
    if (!isSelectedOnPress) {
      // SE CIERRA EL DIALOGO AL ELIMINAR
      Navigator.of(context).pop();
    } // SI LA LLAMADA AL METODO NO ES CUANDO SE MANTIENE PARA BORRAR, SE CIERRA EL DIALOGO

    final idDeleteTime =
        await timeTrainingDao.getIdByTime(scramble, idSession!);
    if (idDeleteTime == -1) {
      // SI OCURRIO UN ERROR MUESTRA UN SNACKBAR
      AlertUtil.showSnackBarInformation(context, "delete_time_error");
      DatabaseHelper.logger
          .e("No se obtuvo el tiempo por scramble e idSession: $idDeleteTime");
      return;
    } // VERIFICA SI SE HA OBTENIDO BIEN EL ID DEL TIEMPO A ELIMINAR

    final isDeleted = await timeTrainingDao.deleteTime(idDeleteTime);
    if (isDeleted) {
      // SI SE ELIMINO CORRECTAMENTE SE MUESTRA UN SNCAKBAR PARA CONFIRMAR
      AlertUtil.showSnackBarInformation(context, "delete_time_correct");

      // VUELVE A CARGAR LOS TIEMPOS
      _loadTimes();
    } else {
      // SI OCURRIO UN ERROR MUESTRA UN SNACKBAR
      AlertUtil.showSnackBarInformation(context, "delete_time_error");
      DatabaseHelper.logger.e("No se pudo eliminar: $isDeleted");
    }
  } // METODO PARA ELIMINAR EL TIEMPO EN CONCRETO

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  /// Método para cargar los tiempos de la sesión y el tipo de cubo actual.
  ///
  /// Parámetros:
  /// - `currentTime` (String, opcional): se utiliza para filtrar la busqueda por
  ///   tiempo o por comentario, si se proporciona.
  ///
  /// Este método obtiene el ID del usuario actual, la sesión actual y el
  /// tipo de cubo actual.
  /// Luego, recupera los tiempos de entrenamiento asociados a esa sesión y
  /// cubo, y actualiza la lista de tiempos.
  ///
  /// Se asegura que esté montado (`mounted`) antes de ejecutar `setState` o acciones con contexto.
  Future<void> _loadTimes([CurrentTime? currentTime]) async {
    // VERIFICA SI EL WIDGET SIGUE MONTADO (SI ESTAACTIVO EN PANTALLA)
    // SI NO LO ESTA, SE SALE PARA EVITAR ERRORES AL USAR CONTEXT O setState
    // (asi no salen los errores cada vez que entra al timer)
    if (!mounted) return;

    // GUARDAR CONTEXTO AL PRINCIPIO
    final currentSession = context.read<CurrentSession>().session;
    final currentCube = context.read<CurrentCubeType>().cubeType;

    UserDao userDao = UserDao();
    CubeTypeDao cubeTypeDao = CubeTypeDao();
    SessionDao sessionDao = SessionDao();

    // OBTENER EL ID DEL USUARIO
    int? idUser = await userDao.getUserId(context);

    CubeType? cubeType = await cubeTypeDao.getCubeTypeByNameAndIdUser(
        currentCube!.cubeName, idUser);
    if (cubeType.idCube == -1) {
      DatabaseHelper.logger.e("Error al obtener el tipo de cubo.");
      return;
    } // VERIFICAR QUE SI RETORNA EL TIPO DE CUBO CORRECTAMENTE

    // OBJETO SESION CON EL ID DEL USUARIO, NOMBRE Y TIPO DE CUBO
    Session? session = await sessionDao.getSessionByUserCubeName(
        idUser!, currentSession!.sessionName, cubeType.idCube);

    if (session!.idSession != -1) {
      // perdon por el bucle si no tiene tiempos
      final List<TimeTraining> times;

      if (currentTime?.searchComment != null) {
        // SI EL USUARIO HA INTRODUCIDO UN COMENTARIO, SE BUSCA POR COMENTARIOS
        times = await timeTrainingDao.getTimesOfSession(
            session.idSession,
            currentTime?.searchComment,
            null,
            currentTime?.dateAsc,
            currentTime?.timeAsc);
      } else if (currentTime?.searchTime != null) {
        // SI EL USUARIO HA INTRODUCIDO UN TIEMPO, SE BUSCA POR TIEMPO
        times = await timeTrainingDao.getTimesOfSession(
            session.idSession,
            null,
            currentTime?.searchTime,
            currentTime?.dateAsc,
            currentTime?.timeAsc);
      } else {
        // SI NO SE HA INTRODUCIDO NI COMENTARIO NI TIEMPO, SE BUSCAN TODOS LOS TIEMPOS DE LA SESION
        times = await timeTrainingDao.getTimesOfSession(session.idSession, null,
            null, currentTime?.dateAsc, currentTime?.timeAsc);
      }

      // ANTES DE HACER UN SetState VERIFICAMOS SI EL WIDGET SIGUE MONTADO
      if (!mounted) return;

      setState(() {
        listTimes = times;
      });
    } else {
      DatabaseHelper.logger.e(
          "No se encontro el id de la session actual: ${session.toString()}");
    } // SE VERIFICA QUE SE BUSCO BIEN EL ID
  } // CARGAR LOS TIEMPOS DE UNA SESION DE UN TIPO DE CUBO

  @override
  Widget build(BuildContext context) {
    final currentTime = context.read<CurrentTime>();
    _loadTimes(currentTime);
    // USA MediaQuery PARA OBTENER EL ANCHO DE LA VENTANA
    final screenWidth = MediaQuery.sizeOf(context).width;

    // DEFINE LA CANTIDAD DE COLUMNAS BASADA EN EL ANCHO DE LA VENTANA
    int crossAxisCount;
    // TAMAÑO DE LA LETRA DEPENDIENTO EL TAMAÑO DE LA PANTALLA
    double fontSize;
    if (screenWidth < 300) {
      crossAxisCount = 3; // TRES COLUMNA PARA MENOS DE 300PX
      fontSize = 8;
    } else if (screenWidth < 1000) {
      crossAxisCount = 4; // CUATRO COLUMNAS ENTRE 300PX Y 1000PX
      fontSize = 16;
      if (screenWidth > 700) {
        fontSize = 18;
      } // SI LA PANTALLA ES MAYOR QUE 800, AUMENTA UN POCO EL TAMAÑO DE LA LETRA
    } else {
      crossAxisCount = 5; // CINCO COLUMNAS PARA MAS DE 1000PX
      fontSize = 20;
    }

    return Scaffold(
      // COLOR DEL FONDO TRANSPARENTE
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4,
        ),
        itemCount: listTimes.length,
        itemBuilder: (context, index) {
          final time = listTimes[index];
          // VERIFICA SI EL TIEMPO ACTUAL ESTA SELECCIONADO PARA CAMBIAR SU ESTADO VISUAL
          final isSelected = selectedIndex.contains(index);
          return SizedBox(
            height: 50,
            child: GestureDetector(
              onTap: () {
                if (selectedIndex.isNotEmpty) {
                  // SI HAY TIEMPOS SELECCIONADOS, AÑADE O ELIMINA ESE TIEMPO DE LA LISTA DE SELECCIONADOS
                  setState(() {
                    isSelected
                        ? selectedIndex.remove(index)
                        : selectedIndex.add(index);
                  });
                } else {
                  // SI NO HAY ELEMENTOS SELECCIONADOS, SE MUESTRA LOS DETALLES DEL TIEMPO
                  setState(() {
                    scramble = time.scramble;
                    idSession = time.idSession!;
                  });
                  AlertUtil.showDetailsTime(context, deleteTime, time);
                }
              },
              onLongPress: () {
                // CUANDO EL USUARIO MANTENGA PULSADO SE AÑADIRA EL TIEMPO A LA LISTA DE SELECCIONADOS
                setState(() {
                  selectedIndex.add(index);
                });
              },
              child: Stack(
                children: [
                  // CONTAINER ANIMADO PARA SI ESTA SELECCIONADO O NO
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: AppColors.lightVioletColor,
                      border: Border.all(
                        // SI ESTA SELECCIONADO MUESTRA UN BORDE COLOR ROJO
                        color: isSelected
                            ? Colors.red.withOpacity(0.8)
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        // SI EL TIEMPO TIENE UNA PENALIZACION DE DNF, SE ESTABLECE EN VEZ DEL TIEMPO
                        time.penalty == "DNF"
                            ? time.penalty.toString()
                            : time.timeInSeconds.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (isSelected)
                    // SI ESTA SELECCIONADO
                    Positioned(
                      top: 5,
                      right: 5,
                      child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          child: IconClass.iconButton(context, () {
                            setState(() {
                              scramble = time.scramble;
                              idSession = time.idSession!;
                              // QUITAMOS EL ELEMENTO SELECCIONADO
                              selectedIndex.remove(index);
                            });
                          }, "close_selected_time", Icons.close, Colors.white,
                              14, EdgeInsets.zero)),
                    ),
                ],
              ),
            ),
          );
        },
      ),

      // BOTON PARA LA ELIMINACION MULTIPLE DE LOS TIEMPOS
      floatingActionButton: selectedIndex.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                  tooltip: Internationalization.internationalization
                      .getLocalizations(
                          context, "delete_selected_times_button"),
                  onPressed: () async {
                    // ELIMINA TODOS LOS ELEMENTOS SELECCIONADOS
                    for (var index in selectedIndex.toList()) {
                      scramble = listTimes[index].scramble;
                      idSession = listTimes[index].idSession!;
                      await deleteTime(true);
                    }
                    // LIMPIA LA LISTA DE SELECCIONADOS
                    setState(() {
                      selectedIndex.clear();
                    });
                  },
                  icon: IconClass.iconMaker(context, Icons.delete, "delete"),
                  label: Text(
                      "${Internationalization.internationalization.getLocalizations(context, "delete")} (${selectedIndex.length})"),
                  backgroundColor: AppColors.deleteAccount,
                ),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
