import 'package:shared_preferences/shared_preferences.dart';

/// Este provider representa la configuración del **temporizador (timer)** de resolución.
///
/// Esta clase gestiona distintas opciones de configuración del temporizador,
/// como la visibilidad del tiempo mientras se ejecuta, alertas al batir récords,
/// y la funcionalidad de inspección previa a la resolución.
/// Además permite controlar si el usuario desea alertas en los ocho y doce segundos
/// en el tiempo de inspección, puediendo elegir el tipo de alerta que prefiera.
///
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

  /// Alerta a los 8 y 12 segundos de inspección
  final bool alertAt8And12Seconds;

  /// Tipo de alerta durante la inspección: "vibration", "sound", "both"
  final InspectionAlertType inspectionAlertType;

  /// Constructor que permite establecer las configuraciones del temporizador.
  ///
  /// Por defecto estarán desactivados menos la alerta para el tiempo record y la inspección.
  /// Además, el valor predeterminado de los segundos de la inspección serán 15 y, si esta
  /// activada la alerta de los ocho y doce segundos, esta sera por defecto la de vibración.
  ConfigurationTimer(
      {this.hideRunningTime = false,
      this.recordTimeAlert = true,
      this.bestAverageAlert = false,
      this.worstTimeAlert = false,
      this.isActiveInspection = true,
      this.inspectionSeconds = 15,
      this.alertAt8And12Seconds = false,
      this.inspectionAlertType = InspectionAlertType.vibrant});

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
      await preferences.setBool("alertAt8And12Seconds", false);
      await preferences.setString("inspectionAlertType", InspectionAlertType.vibrant.toString());
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
    await prefs.setBool("alertAt8And12Seconds", alertAt8And12Seconds);
    await prefs.setString("inspectionAlertType", inspectionAlertType.toString());
  }

  /// Método para obtener el tipo de alerta de inspección a partir de un `String`.
  ///
  /// Este método recibe un valor `String` y retorna un valor de tipo `InspectionAlertType`,
  /// que puede ser: `sound`, `vibrant`, o `both`. Si el `String` no
  /// coincide con ninguno de estos valores, se asigna por defecto `vibrant`.
  ///
  /// Parámetros:
  /// - `alertTypeString`: Un `String` que representa el tipo de alerta.
  static InspectionAlertType returnInspectinoTypeString(
      String alertTypeString) {
    InspectionAlertType alertType;
    switch (alertTypeString) {
      case 'sound':
        alertType = InspectionAlertType.sound;
        break;
      case 'vibrant':
        alertType = InspectionAlertType.vibrant;
        break;
      case 'both':
        alertType = InspectionAlertType.both;
        break;
      default:
        alertType = InspectionAlertType.vibrant;
    }
    return alertType;
  }
}

/// Enum que representa los tipos posibles de alerta de inspección.
///
/// Los tipos son:
/// - `sound`: Alerta con sonido.
/// - `vibrant`: Alerta con vibración.
/// - `both`: Alerta combinada (con sonido y vibración).
enum InspectionAlertType { sound, vibrant, both }
