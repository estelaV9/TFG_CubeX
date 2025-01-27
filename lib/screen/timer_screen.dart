import 'dart:math';

import 'package:esteladevega_tfg_cubex/components/cube_header_container.dart';
import 'package:esteladevega_tfg_cubex/components/scramble_container.dart';
import 'package:esteladevega_tfg_cubex/navigation/app_drawer.dart';
import 'package:esteladevega_tfg_cubex/screen/show_time_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/Icon/icon.dart';
import '../dao/session_dao.dart';
import '../dao/time_training_dao.dart';
import '../dao/user_dao.dart';
import '../database/database_helper.dart';
import '../model/time_training.dart';
import '../state/current_user.dart';
import '../utilities/ScrambleGenerator.dart';
import '../utilities/app_color.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TextStyle style = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.darkPurpleColor);

  // VALORES DE LAS ESTADISTICAS DE LA SESION
  var averageValue = "--:--.--";
  var pbValue = "--:--.--";
  var worstValue = "--:--.--";
  var countValue = "--:--.--";
  var ao5Value = "--:--.--";
  var ao12Value = "--:--.--";
  var ao50Value = "--:--.--";
  var ao100Value = "--:--.--";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // TIEMPO QUE RECIBE DDESDE LA CLASE ShowTimeScreen
  String _finalTime = "0.00";

  // KEY DEL ScrambleContainer
  final GlobalKey<ScrambleContainerState> _scrambleKey = GlobalKey<ScrambleContainerState>();
  Scramble scramble = Scramble();
  // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
  int random = (Random().nextInt(25 - 20 + 1) + 20);

  void _openShowTimerScreen(BuildContext context) async {
    // ABRIR LA PANTALLA DE SHOWTIME Y ESPERAR EL RESULTADO
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShowTimeScreen(),
      ),
    );

    // SI EL RESULTADO NO ES NULO SE ACTUALIZA EL TIEMPO
    if (result != null) {
      setState(() {
        _finalTime = result; // ACTUALIZAR TIEMPO
      });

      // SE ACTUALIZA EL SCRAMBLE UNA VEZ TEMINADO EL TIEMPO DE RESOLUCION
      _scrambleKey.currentState?.updateScramble();

      // GUARDAR EL TIEMPO QUE HA HECHO
      await _saveTimeToDatabase(double.parse(result));
    }
  } // METODO PARA ABRIR LA PANTALLA DE MOSTRAR EL TIEMPO


  Future<void> _saveTimeToDatabase(double timeInSeconds) async {
    final userDao = UserDao();
    final sessionDao = SessionDao();
    final timeTrainingDao = TimeTrainingDao();

    try {
      // OBTENER EL USUARIO ACTUAL
      final currentUser = context.read<CurrentUser>().user;
      // OBTENER EL ID DEL USUARIO
      int idUser = await userDao.getIdUserFromName(currentUser!.username);
      if (idUser == -1) {
        DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
        return;
      } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

      // OBTENER EL ID DE LA SESION ACTUAL (por ahora la de por defecto)
      int idSession = await sessionDao.searchIdSessionByNameAndUser(idUser, "Normal");

      /// falta OBTENER EL SCRAMBLE ACTUAL


      final timeTraining = TimeTraining(
        idSession: idSession,
        scramble: "fjnsdkak",
        timeInSeconds: timeInSeconds,
        comments: null,
        penalty: "none",
      ); // CREAR OBJETO TimeTraining

      // INSERTAR EL TIEMPO EN LA BASE DE DATOS
      final success = await timeTrainingDao.insertNewTime(timeTraining);

     // MOSTRAR UNA LISTA CON LOS TIEMPOS
      final result = await timeTrainingDao.getTimesOfSession(idSession);
      DatabaseHelper.logger.i("obtenidas: \n${result.join('\n')}");

      if (success) {
        DatabaseHelper.logger.i("Tiempo guardado correctamente.");
      } else {
        DatabaseHelper.logger.e("Error al guardar el tiempo.");
      } // VERIFICAR QUE SI SE INSERTO CORRECTAMENTE
    } catch (e) {
      DatabaseHelper.logger.e("Error al guardar el tiempo en la base de datos: $e");
    }
  } // METODO PARA GUARDAR EL TIEMPO REALIZADO


  void logicComment() {} // METODO PARA CUANDO PULSE EL ICONO DE COMENTARIOS

  void
      logicDeleteTime() {} // METODO PARA CUANDO PULSE EL ICONO DE ELIMINAR TIEMPO

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // KEY PARA CONTROLLAR EL SCAFFOLD PARA EL DRAWER
      drawer: const AppDrawer(), // DRAWER
      body: Stack(
        children: [
          // FONDO DEGRADADO
          Positioned.fill(
              child: Container(
            decoration: const BoxDecoration(
              // COLOR DEGRADADO PARA EL FONDO
              gradient: LinearGradient(
                begin: Alignment.topCenter, // DESDE ARRIBA
                end: Alignment.bottomCenter, // HASTA ABAJO
                colors: [
                  // COLOR DE ARRIBA DEL DEGRADADO
                  AppColors.upLinearColor,
                  // COLOR DE ABAJO DEL DEGRADADO
                  AppColors.downLinearColor,
                ],
              ),
            ),
          )),

          // BOTON DE CONFIGURACION ARRIBA A LA IZQUIERDA
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer(); // ABRE EL DRAWER
                },
                icon: IconClass.iconMaker(Icons.settings, "Settings", 30)),
          ),

          // CONTAINER DEL TIPO DE CUBO Y LA SESION UN POCO MAS ABAJO A LA DERECHA
          const Positioned(
            top: 40,
            right: 20,
            child: CubeHeaderContainer(),
          ),

          // CONTAINER DEL SCRAMBLE
          Positioned(
            top: 110,
            right: 20,
            left: 20,
            // SE PASA LA CLAVE DEL SCRMABLE PARA QUE FUNCIONE
            child: ScrambleContainer(key: _scrambleKey),
          ),

          // .fill PARA QUE SE EXPANDA EL TIMER Y SIGA QUEDANDOSE EN EL CENTRO
          Positioned.fill(
            top: 250, // PARA QUE SE COLOQUE JUSTO DESPUES DEL SCRAMBLE
            child: GestureDetector(
              onTap: () {
                _openShowTimerScreen(context);
              }, // CUANDO MANTIENE PULSADO ABRE LA PANTALLA DE MOSTRAR TIMER
              child: Column(
                children: [
                  Container(
                    padding:
                        // TODO_EL ESPACIO QUE OCUPA EL ESPACIO DEL TIMER
                        const EdgeInsets.symmetric(
                            vertical: 80, horizontal: 20),
                    child: Column(
                      // SE CENTRA
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _finalTime,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkPurpleColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconClass.iconButton(logicComment, "Add comments",
                                Icons.add_comment_rounded),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "DNF",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkPurpleColor,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "+2",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkPurpleColor,
                                  ),
                                )),
                            IconClass.iconButton(
                                logicDeleteTime, "Delete time", Icons.close),
                          ],
                        )
                      ],
                    ),
                  ),

                  // EXPANDE EL CONTENEDOR CON LOS TEXTOS PARA QUE OCUPE TODO_EL ESPACIO
                  // DISPONIBLE ENTRE EL TIMER Y LOS TEXTOS
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              // ESPACIO ENTRE LAS COLUMNAS
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // COLUMNA IZQUIERDA
                                Column(
                                  // EMPIEZA DESDE ARRIBA A LA IZQUIERDA
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Average: $averageValue",
                                      style: style,
                                    ),
                                    Text(
                                      "Pb: $pbValue",
                                      style: style,
                                    ),
                                    Text(
                                      "Worst: $worstValue",
                                      style: style,
                                    ),
                                    Text(
                                      "Count: $countValue",
                                      style: style,
                                    ),
                                  ],
                                ),

                                //COLUMNA DERECHA
                                Column(
                                  // EMPIEZA DESDE ARRIBA A LA DERECHA
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Ao5: $ao5Value",
                                      style: style,
                                    ),
                                    Text(
                                      "Ao12: $ao12Value",
                                      style: style,
                                    ),
                                    Text(
                                      "Ao50: $ao50Value",
                                      style: style,
                                    ),
                                    Text(
                                      "Ao100: $ao100Value",
                                      style: style,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
