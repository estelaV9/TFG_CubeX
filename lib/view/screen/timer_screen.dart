import 'dart:math';

import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/view/components/cube_header_container.dart';
import 'package:esteladevega_tfg_cubex/view/components/scramble_container.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/app_drawer.dart';
import 'package:esteladevega_tfg_cubex/view/screen/show_time_screen.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/utilities/internationalization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../components/Icon/icon.dart';
import '../../data/dao/session_dao.dart';
import '../../data/dao/time_training_dao.dart';
import '../../data/dao/user_dao.dart';
import '../../data/database/database_helper.dart';
import '../../model/time_training.dart';
import '../../viewmodel/current_user.dart';
import '../../utilities/ScrambleGenerator.dart';
import '../../utilities/app_color.dart';

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

  void insertTimes() async {
    final userDao = UserDao();
    final sessionDao = SessionDao();
    final timeTrainingDao = TimeTrainingDao();

    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
      return;
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    // OBTENER EL ID DE LA SESION ACTUAL (por ahora la de por defecto)
    int idSession =
        await sessionDao.searchIdSessionByNameAndUser(idUser, "Normal");
    List<TimeTraining> timeTrainings = [
      TimeTraining(
          idSession: idSession,
          scramble:
              "B F2 D U' L' D' L2 B' R D' U2 F R U' D R' U F' R2 L' R' U2 F",
          timeInSeconds: 1.4,
          comments: null,
          penalty: "+2"),
      TimeTraining(
        idSession: idSession,
        scramble: "U' D L' R2 F2 D' L' B' F R' D2 U2 F' U D2 R' L2",
        timeInSeconds: 2.1,
        comments: null,
      ),
      TimeTraining(
        idSession: idSession,
        scramble: "F' R' L2 D R' F' U2 L2 F2 U' R' U2 L",
        timeInSeconds: 3.0,
        comments: null,
      ),
      TimeTraining(
        idSession: idSession,
        scramble: "L D' F' R2 L' R' F2 D U' F' L",
        timeInSeconds: 2.5,
        comments: null,
      ),
      TimeTraining(
        idSession: idSession,
        scramble: "R F2 L2 U R' D' F' U' D' L2",
        timeInSeconds: 4.2,
        comments: null,
      ),
      TimeTraining(
          idSession: idSession,
          scramble: "U' L2 D' F R2 L' B' U D F'",
          timeInSeconds: 3.5,
          comments: null,
          penalty: "+2"),
      TimeTraining(
          idSession: idSession,
          scramble: "B' F D2 L' R U F2 U' L",
          timeInSeconds: 5.0,
          comments: null,
          penalty: "+2"),
      TimeTraining(
          idSession: idSession,
          scramble: "U F' R' D B' F' U2 R' L D'",
          timeInSeconds: 2.8,
          comments: null,
          penalty: "DNF"),
      TimeTraining(
        idSession: idSession,
        scramble: "D L2 F U' B2 F R D' L R",
        timeInSeconds: 3.6,
        comments: null,
      ),
      TimeTraining(
        idSession: idSession,
        scramble: "F D' L B' R2 D L2 F' U",
        timeInSeconds: 4.7,
        comments: null,
      ),
      TimeTraining(
          idSession: idSession,
          scramble: "B' U2 D' L' F U' D2 F' R",
          timeInSeconds: 6.0,
          comments: null,
          penalty: "+2"),
      TimeTraining(
        idSession: idSession,
        scramble: "R2 F2 D' B2 U' R F L' D2",
        timeInSeconds: 3.2,
        comments: null,
      ),
      TimeTraining(
          idSession: idSession,
          scramble: "D2 R B2 U' L2 F' D2",
          timeInSeconds: 5.3,
          comments: null,
          penalty: "DNF"),
      TimeTraining(
        idSession: idSession,
        scramble: "U' R' D F L' B U2 R' F2 L",
        timeInSeconds: 4.1,
        comments: null,
      ),
      TimeTraining(
        idSession: idSession,
        scramble: "F2 R2 L2 D U' R2 F D'",
        timeInSeconds: 3.8,
        comments: null,
      ),
    ];

    for (var timeTraining in timeTrainings) {
      final success = await timeTrainingDao.insertNewTime(timeTraining);
      if (success) {
        DatabaseHelper.logger.i("Tiempo insertado: $timeTraining");
      } else {
        DatabaseHelper.logger.i("Error al insertar el tiempo: $timeTraining");
      } // VERIFICAMOS SI SE INSERTO CORRECTAMENTE
    } // SE INSERTA CADA TIEMPO EN LA BASE DE DATOS

    // MOSTRAR RESULTADOS
    // final result = await timeTrainingDao.getTimesOfSession(idSession);
    // DatabaseHelper.logger.i("Tiempos obtenidos: \n${result.join('\n')}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //insertTimes();
    // INICIA LAS ESTADISTICAS
    initTimeStatistics();
  }

  void initTimeStatistics() async {
    final userDao = UserDao();
    final sessionDao = SessionDao();
    TimeTrainingDao timeTrainingDao = TimeTrainingDao();

    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
      return;
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    // OBTENER EL ID DE LA SESION ACTUAL (por ahora la de por defecto)
    int idSession =
        await sessionDao.searchIdSessionByNameAndUser(idUser, "Normal");

    var timesList = await timeTrainingDao.getTimesOfSession(idSession);

    // VALORES DE LAS ESTADISTICAS DE LA SESION
    final worst = await timeTrainingDao.getWorstTimeBySession(timesList);
    final pb = await timeTrainingDao.getPbTimeBySession(timesList);
    int count = await timeTrainingDao.getCountBySession(timesList);

    setState(() {
      // averageValue = await timeTrainingDao.;
      pbValue = pb;
      worstValue = worst;
      countValue = count.toString();
      // ao5Value = await timeTrainingDao.;
      // ao12Value = await timeTrainingDao.;
      // ao50Value = await timeTrainingDao.;
      // ao100Value = await timeTrainingDao.;
    }); // SETTEA EL ESTADO DE LAS ESTADISTICAS
  } // INICIALIZAR/ACTUALIZAR LAS ESTADISTICA

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // TIEMPO QUE RECIBE DDESDE LA CLASE ShowTimeScreen
  String _finalTime = "0.00";

  // KEY DEL ScrambleContainer
  final GlobalKey<ScrambleContainerState> _scrambleKey =
      GlobalKey<ScrambleContainerState>();
  Scramble scramble = Scramble();

  // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
  int random = (Random().nextInt(25 - 20 + 1) + 20);

  void _openShowTimerScreen(BuildContext context) async {
    // OBTENEMOS EL SCRAMBLE ACTUAL ANTES DE ABRIR LA PANTALLA DE SHOWTIME
    final currentScramble = context.read<CurrentScramble>().scramble.toString();

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
      await _saveTimeToDatabase(double.parse(result), currentScramble);
    }
  } // METODO PARA ABRIR LA PANTALLA DE MOSTRAR EL TIEMPO

  Future<void> _saveTimeToDatabase(
      double timeInSeconds, String scramble) async {
    final userDao = UserDao();
    final sessionDao = SessionDao();
    final timeTrainingDao = TimeTrainingDao();
    CubeTypeDao cubeTypeDao = CubeTypeDao();

    try {
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

      // OBTENER EL ID DE LA SESION ACTUAL (por ahora la de por defecto)
      int idSession =
          await sessionDao.searchIdSessionByNameAndUser(idUser, "Normal");

      Session? session =
      await sessionDao.getSessionByUserCubeName(
          idUser, currentSession!.sessionName, cubeType.idCube);


      final timeTraining = TimeTraining(
        idSession: session!.idSession,
        scramble: scramble,
        timeInSeconds: timeInSeconds,
        comments: null,
      ); // CREAR OBJETO TimeTraining

      // INSERTAR EL TIEMPO EN LA BASE DE DATOS
      final success = await timeTrainingDao.insertNewTime(timeTraining);

      // MOSTRAR UNA LISTA CON LOS TIEMPOS
      final result = await timeTrainingDao.getTimesOfSession(idSession);
      DatabaseHelper.logger.i("obtenidas: \n${result.join('\n')}");

      if (success) {
        DatabaseHelper.logger.i("Tiempo guardado correctamente.");
        initTimeStatistics(); // ACTUALIZAR LAS ESTADISTICAS
      } else {
        DatabaseHelper.logger.e("Error al guardar el tiempo.");
      } // VERIFICAR QUE SI SE INSERTO CORRECTAMENTE
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al guardar el tiempo en la base de datos: $e");
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
                        Semantics(
                          label: Internationalization.internationalization
                              .getLocalizations(context, "time_label"),
                          hint: Internationalization.internationalization
                              .getLocalizations(context, "time_hint"),
                          child: Text(
                            _finalTime,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkPurpleColor,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconClass.iconButton(logicComment, "Add comments",
                                Icons.add_comment_rounded),
                            TextButton(
                              onPressed: () {},
                              child:
                                  // DNF
                                  Internationalization.internationalization
                                      .createLocalizedSemantics(
                                context,
                                "dnf_label",
                                "dnf_hint",
                                "dnf",
                                const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child:
                                  // +2
                                  Internationalization.internationalization
                                      .createLocalizedSemantics(
                                context,
                                "plus_two_label",
                                "plus_two_hint",
                                "plus_two",
                                const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor,
                                ),
                              ),
                            ),
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
