import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/dao/session_dao.dart';
import '../../../data/dao/time_training_dao.dart';
import '../../../data/dao/user_dao.dart';
import '../../../data/database/database_helper.dart';
import '../../../model/session.dart';
import '../../../viewmodel/current_statistics.dart';
import '../../../viewmodel/current_usage_timer.dart';
import '../../utilities/app_color.dart';
import '../../utilities/app_styles.dart';
import '../../utilities/internationalization.dart';

/// Container de estadísticas generales del cubo.
///
/// Este widget muestra un resumen visual y accesible de las estadísticas más relevantes
/// relacionadas con las resoluciones del cubo para una sesión y tipo de cubo actuales.
///
/// Entre los datos presentados se encuentran:
/// - El mejor tiempo (PB)
/// - El peor tiempo (worst)
/// - El número total de resoluciones
/// - El número y porcentaje de penalizaciones DNF y +2
/// - El tiempo total utilizado resolviendo en la sesión actual
///
/// Estas estadísticas se cargan automáticamente cuando se construye el widget,
/// accediendo a información del usuario, la sesión y el tipo de cubo seleccionados.
class GeneralStatisticsContainer extends StatefulWidget {
  const GeneralStatisticsContainer({super.key});

  @override
  State<GeneralStatisticsContainer> createState() =>
      _GeneralStatisticsContainerState();
}

