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

class CardTimeHistorial extends StatefulWidget {
  const CardTimeHistorial({Key? key}) : super(key: key);

  @override
  State<CardTimeHistorial> createState() => _CardTimeHistorialState();
}

class _CardTimeHistorialState extends State<CardTimeHistorial> {
  List<TimeTraining> listTimes = [];

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  Future<void> _loadTimes() async {
    final timeTrainingDao = TimeTrainingDao();
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
              AlertUtil.showDetailsTime(context, listTimes[index]);
            },
            child: Card(
              color: AppColors.lightVioletColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Center(
                child: Text(
                  "${time.timeInSeconds.toStringAsFixed(2)}",
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
