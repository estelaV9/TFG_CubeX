import 'package:esteladevega_tfg_cubex/view/utilities/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/dao/session_dao.dart';
import '../../../data/dao/time_training_dao.dart';
import '../../../data/dao/user_dao.dart';
import '../../../model/session.dart';
import '../../../viewmodel/current_statistics.dart';
import '../../utilities/app_color.dart';
import '../../utilities/internationalization.dart';

/// Container que muestra un resumen en una tabla de las estadísticas de los tiempos
/// de resolución del cubo en una sesión actual.
///
/// Este widget muestra las siguientes estadísticas:
/// - Promedio (Average) de los tiempos en diferentes categorías (ao5, ao12, ao50, ao100)
/// - El mejor tiempo en cada categoría (Best)
/// - El peor tiempo en cada categoría (Worst)
/// - El tiempo total promedio de la sesión (aoTotal)
///
/// Las estadísticas se obtienen y calculan automáticamente cuando se construye el widget,
/// y se actualizan al obtener los datos del usuario y la sesión en curso.
class AverageAnalysisContainer extends StatefulWidget {
  const AverageAnalysisContainer({super.key});

  @override
  State<AverageAnalysisContainer> createState() =>
      _AverageAnalysisContainerState();
}

class _AverageAnalysisContainerState extends State<AverageAnalysisContainer> {
  // MAPA PARA ALMACENAR LAS ESTADISTICAS DE LOS TIEMPOS
  Map<String, String> bestTimes = {
    "ao5": "00:00.00",
    "ao12": "00:00.00",
    "ao50": "00:00.00",
    "ao100": "00:00.00",
  };

  Map<String, String> worstTimes = {
    "ao5": "00:00.00",
    "ao12": "00:00.00",
    "ao50": "00:00.00",
    "ao100": "00:00.00",
  };

  Map<String, String> currentTimes = {
    "ao5": "00:00.00",
    "ao12": "00:00.00",
    "ao50": "00:00.00",
    "ao100": "00:00.00",
    "aoTotal": "00:00.00",
  };

  String aoTotal = "00:00.00";

  UserDao userDao = UserDao();
  SessionDao sessionDao = SessionDao();

  /// Método que inicializa las estadísticas de tiempo del usuario.
  ///
  /// Este método obtiene:
  /// - El ID del usuario actual y la sesión actual asociada a ese usuario y
  /// tipo de cubo.
  /// - Las estadísticas de tiempos calculadas para dicha sesión.
  /// Luego, actualiza el estado del widget con los datos obtenidos.
  ///
  /// Retorna:
  /// - `Future<void>`: No devuelve un valor, pero actualiza el estado del widget.
  Future<void> initTimeStatistics() async {
    int? idUser = await userDao.getUserId(context);
    if (idUser == null) return;

    Session? session = await sessionDao.getSessionData(context, idUser);
    if (session == null) return;

    var statistics = await _getStatistics(session);
    if (statistics == null) return;

    _updateState(statistics);
  }

  /// Método que calcula y retorna las estadísticas de tiempos de una sesión.
  ///
  /// Parámetros:
  /// - `session`: Objeto de tipo `Session` sobre el cual se calcularán las estadísticas.
  ///
  /// Características:
  /// - Obtiene la lista de tiempos registrados en la sesión.
  /// - Calcula promedios (ao5, ao12, ao50, ao100, media total).
  /// - Calcula el mejor y peor promedio para cada caso.
  ///
  /// Retorna:
  /// - `Map<String, dynamic>?`: Un mapa con las estadísticas calculadas o `null` si ocurre algún error.
  Future<Map<String, dynamic>?> _getStatistics(Session session) async {
    final timeTrainingDao = TimeTrainingDao();
    final currentStatistics = context.read<CurrentStatistics>();

    var timesList = await timeTrainingDao.getTimesOfSession(session.idSession);
    currentStatistics.updateStatistics(timesListUpdate: timesList);

    String ao5 = await currentStatistics.getAo5Value();
    String ao12 = await currentStatistics.getAo12Value();
    String ao50 = await currentStatistics.getAo50Value();
    String ao100 = await currentStatistics.getAo100Value();
    String average = await currentStatistics.getAoXValue(timesList.length);

    String ao5Best = await currentStatistics.getBestAvgValue(5);
    String ao12Best = await currentStatistics.getBestAvgValue(12);
    String ao50Best = await currentStatistics.getBestAvgValue(50);
    String ao100Best = await currentStatistics.getBestAvgValue(100);

    String ao5Worst = await currentStatistics.getWorstAvgValue(5);
    String ao12Worst = await currentStatistics.getWorstAvgValue(12);
    String ao50Worst = await currentStatistics.getWorstAvgValue(50);
    String ao100Worst = await currentStatistics.getWorstAvgValue(100);

    return {
      'ao5': ao5,
      'ao12': ao12,
      'ao50': ao50,
      'ao100': ao100,
      'aoTotal': average,
      'ao5Best': ao5Best,
      'ao12Best': ao12Best,
      'ao50Best': ao50Best,
      'ao100Best': ao100Best,
      'ao5Worst': ao5Worst,
      'ao12Worst': ao12Worst,
      'ao50Worst': ao50Worst,
      'ao100Worst': ao100Worst,
    };
  }