class _GeneralStatisticsContainerState
    extends State<GeneralStatisticsContainer> {
  late String bestSingle = "0:00.00";
  late String worstSingle = "0:00.00";
  late int solveCount = 0;
  late int dnfCount = 0;
  late int plusTwoCount = 0;
  final int solvePercentage = 0;
  late double dnfPercentage = 0;
  late double plusTwoPercentage = 0;
  late final String totalSolveTime = "0:00.00";

  UserDao userDao = UserDao();
  SessionDao sessionDao = SessionDao();

  @override
  void initState() {
    super.initState();
    initTimeStatistics();
  }

  /// Inicializa las estadísticas generales de tiempos para la sesión y tipo de cubo actuales.
  ///
  /// Este método obtiene el ID del usuario actual, la sesión activa y el tipo de cubo seleccionado.
  /// Luego obtiene las estadísticas (mejor tiempo, peor tiempo, cantidad de resoluciones,
  /// penalizaciones, etc.) y actualiza el estado del widget con esos datos.
  ///
  /// Se ejecuta automáticamente en el `initState`.
  Future<void> initTimeStatistics() async {
    int? idUser = await userDao.getUserId(context);
    if (idUser == null) return;

    Session? session = await sessionDao.getSessionData(context, idUser);
    if (session == null) return;

    var statistics = await _getStatistics(session);
    if (statistics == null) return;

    _updateState(statistics['pb'], statistics['worst'], statistics['count'],
        statistics['dnfCnt'], statistics['plusTwoCnt']);
  }

  /// Método que recupera las estadísticas generales de una sesión específica desde la base de datos.
  ///
  /// Parámetros:
  /// - [session]: Objeto [Session] del cual se desea obtener las estadísticas.
  ///
  /// Calcula el mejor tiempo (PB), peor tiempo, total de resoluciones y cantidad de DNF y +2.
  ///
  /// Retorna un [Future<Map<String, dynamic>?>] con las estadísticas o `null`.
  Future<Map<String, dynamic>?> _getStatistics(Session session) async {
    final timeTrainingDao = TimeTrainingDao();
    final currentStatistics = context.read<CurrentStatistics>();

    var timesList = await timeTrainingDao.getTimesOfSession(session.idSession);
    currentStatistics.updateStatistics(timesListUpdate: timesList);

    String pb = await currentStatistics.getPbValue();
    String worst = await currentStatistics.getWorstValue();
    String countStr = await currentStatistics.getCountValue();
    int count = int.tryParse(countStr) ?? 1;
    int dnfCnt = await timeTrainingDao.countPenalty(session.idSession, "DNF");
    int plusTwoCnt =
        await timeTrainingDao.countPenalty(session.idSession, "+2");

    if (dnfCnt == -1 || plusTwoCnt == -1) {
      DatabaseHelper.logger.e("Error al obtener penalizaciones.");
      return null;
    }

    return {
      'pb': pb,
      'worst': worst,
      'count': count,
      'dnfCnt': dnfCnt,
      'plusTwoCnt': plusTwoCnt
    };
  }

  /// Actualiza el estado del widget con los valores de estadísticas calculados.
  ///
  /// Parámetros:
  /// - [pb]: Mejor tiempo registrado.
  /// - [worst]: Peor tiempo registrado.
  /// - [count]: Número total de resoluciones.
  /// - [dnfCnt]: Número de penalizaciones DNF.
  /// - [plusTwoCnt]: Número de penalizaciones +2.
  ///
  /// Este método calcula también los porcentajes de penalizaciones (si la cuenta es al menos de un tiempo)
  /// y actualiza los valores visibles en pantalla.
  void _updateState(
      String pb, String worst, int count, int dnfCnt, int plusTwoCnt) {
    double dnfPer = 0, plusTwoPer = 0;
    // SI LA CUENTA DE DNF O +2 NO ES 0 SE HACE EL PORCENTAJE, SI NO DEVUELVE 0
    if (dnfCnt != 0) {
      dnfPer = (dnfCnt / count) * 100;
    }
    if (plusTwoCnt != 0) {
      plusTwoPer = (plusTwoCnt / count) * 100;
    }

    setState(() {
      bestSingle = pb;
      worstSingle = worst;
      solveCount = count;
      dnfCount = dnfCnt;
      plusTwoCount = plusTwoCnt;
      dnfPercentage = double.parse(dnfPer.toStringAsFixed(2));
      plusTwoPercentage = double.parse(plusTwoPer.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    initTimeStatistics();
    return Container(
      height: 230,
      padding: const EdgeInsets.only(top: 8, right: 20, left: 20, bottom: 20),
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
            child: Internationalization.internationalization.localizedTextOnlyKey(
              context,
              "general_statistics",
              style: AppStyles.darkPurpleAndBold(24),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppStyles.textWithSemanticsAndTooltip(
                    context,
                    "semantic_best_single",
                    "tooltip_best_single",
                    "best_single",
                    const TextStyle(color: AppColors.darkPurpleColor),
                  ),
                  Text(
                    bestSingle,
                    style: AppStyles.darkPurpleAndBold(22),
                    semanticsLabel:
                        "${Internationalization.internationalization.getLocalizations(context, "tooltip_best_single")}: $bestSingle",
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppStyles.textWithSemanticsAndTooltip(
                    context,
                    "semantic_worst_single",
                    "tooltip_worst_single",
                    "worst_single",
                    const TextStyle(color: AppColors.darkPurpleColor),
                  ),
                  Text(
                    worstSingle,
                    style: AppStyles.darkPurpleAndBold(22),
                    semanticsLabel:
                        "${Internationalization.internationalization.getLocalizations(context, "tooltip_worst_single")}: $worstSingle",
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppStyles.textWithSemanticsAndTooltip(
                    context,
                    "semantic_solve_count",
                    "tooltip_solve_count",
                    "solve_count",
                    const TextStyle(color: AppColors.darkPurpleColor),
                  ),
                  Text(
                    solveCount.toString(),
                    style: AppStyles.darkPurpleAndBold(22),
                    semanticsLabel:
                        "${Internationalization.internationalization.getLocalizations(context, "tooltip_solve_count")}: ${solveCount.toString()}",
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 5,
            indent: 10,
            endIndent: 10,
            color: AppColors.darkPurpleColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppStyles.textWithSemanticsAndTooltip(
                        context,
                        "semantic_dnf_count",
                        "tooltip_dnf_count",
                        "dnf_count",
                        const TextStyle(color: AppColors.darkPurpleColor),
                      ),
                      Text(
                        dnfCount.toString(),
                        style: AppStyles.darkPurpleAndBold(22),
                        semanticsLabel:
                            "${Internationalization.internationalization.getLocalizations(context, "tooltip_dnf_count")}: ${dnfCount.toString()}",
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppStyles.textWithSemanticsAndTooltip(
                        context,
                        "semantic_plus_two_count",
                        "tooltip_plus_two_count",
                        "plus_two_count",
                        const TextStyle(color: AppColors.darkPurpleColor),
                      ),
                      Text(
                        plusTwoCount.toString(),
                        style: AppStyles.darkPurpleAndBold(22),
                        semanticsLabel:
                            "${Internationalization.internationalization.getLocalizations(context, "tooltip_plus_two_count")}: ${plusTwoCount.toString()}",
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppStyles.textWithSemanticsAndTooltip(
                        context,
                        "semantic_dnf_percentage",
                        "tooltip_dnf_percentage",
                        "dnf_percentage",
                        const TextStyle(color: AppColors.darkPurpleColor),
                      ),
                      Text("${dnfPercentage.toStringAsFixed(2).toString()}%",
                          style: AppStyles.darkPurpleAndBold(22),
                          semanticsLabel:
                              "${Internationalization.internationalization.getLocalizations(context, "tooltip_dnf_percentage")}: ${dnfPercentage.toStringAsFixed(2).toString()}%"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppStyles.textWithSemanticsAndTooltip(
                        context,
                        "semantic_plus_two_percentage",
                        "tooltip_plus_two_percentage",
                        "plus_two_percentage",
                        const TextStyle(color: AppColors.darkPurpleColor),
                      ),
                      Text(
                        "${plusTwoPercentage.toStringAsFixed(2).toString()}%",
                        style: AppStyles.darkPurpleAndBold(22),
                        semanticsLabel:
                            "${Internationalization.internationalization.getLocalizations(context, "tooltip_plus_two_percentage")}: ${plusTwoPercentage.toStringAsFixed(2).toString()}%",
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppStyles.textWithSemanticsAndTooltip(
                      context,
                      "semantic_total_solve_time",
                      "tooltip_total_solve_time",
                      "total_solve_time",
                      const TextStyle(color: AppColors.darkPurpleColor),
                    ),
                    Consumer<CurrentUsageTimer>(
                        builder: (context, timer, child) {
                      String formattedTime =
                          CurrentUsageTimer.formatTime(timer.secondsUsed);
                      return Text(
                        formattedTime,
                        style: AppStyles.darkPurpleAndBold(22),
                        semanticsLabel:
                            "${Internationalization.internationalization.getLocalizations(context, "tooltip_total_solve_time")}: $formattedTime",
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
