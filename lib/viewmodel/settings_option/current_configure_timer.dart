import 'package:esteladevega_tfg_cubex/model/configuration_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para gestionar el estado actual de las **configuraciones del timer** en la aplicación.
///
/// Esta clase permite acceder y modificar las distintas opciones de configuración
/// relacionadas con el temporizador, como la visibilidad del tiempo durante la resolución,
/// las alertas de récords, el sistema de inspección previa y el tipo de alerta en los
/// oche y doce segundos de inspección.
///
/// Las configuraciones se almacenan y recuperan desde `SharedPreferences`,
/// permitiendo que los valores persistan entre sesiones del usuario.
class CurrentConfigurationTimer extends ChangeNotifier {
  ConfigurationTimer configurationTimer = ConfigurationTimer(
      hideRunningTime: ConfigurationTimer.preferences.getBool("hideRunningTime") ?? false,
      recordTimeAlert: ConfigurationTimer.preferences.getBool("recordTimeAlert") ?? true,
      bestAverageAlert: ConfigurationTimer.preferences.getBool("bestAverageAlert") ?? false,
      worstTimeAlert: ConfigurationTimer.preferences.getBool("worstTimeAlert") ?? false,
      isActiveInspection: ConfigurationTimer.preferences.getBool("isActiveInspection") ?? true,
      inspectionSeconds: ConfigurationTimer.preferences.getInt("inspectionSeconds") ?? 15,
      alertAt8And12Seconds: ConfigurationTimer.preferences.getBool("alertAt8And12Seconds") ?? false,
      inspectionAlertType: ConfigurationTimer.returnInspectinoTypeString(
          ConfigurationTimer.preferences.getString("inspectionAlertType") ??
              InspectionAlertType.vibrant.name));

  /// Preferencias de las configuraciones del timer (`SharedPreferences`) de la aplicación.
  final SharedPreferences prefs = ConfigurationTimer.preferences;

  /// Método que restablece las configuraciones del timer a sus valores por defecto.
  ///
  /// Activa la alerta del tiempo record y todas las demás se desactivan.
  ///
  /// Guarda los valores en `SharedPreferences` y notifica a los listeners.
  void resetValue() async {
    configurationTimer = ConfigurationTimer(
        hideRunningTime: false,
        recordTimeAlert: true,
        bestAverageAlert: false,
        worstTimeAlert: false);
    await configurationTimer.saveToPreferences(prefs);
    notifyListeners();
  }

  /// Método que desactiva **todas las configuraciones** menos las relacionadas con el tiempo de inspección.
  ///
  /// Guarda los valores en `SharedPreferences` y notifica a los listeners.
  void turnOffValue() async {
    configurationTimer = ConfigurationTimer(
        hideRunningTime: false,
        recordTimeAlert: false,
        bestAverageAlert: false,
        worstTimeAlert: false);
    await configurationTimer.saveToPreferences(prefs);
    notifyListeners();
  }

  /// Método que modifica un valor específico de configuración del timer.
  ///
  /// Este método permite modificar una opción concreta de configuración,
  /// actualizando el objeto `ConfigurationTimer`, guardando el cambio en
  /// `SharedPreferences`, y notificando a los listeners.
  ///
  /// Solo los parámetros proporcionados serán actualizados. Los que se omitan
  /// mantendrán su valor actual.
  ///
  /// Parámetros opcionales:
  /// - [hideRunningTime]: Oculta el tiempo durante una resolución.
  /// - [recordTimeAlert]: Muestra una alerta cuando se bate el mejor tiempo (PB).
  /// - [bestAverageAlert]: Muestra una alerta cuando se bate el mejor promedio.
  /// - [worstTimeAlert]: Muestra una alerta cuando se bate el peor tiempo registrado.
  /// - [isActiveInspection]: Activa o desactiva la cuenta atrás de inspección.
  /// - [inspectionSeconds]: Número de segundos para la inspección antes de iniciar.
  /// - [alertAt8And12Seconds]: Activa/desactiva la alerta de los ocho y doce segundos en el
  ///   tiempo de inspección.
  /// - [inspectionAlertType]: Tipo de alerta si esta activada la alerta en el tiempo de inspección.
  void changeValue({
    bool? hideRunningTime,
    bool? recordTimeAlert,
    bool? bestAverageAlert,
    bool? worstTimeAlert,
    bool? isActiveInspection,
    int? inspectionSeconds,
    bool? alertAt8And12Seconds,
    InspectionAlertType? inspectionAlertType,
  }) async {
    configurationTimer = ConfigurationTimer(
      hideRunningTime: hideRunningTime ?? configurationTimer.hideRunningTime,
      recordTimeAlert: recordTimeAlert ?? configurationTimer.recordTimeAlert,
      bestAverageAlert: bestAverageAlert ?? configurationTimer.bestAverageAlert,
      worstTimeAlert: worstTimeAlert ?? configurationTimer.worstTimeAlert,
      isActiveInspection: isActiveInspection ?? configurationTimer.isActiveInspection,
      inspectionSeconds: inspectionSeconds ?? configurationTimer.inspectionSeconds,
      alertAt8And12Seconds: alertAt8And12Seconds ?? configurationTimer.alertAt8And12Seconds,
      inspectionAlertType: inspectionAlertType ?? configurationTimer.inspectionAlertType,
    );
    await configurationTimer.saveToPreferences(prefs);
    notifyListeners();
  }
}