  /// Método que actualiza el estado interno del widget con nuevas estadísticas.
  ///
  /// Se modifica las variables `bestTimes`, `worstTimes`, `currentTimes` y `aoTotal`,
  /// actualizando la interfaz con los nuevos datos.
  ///
  /// Parámetros:
  /// - `statistics`: Un mapa con los valores de estadísticas actuales, mejores y peores.
  void _updateState(Map<String, dynamic> statistics) {
    setState(() {
      bestTimes = {
        "ao5": statistics['ao5Best'],
        "ao12": statistics['ao12Best'],
        "ao50": statistics['ao50Best'],
        "ao100": statistics['ao100Best'],
      };

      worstTimes = {
        "ao5": statistics['ao5Worst'],
        "ao12": statistics['ao12Worst'],
        "ao50": statistics['ao50Worst'],
        "ao100": statistics['ao100Worst'],
      };

      currentTimes = {
        "ao5": statistics['ao5'],
        "ao12": statistics['ao12'],
        "ao50": statistics['ao50'],
        "ao100": statistics['ao100'],
      };

      aoTotal = statistics['aoTotal'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTimeStatistics();
  }

  @override
  Widget build(BuildContext context) {
    initTimeStatistics();

    // METODO PARA CONSTRUIR LAS COLUMNAS DE TIEMPOS
    Widget buildColumn(String title, Map<String, String> times) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          AppStyles.textWithSemanticsAndTooltip(
            context,
            "${title}_label",
            "${title}_hint",
            title,
            AppStyles.darkPurpleAndBold(15),
          ),
          // RECORREMOS EL MAPA
          ...times.entries.map((entry) {
            final entryKey = entry.key;
            return AppStyles.textWithSemanticsAndTooltip(
              context,
              "${entryKey}_label",
              "${entryKey}_hint",
              entry.value,
              AppStyles.darkPurple(15),
            );
          }),
        ],
      );
    }

    return Container(
      // SIN WITH PARA QUE EXPANDA
      height: 225,
      padding: const EdgeInsets.only(top: 8, right: 20, left: 20, bottom: 15),
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
        children: [
          Center(
              child: Text(
            "Average analysis",
            style: AppStyles.darkPurpleAndBold(24),
            semanticsLabel: Internationalization.internationalization
                .getLocalizations(context, "performance_over_time"),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  _textForStatsWithSemantics("average"),
                  _textForStatsWithSemantics("ao5"),
                  _textForStatsWithSemantics("ao12"),
                  _textForStatsWithSemantics("ao50"),
                  _textForStatsWithSemantics("ao100"),
                ],
              ),
              buildColumn("best", bestTimes),
              buildColumn("worst", worstTimes),
              buildColumn("current", currentTimes),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(
            color: AppColors.darkPurpleColor,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: _textForStatsWithSemantics("aoTotal")),
              Expanded(
                  child: Center(
                child: Tooltip(
                  message: Internationalization.internationalization
                      .getLocalizations(context, "aoTotal_label"),
                  child: Text(
                    aoTotal,
                    style: AppStyles.darkPurple(15),
                    semanticsLabel: Internationalization.internationalization
                        .getLocalizations(context, "aoTotal"),
                  ),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  /// Método auxiliar interno que construye un widget de texto estilizado
  /// con accesibilidad.
  ///
  /// Parámetros:
  /// - `key`: Clave que se usa para obtener las cadenas localizadas
  /// para el label y el hint.
  ///
  /// Retorna:
  /// - `Widget`: Un widget `Text` accesible, usando estilos definidos por la app.
  Widget _textForStatsWithSemantics(String key) {
    return AppStyles.textWithSemanticsAndTooltip(
      context,
      "${key}_hint",
      "${key}_label",
      key,
      AppStyles.darkPurpleAndBold(15),
    );
  }
}