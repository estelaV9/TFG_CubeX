import 'package:shared_preferences/shared_preferences.dart';

/// Este provider representa la configuración del **temporizador (timer)** de resolución.
///
/// Esta clase gestiona distintas opciones de configuración del temporizador,
/// como la visibilidad del tiempo mientras se ejecuta, alertas al batir récords,
/// y la funcionalidad de inspección previa a la resolución.
/// Las configuraciones se almacenan en `SharedPreferences` para que persistan
/// entre sesiones del usuario.
class ConfigurationTimer {
  /// Indica si se debe ocultar el tiempo mientras se realiza una resolución.
  final bool hideRunningTime;

  /// Indica si se debe mostrar una alerta cuando se bate un nuevo **récord personal (PB)**.
  final bool recordTimeAlert;

  /// Indica si se debe mostrar una alerta al superar el mejor **promedio personal**.
  final bool bestAverageAlert;

  /// Indica si se debe mostrar una alerta al obtener el **peor tiempo registrado (worst PB)**.
  final bool worstTimeAlert;

  /// Define si está habilitada la **inspección** previa a iniciar la resolución.
  final bool isActiveInspection;

  /// Tiempo en segundos asignado para la **inspección previa** a la resolución.
  final int inspectionSeconds;

  /// Constructor que permite establecer las configuraciones del temporizador.
  ///
  /// Por defecto estarán desactivados menos la alerta para el tiempo record y la inspección.
  /// Además, el valor predeterminado de los segundos de la inspección serán 15.
  ConfigurationTimer(
      {this.hideRunningTime = false,
      this.recordTimeAlert = true,
      this.bestAverageAlert = false,
      this.worstTimeAlert = false,
      this.isActiveInspection = true,
      this.inspectionSeconds = 15});

  // SHARED PREFEERNCES PARA LAS CONFIGURACIONES DEL TIMER
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas para guardar y cargar las
  /// configuraciones del timer.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setBool("hideRunningTime", false);
      await preferences.setBool("recordTimeAlert", false);
      await preferences.setBool("bestAverageAlert", false);
      await preferences.setBool("worstTimeAlert", false);
      await preferences.setBool("isActiveInspection", true);
      await preferences.setInt("inspectionSeconds", 15);
    }
  }

  /// Guarda las preferencias de las configuraciones del timer en [SharedPreferences].
  ///
  /// Este método guarda cada una de las configuraciones para que puedan
  /// ser recuperadas.
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setBool("hideRunningTime", hideRunningTime);
    await prefs.setBool("recordTimeAlert", recordTimeAlert);
    await prefs.setBool("bestAverageAlert", bestAverageAlert);
    await prefs.setBool("worstTimeAlert", worstTimeAlert);
    await prefs.setBool("isActiveInspection", isActiveInspection);
    await prefs.setInt("inspectionSeconds", inspectionSeconds);
  }
}