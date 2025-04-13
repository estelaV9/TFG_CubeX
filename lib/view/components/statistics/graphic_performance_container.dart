import 'package:esteladevega_tfg_cubex/data/dao/time_training_dao.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../data/dao/cubetype_dao.dart';
import '../../../data/dao/session_dao.dart';
import '../../../data/dao/user_dao.dart';
import '../../../data/database/database_helper.dart';
import '../../../model/cubetype.dart';
import '../../../model/session.dart';
import '../../../model/time_training.dart';
import '../../../viewmodel/current_cube_type.dart';
import '../../../viewmodel/current_session.dart';
import '../../../viewmodel/current_time.dart';
import '../../../viewmodel/current_user.dart';
import '../../utilities/app_color.dart';
import '../../utilities/app_styles.dart';
import '../../utilities/internationalization.dart';

/// Container para las estadísticas gráficas del cubo.
///
/// Este widget muestra una visualización gráfica del rendimiento del usuario
/// a lo largo del tiempo, basada en las resoluciones registradas para una
/// sesión y tipo de cubo específicos.
///
/// Se visualizan los datos como:
/// - Los tiempos individuales registrados por fecha y hora.
/// - Los mejores tiempos (PB).
/// - El número total de resoluciones realizadas.
/// - Filtros de visualización por día, mes o año.
/// - La opción de cambiar entre orientación horizontal y vertical.
/// - La opción de mostrar/ocultar los tiempos en cada punto del gráfico.
///
/// La información se carga automáticamente al construir el widget, accediendo
/// a la información del usuario, la sesión y el tipo de cubo seleccionados.
class GraphicPerformanceContainer extends StatefulWidget {
  const GraphicPerformanceContainer({super.key});

  @override
  State<GraphicPerformanceContainer> createState() =>
      _GraphicPerformanceContainerState();
}

