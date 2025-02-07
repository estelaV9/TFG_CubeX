import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/dao/time_training_dao.dart';
import '../../data/database/database_helper.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../model/time_training.dart';
import '../../utilities/app_color.dart';
import '../../viewmodel/current_user.dart';

/// Widget que muestra una lista de tiempos registrados en un cubo de una sesión.
///
/// Este widget utiliza un `GridView` para mostrar los tiempos en forma de tarjetas.
/// Al seleccionar una tarjeta, se muestra un cuadro de diálogo con los detalles del
/// tiempo y la opción de eliminarlo o copiar el scramble con el que se realizó ese tiempo.
///
/// El tiempo se elimina de la base de datos y se actualiza la vista con un mensaje de
/// éxito o error.
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

  /// Método que elimina un tiempo específico de la base de datos.
  ///
  /// Este método obtiene el ID del tiempo a eliminar utilizando el scramble y
  /// el ID de la sesión.
  /// Si se elimina correctamente o si ocurre un error, se muestra un mensaje de éxito.
  Future<void>  deleteTime() async{
    // SE CIERRA EL DIALOGO AL ELIMINAR
    Navigator.of(context).pop();

    final idDeleteTime = await timeTrainingDao.getIdByTime(scramble, idSession!);
    if(idDeleteTime == -1){
      // SI OCURRIO UN ERROR MUESTRA UN SNACKBAR
      AlertUtil.showSnackBarInformation(context, "delete_time_error");
      DatabaseHelper.logger.e("No se obtuvo el tiempo por scramble e idSession: $idDeleteTime");
      return;
    } // VERIFICA SI SE HA OBTENIDO BIEN EL ID DEL TIEMPO A ELIMINAR

    final isDeleted = await timeTrainingDao.deleteTime(idDeleteTime);
    if(isDeleted){
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
  /// Este método obtiene el ID del usuario actual, la sesión actual y el
  /// tipo de cubo actual.
  /// Luego, recupera los tiempos de entrenamiento asociados a esa sesión y
  /// cubo, y actualiza la lista de tiempos.
  Future<void> _loadTimes() async {
    UserDao userDao = UserDao();
    CubeTypeDao cubeTypeDao = CubeTypeDao();
    SessionDao sessionDao = new SessionDao();

    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
      return;
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    // OBTENER LA SESSION Y EL TIPO DE CUBO ACTUAL
    final currentSession = context.read<CurrentSession>().session;
    final currentCube = context.read<CurrentCubeType>().cubeType;

    CubeType? cubeType = await cubeTypeDao.cubeTypeDefault(currentCube!.cubeName);
    if (cubeType == null) {
      DatabaseHelper.logger.e("Error al obtener el tipo de cubo.");
      return;
    } // VERIFICAR QUE SI RETORNA EL TIPO DE CUBO CORRECTAMENTE

    // OBJETO SESION CON EL ID DEL USUARIO, NOMBRE Y TIPO DE CUBO
    Session? session =
    await sessionDao.getSessionByUserCubeName(
        idUser, currentSession!.sessionName, cubeType.idCube);

    if (session!.idSession != -1) {
      // perdon por el bucle si no tiene tiempos
      final times =
      await timeTrainingDao.getTimesOfSession(session.idSession); // ID DE SESION
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
    _loadTimes();
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

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: listTimes.length,
      itemBuilder: (context, index) {
        final time = listTimes[index];
        return SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: (){
              setState(() {
                scramble = listTimes[index].scramble;
                idSession = listTimes[index].idSession!;
              }); // SETTEAMOS LOS DATOS DEL SCRAMBLE E ID
              AlertUtil.showDetailsTime(context, deleteTime, listTimes[index]);
            },
            child: Card(
              color: AppColors.lightVioletColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Center(
                child: Text(
                  time.timeInSeconds.toStringAsFixed(2),
                  style:
                      TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
