import 'dart:math';

import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/view/components/cube_header_container.dart';
import 'package:esteladevega_tfg_cubex/view/components/scramble_container.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/app_drawer.dart';
import 'package:esteladevega_tfg_cubex/view/screen/show_time_screen.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_statistics.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_time.dart';
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
import '../components/waves_painter/small_wave_container_painter.dart';
import '../utilities/ScrambleGenerator.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';

import '../utilities/alert.dart';
import '../utilities/app_styles.dart';

/// Pantalla principal del temporizador del cubo.
///
/// Esta pantalla permite al usuario cronometrar sus tiempos de un cubo,
/// mostrando estadísticas como el mejor tiempo (PB), el peor tiempo (worst),
/// entre otras estadísticas.
///
/// Además, permite insertar sesiones y tipos de cubos.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TextStyle statsTextStyle = AppStyles.darkPurpleAndBold(15);
  final userDao = UserDao();
  final sessionDao = SessionDao();
  final cubeDao = CubeTypeDao();
  final timeTrainingDao = TimeTrainingDao();
  final cubeTypeDao = CubeTypeDao();

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
  final GlobalKey<ScrambleContainerState> _scrambleKey =
      GlobalKey<ScrambleContainerState>();
  Scramble scramble = Scramble();

  // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
  int random = (Random().nextInt(25 - 20 + 1) + 20);

  late CurrentTime currentTime;

  // ATRIBUTOS PARA SABER SI SE ESTABLECIDO PENALIZACIONES O COMENTARIOS
  bool isDnfChoose = false, isPlusTwoChoose = false, isComment = false;

  @override
  void initState() {
    super.initState();
    // INICIA LAS ESTADISTICAS
    initTimeStatistics();
    currentTime = context.read<CurrentTime>();
    currentTime.setResetTimeTraining();
  }

  @override
  void dispose() async {
    // ACTUALIZA LA INFORMACION DEL TIEMPO ACTUAL
    // (si ha hecho un tiempo, añadido penalizaciones/comentarios cuando se vaya
    // a otra pestaña, se guardara)
    currentTime.updateCurrentTime(context);

    super.dispose();
  }

  /// Método para inicializar las estadísticas de tiempo.
  ///
  /// Este método obtiene los tiempos almacenados en la base de datos para la sesión actual
  /// y actualiza, actualmentem las estadísticas como el mejor tiempo (PB), el peor tiempo y
  /// el número de tiempos que hay en la sesión.
  void initTimeStatistics() async {
    // OBTENER EL ID DEL USUARIO
    int? idUser = await userDao.getUserId(context);
    final session = await sessionDao.getSessionData(context, idUser!);

    var timesList = await timeTrainingDao.getTimesOfSession(session!.idSession);

    final currentStatistics = context.read<CurrentStatistics>();
    // SE ACTUALIZA EL ESTADO GLOBAL
    currentStatistics.updateStatistics(timesListUpdate: timesList);

    String pb = await currentStatistics.getPbValue();
    String worst = await currentStatistics.getWorstValue();
    String count = await currentStatistics.getCountValue();
    String ao5 = await currentStatistics.getAo5Value();
    String ao12 = await currentStatistics.getAo12Value();
    String ao50 = await currentStatistics.getAo50Value();
    String ao100 = await currentStatistics.getAo100Value();
    String average = await currentStatistics.getAoXValue(timesList.length);

    setState(() {
      averageValue = average;
      pbValue = pb;
      worstValue = worst;
      countValue = count;
      ao5Value = ao5;
      ao12Value = ao12;
      ao50Value = ao50;
      ao100Value = ao100;
    }); // SETTEA EL ESTADO DE LAS ESTADISTICAS
  } // INICIALIZAR/ACTUALIZAR LAS ESTADISTICA

  /// Abre la pantalla [ShowTimeScreen] y espera el tiempo final del usuario.
  ///
  /// Una vez que el usuario termine de resolver el cubo, se guarda el tiempo
  /// en la base de datos y se actualiza el scramble mostrado.
  void _openShowTimerScreen(BuildContext context) async {
    // OBTENEMOS EL SCRAMBLE ACTUAL ANTES DE ABRIR LA PANTALLA DE SHOWTIME
    final currentScramble = context.read<CurrentScramble>().scramble.toString();

    DatabaseHelper.logger
        .i("El tiempo anterior: ${currentTime.timeTraining.toString()}");

    // ABRIR LA PANTALLA DE SHOWTIME Y ESPERAR EL RESULTADO
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShowTimeScreen(),
      ),
    );

    // REESTABLECER VALORES DE PENALIZACION
    currentTime.isPlusTwoChoose = false;
    currentTime.isDnfChoose = false;
    isComment = false;

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

  /// Guarda el tiempo realizado en la base de datos.
  ///
  /// Este método recibe el tiempo final en segundos y el scramble utilizado,
  /// luego guarda el tiempo en la base de datos en la tabla correspondiente.
  ///
  /// **Parámetros**:
  /// - `timeInSeconds`: El tiempo total en segundos que se ha tomado para completar la resolución.
  /// - `scramble`: El scramble que fue utilizado para resolver el cubo.
  ///
  /// **Caracteristicas**:
  /// - Se obtiene el usuario, la sesión, el tipo de cubo actual.
  /// - Se crea un objeto `TimeTraining` con los detalles del tiempo y se guarda en la base de datos.
  /// - Si la inserción es exitosa, se actualiza el estado global con el nuevo tiempo.
  /// - Se actualizan las estadísticas de tiempo.
  Future<void> _saveTimeToDatabase(
      double timeInSeconds, String scramble) async {
    try {
      // OBTENER EL ID DEL USUARIO
      int? idUser = await userDao.getUserId(context);
      final session = await sessionDao.getSessionData(context, idUser!);

      final timeTraining = TimeTraining(
        idSession: session!.idSession,
        scramble: scramble,
        timeInSeconds: timeInSeconds,
        comments: null,
      ); // CREAR OBJETO TimeTraining

      // INSERTAR EL TIEMPO EN LA BASE DE DATOS
      final success = await timeTrainingDao.insertNewTime(timeTraining);

      // MOSTRAR UNA LISTA CON LOS TIEMPOS
      final result = await timeTrainingDao.getTimesOfSession(session.idSession);
      DatabaseHelper.logger.i("obtenidas: \n${result.join('\n')}");

      if (success) {
        DatabaseHelper.logger.i("Tiempo guardado correctamente.");

        // GUARDAR LOS DATOS DEL TIEMPO EN EL ESTADO GLOBAL
        currentTime = Provider.of<CurrentTime>(this.context, listen: false);
        // SE ACTUALIZA EL ESTADO GLOBAL
        currentTime.setTimeTraining(timeTraining);

        initTimeStatistics(); // ACTUALIZAR LAS ESTADISTICAS
      } else {
        DatabaseHelper.logger.e("Error al guardar el tiempo.");
      } // VERIFICAR QUE SI SE INSERTO CORRECTAMENTE
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al guardar el tiempo en la base de datos: $e");
    }
  } // METODO PARA GUARDAR EL TIEMPO REALIZADO

  /// Muestra una alerta para añadir un comentario al tiempo actual.
  ///
  /// Este método es llamado cuando el usuario pulsa el icono de comentarios.
  /// Se muestra una alerta que permite introducir un comentario, el cual será
  /// guardado en la base de datos y asociado al tiempo actual.
  ///
  /// Si el usuario ya ha introducido un comentario y vuelve a pulsar este icono,
  /// se establecerá ese mismo comentario introducido.
  void logicComment() {
    isComment = true;
    // APARECERA UNA ALERTA PARA QUE INTRODUZCA UN COMENTARIO
    AlertUtil.showCommentsTime(context, "add_comment_time", (String com) async {
      // ACTUALIZAR EN LA BASE DE DATOS EL COMENTARIO
      if (currentTime.timeTraining != null) {
        // AÑADIR NUEVO COMENTARIO
        TimeTraining updatedTime = TimeTraining(
          idSession: currentTime.timeTraining!.idSession,
          scramble: currentTime.timeTraining!.scramble,
          timeInSeconds: currentTime.timeTraining!.timeInSeconds,
          comments: com,
          // ACTUALIZAR COMENTARIO
          penalty: currentTime.timeTraining!.penalty,
        );

        // SE ACTUALIZA EN LA BASE DE DATOS
        int idTime = await timeTrainingDao.getIdByTime(
            currentTime.timeTraining!.scramble,
            currentTime.timeTraining!.idSession);

        if (idTime == -1) {
          AlertUtil.showSnackBarError(context, "time_saved_error");
          return;
        } // VALIDAR QUE EL IDTIME NO DE ERROR

        // ACTUALIZAR EL TIEMPO
        if (await timeTrainingDao.updateTime(idTime, updatedTime) == false) {
          AlertUtil.showSnackBarError(context, "time_saved_error");
          return;
        } // SI FALLA, SE MUESTRA UN ERROR

        // ACTUALIZAR ESTADO GLOBAL
        currentTime.setTimeTraining(updatedTime);
      }
    });
  } // METODO PARA CUANDO PULSE EL ICONO DE COMENTARIOS

  /// Muestra una alerta para confirmar la eliminación del tiempo actual.
  ///
  /// Este método es llamado cuando el usuario intenta eliminar el tiempo actual.
  /// Si hay un tiempo almacenado en `currentTime`, se muestra una alerta para confirmar la eliminación.
  /// Esto para que no pueda eliminar un tiempo que todavía no ha hecho.
  void logicDeleteTime() async {
    // OBTENER EL TIEMPO ACTUAL
    currentTime = context.read<CurrentTime>();

    if (currentTime.timeTraining != null) {
      AlertUtil.showDeleteSessionOrCube(
        context,
        "actual_delete_time",
        "actual_delete_time_content",
        () => currentTime.deleteTime(context),
      );
    } // SI HAY UN TIEMPO ACTUAL, SE MUESTRA LA ALERTA
  } // METODO PARA CUANDO PULSE EL ICONO DE ELIMINAR TIEMPO

  @override
  Widget build(BuildContext context) {
    currentTime = context.watch<CurrentTime>();
    // SE MUESTRA EL TIEMPO FORMATEADO (si tiene penalizacines o no)
    _finalTime = currentTime.getFormattedTime();

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

          Positioned(
            // UBICARLO EN LA ESQUINA SUPERIOR IZQUIERDA
            top: 0,
            left: 0,
            child: CustomPaint(
              painter: SmallWaveContainerPainter(
                backgroundColor: AppColors.lightVioletColor,
              ),
              child: SizedBox(
                width: 190, // ANCHO
                height: 97, // ALTO
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, top: 0),
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: IconClass.iconMaker(
                          context, Icons.settings, "settings", 26),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // CONTAINER DEL TIPO DE CUBO Y LA SESION UN POCO MAS ABAJO A LA DERECHA
          const Positioned(
            top: 43,
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
            bottom: 60,
            child: GestureDetector(
              onTap: () async {
                // CUANDO EMPIECE UN TIEMPO NUEVO, SI HA PULSADO ALGUNA PENALIZACION, SE ACTUALIZA EL TIEMPO
                if (currentTime.isPlusTwoChoose || currentTime.isDnfChoose) {
                  int idTime = await timeTrainingDao.getIdByTime(
                      currentTime.timeTraining!.scramble,
                      currentTime.timeTraining!.idSession);

                  if (idTime == -1) {
                    AlertUtil.showSnackBarError(context, "time_saved_error");
                    return;
                  } // VALIDAR QUE EL IDTIME NO DE ERROR

                  // ACTUALIZAR ESTADO GLOBAL
                  currentTime.updateCurrentTime(context);
                  // (no se muestra mensaje de exito, el usuario lo podra ver en el historial)
                }
                // ABRIR TIMER
                _openShowTimerScreen(context);
              }, // CUANDO MANTIENE PULSADO ABRE LA PANTALLA DE MOSTRAR TIMER
              child: Column(
                children: [
                  // EXPANDE EL CONTENEDOR CON EL TIMER PARA QUE OCUPE TODO_EL ESPACIO
                  // DISPONIBLE ENTRE EL SCRAMBLE Y LAS ESTADISTICAS
                  Expanded(
                    child: Container(
                      // SOLO SE PONE PADDING HORIZONTAL PARA NO DEJAR FIJO EL VERTICAL
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    key: const Key('timer_display'),
                                    _finalTime,
                                    style: AppStyles.darkPurpleAndBold(40),
                                  ),

                                  // SI HAY UN +2 O COMENTARIOS, SE AÑADE UN PADDING A LA DERECHA
                                  if (currentTime.isPlusTwoChoose || isComment)
                                    const Padding(
                                        padding: EdgeInsets.only(right: 5)),

                                  // SI SOLO ESTA SELECCIONADO EL +2 SIN COMENTARIOS
                                  if (currentTime.isPlusTwoChoose && !isComment)
                                    const Text(
                                      " +2",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deleteAccount,
                                      ),
                                    ),

                                  // SI SOLO HAY COMENTARIOS, SE MUESTRA SOLO EL ICON
                                  if (isComment && !currentTime.isPlusTwoChoose)
                                    IconClass.iconMaker(
                                        context, Icons.comment, "fsd", 15),

                                  // SI HAY COMENTARIOS Y +2, SE MUESTRAN EN COLUMNA
                                  if (isComment && currentTime.isPlusTwoChoose)
                                    Column(
                                      children: [
                                        IconClass.iconMaker(
                                            context, Icons.comment, "fsd", 15),
                                        const Text(
                                          " +2",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.deleteAccount,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SI HA HECHO O NO UN TIEMPO, SE ACTIVAN O "DESACTIVA" EL BOTON
                              currentTime.timeTraining != null
                                  ? IconClass.iconButton(context, logicComment,
                                      "add_comment", Icons.add_comment_rounded)
                                  : IconClass.iconButton(
                                      context,
                                      () {},
                                      "add_comment",
                                      Icons.add_comment_rounded,
                                      AppColors.darkPurpleOpacity),
                              TextButton(
                                // SI HA HECHO O NO UN TIEMPO, SE ACTIVAN O "DESACTIVA" EL BOTON
                                onPressed: currentTime.timeTraining != null
                                    ? () {
                                        currentTime.setPenalty(
                                            "DNF", !currentTime.isDnfChoose);
                                      }
                                    : () {},
                                // SE DESHABILITA SI NO HAY TIEMPO ACTUAl
                                child: Internationalization.internationalization
                                    .createLocalizedSemantics(
                                  context, "dnf_label", "dnf_hint", "dnf",
                                  // APLICAR COLOR SI ESTA O NO PULSADO
                                  AppStyles.getButtonTextStyle(
                                      currentTime.isDnfChoose,
                                      currentTime.timeTraining != null),
                                ),
                              ),
                              TextButton(
                                // SI HA HECHO O NO UN TIEMPO, SE ACTIVAN O "DESACTIVA" EL BOTON
                                onPressed: currentTime.timeTraining != null
                                    ? () {
                                        currentTime.setPenalty(
                                            "+2", !currentTime.isPlusTwoChoose);
                                      }
                                    : () {},
                                // SE DESHABILITA SI NO HAY TIEMPO ACTUAL
                                child: Internationalization.internationalization
                                    .createLocalizedSemantics(
                                  context, "plus_two_label", "plus_two_hint",
                                  "plus_two",
                                  // APLICAR COLOR SI ESTA O NO PULSADO
                                  AppStyles.getButtonTextStyle(
                                      currentTime.isPlusTwoChoose,
                                      currentTime.timeTraining != null),
                                ),
                              ),
                              IconClass.iconButton(context, logicDeleteTime,
                                  "delete_time", Icons.close),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // ESTADISTICAS
                  Container(
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
                                  _statsText("Average", averageValue),
                                  _statsText("Pb", pbValue),
                                  _statsText("Worst", worstValue),
                                  _statsText("Count", countValue)
                                ],
                              ),

                              //COLUMNA DERECHA
                              Column(
                                // EMPIEZA DESDE ARRIBA A LA DERECHA
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _statsText("Ao5", ao5Value),
                                  _statsText("Ao12", ao12Value),
                                  _statsText("Ao50", ao50Value),
                                  _statsText("Ao100", ao100Value)
                                ],
                              ),
                            ],
                          ),
                        ],
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

  Text _statsText(String title, String value) {
    return Text(
      "$title: $value",
      style: statsTextStyle,
    );
  }
}