class _GraphicPerformanceContainerState
    extends State<GraphicPerformanceContainer> {
  UserDao userDao = UserDao();
  CubeTypeDao cubeTypeDao = CubeTypeDao();
  SessionDao sessionDao = SessionDao();
  TimeTrainingDao timeTrainingDao = TimeTrainingDao();

  // LISTA CON TODOS LOS TIEMPOS DE ENTRENAMIENTO
  List<TimeTraining> _listTimes = [];

  // LISTA PARA EL GRAFICO PRINCIPAL
  final List<_TimeData> _listTimesData = [];

  // LISTA DE LOS MEJORES TIEMPOS (PB)
  List<_TimeData> pbTimes = [];

  // CONTADOR DE CUANTOS TIEMPOS HAY EN LA SESION
  int solveCount = 0;

  // ACTIVA/DESACTIVA LA ORIENTACION VERTICAL DEL GRAFICO
  bool isVerticalGraphActive = false;

  // ACTIVA/DESACTIVA LOS NUMEROS EN LA GRAFICA
  bool isNumberActive = false;

  // FILTRO ACTUAL SELECCIONADO PARA EL GRAFICO (DIARIO POR DEFECTO)
  TimeFilter currentFilter = TimeFilter.daily;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTimes();
  }

  /// Método para cargar los tiempos de la sesión y el tipo de cubo actual.
  ///
  /// Parámetros:
  /// - currentTime (String, opcional): se utiliza para filtrar la busqueda por
  ///   tiempo o por comentario, si se proporciona.
  ///
  /// Este método obtiene el ID del usuario actual, la sesión actual y el
  /// tipo de cubo actual.
  /// Luego, recupera los tiempos de entrenamiento asociados a esa sesión y
  /// cubo, y actualiza la lista de tiempos.
  Future<void> _loadTimes([CurrentTime? currentTime]) async {
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

    CubeType? cubeType =
        await cubeTypeDao.getCubeTypeByNameAndIdUser(currentCube!.cubeName, idUser);
    if (cubeType.idCube == -1) {
      DatabaseHelper.logger.e("Error al obtener el tipo de cubo.");
      return;
    } // VERIFICAR QUE SI RETORNA EL TIPO DE CUBO CORRECTAMENTE

    // OBJETO SESION CON EL ID DEL USUARIO, NOMBRE Y TIPO DE CUBO
    Session? session = await sessionDao.getSessionByUserCubeName(
        idUser, currentSession!.sessionName, cubeType.idCube);

    if (session!.idSession != -1) {
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

      int num = await timeTrainingDao.getCountBySession(times);

      setState(() {
        _listTimes = times;
        solveCount = num;
      });

      for (TimeTraining timeInList in _listTimes) {
        _TimeData timeData =
            _TimeData(timeInList.timeInSeconds, timeInList.registrationDate);
        _listTimesData.add(timeData);
      } // AÑADIMOS EL TIEMPO Y EL DATE A LA LISTA
    } else {
      DatabaseHelper.logger.e(
          "No se encontro el id de la session actual: ${session.toString()}");
    } // SE VERIFICA QUE SE BUSCO BIEN EL ID
  } // CARGAR LOS TIEMPOS DE UNA SESION DE UN TIPO DE CUBO

  /// Método privado para crear un boton con efecto hover que permite cambiar
  /// el filtro del tiempo a mostrar
  ///
  /// Párametros:
  /// - [text]: Texto que se mostrará en el botón.
  /// - [filter]: Filtro de tiempo que se aplica cuando se presione el boton (Diario, mensual o anual).
  ///
  /// Devuelve un widget de tipo [TextButton] con estilo personalizado y efecto del hover.
  Widget _buildHoverableButton(String text, TimeFilter filter) {
    // VARIABLE LOCAL PARA SABER SI EL RATON ESTA ENCIMA DEL BOTON
    bool isHovered = false;

    // VARIABLE PARA SABER SI EL BOTON ESTA ACTIVO SEGUN EL FILTRO ACTUAL
    final bool isActive = currentFilter == filter;

    String message = Internationalization.internationalization
        .getLocalizations(context, text);

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          // SE ACTIVA EL HOVER
          onEnter: (_) => setState(() => isHovered = true),
          // SE DESACTIVA EL HOVER
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            decoration: BoxDecoration(
              // COLOR DE FONDO SEGUN ESTADO: ACTIVO, HOVER O NORMAL
              color: isActive
                  ? AppColors.softLavender // ACTIVO
                  : (isHovered
                      ? AppColors.softLavender.withOpacity(0.5) // HOVER
                      : AppColors.lightVioletColor), // NORMAL
              borderRadius: BorderRadius.circular(13), // ESQUINAS REDONDEADAS
            ),
            child: TextButton(
              onPressed: () {
                // SE CAMBIA EL FILTRO ACTUAL AL SELECCIONADO
                setState(() {
                  currentFilter = filter;
                });
                // SE ACTUALIZA EL ESTADO DE LA PANTALLA PRINCIPAL
                this.setState(() {});
              },
              child: Text(message, // TEXTO MOSTRADO EN EL BOTON
                  style: AppStyles.darkPurpleAndBold(13),
                  semanticsLabel: message),
            ),
          ),
        );
      },
    );
  }

  /// Método privado para generar una lista de tiempos que representan los mejores tiempos
  /// (PB) de una sesión.
  ///
  /// Recorre la lista de tiempos (_listTimesData) y va agregando a la lista pbTimes
  /// aquellos tiempos que sean menores al mínimo registrado hasta ese momento.
  ///
  /// Esta lista se utiliza para mostrar los PB en una gráfica con línea discontinua y con
  /// punto en los tiempos.
  void _loadPbList() {
    // EL PRIMER MINIMO PB ES EL PRIMER TIEMPO QUE HIZO
    double minimoPb = _listTimesData[0].time;
    _TimeData timeData = _TimeData(minimoPb, _listTimesData[0].date);
    pbTimes.add(timeData);

    for (_TimeData c in _listTimesData) {
      if (c.time < minimoPb) {
        // SI EL TIEMPO ES MEJOR QUE EL MINIMO PB SE AGREGA A LA LISTA
        minimoPb = c.time;
        _TimeData timeDataPb = _TimeData(minimoPb, c.date);
        pbTimes.add(timeDataPb);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadPbList();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightVioletColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Performance Over Time",
                    style: AppStyles.darkPurpleAndBold(17),
                    // HACE QUE HAGA UN SALTO DE LINEA SI SE HACE PEQUEÑA EL
                    // TAMAÑO DE LA PANTALLA
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    semanticsLabel: Internationalization.internationalization
                        .getLocalizations(context, "performance_over_time"),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHoverableButton("yearly", TimeFilter.yearly),
                  _buildHoverableButton("monthly", TimeFilter.monthly),
                  _buildHoverableButton("daily", TimeFilter.daily),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.softLavender,
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          solveCount.toString(),
                          style: AppStyles.darkPurpleAndBold(25),
                          semanticsLabel:
                              "${Internationalization.internationalization.getLocalizations(context, "tooltip_solve_count")}: ${solveCount.toString()}",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7, left: 4),
                          child: AppStyles.textWithSemanticsAndTooltip(
                              context,
                              "semantic_solve_count",
                              "tooltip_solve_count",
                              "solve_count",
                              AppStyles.darkPurple(12)),
                        )
                      ],
                    ),
                    Semantics(
                      label: Internationalization.internationalization
                          .getLocalizations(context, "graph_orientation"),
                      child: Row(
                        children: [
                          IconClass.iconMaker(
                              context,
                              Icons.screen_rotation_alt_rounded,
                              "graph_orientation"),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: isVerticalGraphActive,
                              onChanged: (bool value1) {
                                setState(() {
                                  isVerticalGraphActive = value1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Semantics(
                      label: Internationalization.internationalization
                          .getLocalizations(context, "toggle_times_visibility"),
                      // SE USA TRANSFORM PARA AJUSTAR EL TAMAÑO DEL SWITCH
                      child: Row(
                        children: [
                          IconClass.iconMaker(context, Icons.hide_source,
                              "toggle_times_visibility"),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: isNumberActive,
                              onChanged: (bool value1) {
                                setState(() {
                                  isNumberActive = value1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // GRAFICA DE ESTADISTICAS
              SfCartesianChart(
                  // SI ESTA ACTIVO SE MUESTRA LA GRAFICA EN VERTICAL
                  isTransposed: isVerticalGraphActive,
                  // SE USA FECHAS FORMATEADAS
                  primaryXAxis: const CategoryAxis(),
                  palette: [
                    // COLOR DEL GRAFICO
                    AppColors.darkPurpleColor.withOpacity(0.8),
                  ],
                  // DESHABILITAMOS LA LEYENDA
                  legend: const Legend(isVisible: false),
                  // LOS TOOLTIPS AL PULSAR UN TIEMPO ESTA ACTIVO
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<_TimeData, String>>[
                    // GRAFICA DE TIEMPOS
                    LineSeries<_TimeData, String>(
                        // DATOS DE LOS TIEMPOS
                        dataSource: _listTimesData,
                        xValueMapper: (_TimeData timeData, _) {
                          DateTime parsedDate = DateTime.parse(timeData.date);
                          // SEGUN LA OPCION ELEGIDA SE MUESTRA DE UN TIPO DE FECHA
                          switch (currentFilter) {
                            case TimeFilter.daily:
                              // CON EL DIA/MES/AÑO Y HORA:MINUTOS
                              return '${DateFormat('dd-MM-yyyy').format(parsedDate)}\n${DateFormat('HH:mm').format(parsedDate)}';
                            case TimeFilter.monthly:
                              // CON EL NOMBRE COMPLETO DEL MES
                              return DateFormat('MMMM').format(parsedDate);
                            case TimeFilter.yearly:
                              // SE MEUSTRA EL AÑO
                              return DateFormat('yyyy').format(parsedDate);
                          }
                        },
                        // VALOR TIEMPO
                        yValueMapper: (_TimeData timeData, _) => timeData.time,
                        // SE QUITA LA LEYENDA
                        name: '',
                        isVisibleInLegend: false,
                        // SI ESTA ACTIVO SE MUESTRA EL TIEMPO
                        dataLabelSettings:
                            DataLabelSettings(isVisible: isNumberActive)),

                    // GRAFICA CON LOS PBS
                    LineSeries<_TimeData, String>(
                        dataSource: pbTimes,
                        xValueMapper: (_TimeData timeData, _) {
                          DateTime parsedDate = DateTime.parse(timeData.date);
                          switch (currentFilter) {
                            case TimeFilter.daily:
                              return '${DateFormat('dd-MM-yyyy').format(parsedDate)}\n${DateFormat('HH:mm').format(parsedDate)}';
                            case TimeFilter.monthly:
                              return DateFormat('MMMM').format(parsedDate);
                            case TimeFilter.yearly:
                              return DateFormat('yyyy').format(parsedDate);
                          }
                        },

                        // HACER LA LINEA DISCONTINUA
                        dashArray: const <double>[12, 12],
                        markerSettings: const MarkerSettings(
                          // SE MUESTRAN LOS PUNTOS
                          isVisible: true,
                          // FORMA DE CIRCULO
                          shape: DataMarkerType.circle,
                          // TAMAÑO Y ALTURA DEL PUNTO
                          width: 5,
                          height: 5,
                          borderWidth: 3,
                          // COLOR DEL PUNTO
                          color: AppColors.pointPbGraphic,
                          borderColor: AppColors.pointPbGraphic,
                        ),
                        yValueMapper: (_TimeData timeData, _) => timeData.time,
                        name: '',
                        isVisibleInLegend: false,
                        dataLabelSettings:
                            DataLabelSettings(isVisible: isNumberActive))
                  ]),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Enumeración que define los posibles filtros de tiempo
/// para visualizar los datos en el gráfico.
///
/// Se agrupan los datos de tiempos de la sesión actual por día, mes o año.
enum TimeFilter { daily, monthly, yearly }

/// Clase interna que representa un punto de datos en el gráfico.
///
/// Contiene el tiempo de resolución en segundos y la fecha
/// de registro en formato string.
///
/// Se utiliza para construir los ejes X e Y del gráfico.
class _TimeData {
  _TimeData(this.time, this.date);

  /// Tiempo en segundos de la resolución.
  final double time;

  /// Fecha y hora del registro.
  final String date;
}
