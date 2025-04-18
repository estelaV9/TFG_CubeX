import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa las preferencias de notificaciones del usuario en la aplicación.
///
/// Esta clase permite configurar y guardar los diferentes tipos de notificaciones
/// que un usuario puede activar o desactivar según sus preferencias personales.
class AppNotification {
  /// Indica si las notificaciones están activadas en general.
  ///
  /// Si esta opción está desactivada, ninguna otra notificación se enviará,
  /// independientemente de los otros campos configurados.
  final bool isActive;

  /// Indica si las notificaciones diarias están activadas.
  final bool dailyNotifications;

  /// Indica si las notificaciones de motivación semanal están activadas.
  final bool weeklyMotivation;

  /// Indica si las notificaciones por nuevos récords están activadas.
  final bool newRecordNotification;

  /// Indica si los recordatorios de entrenamiento están activados.
  final bool trainingReminders;

  /// Indica si el resumen semanal está activado.
  final bool weeklySummary;

  /// Indica si las notificaciones por inactividad están activadas.
  final bool inactivityNotification;

  /// Indica si las estadísticas semanales están activadas.
  final bool weeklyStats;

  /// Constructor de la clase [AppNotification].
  ///
  /// Por defecto, si las notificaciones están activadas (`isActive = true`), también
  /// se activan por defecto las notificaciones diarias, de nuevos récords e inactividad.
  AppNotification({
    this.isActive = true,
    this.dailyNotifications = true,
    this.weeklyMotivation = false,
    this.newRecordNotification = true,
    this.trainingReminders = false,
    this.weeklySummary = false,
    this.inactivityNotification = true,
    this.weeklyStats = false,
  });

  /// Guarda las preferencias de notificación en [SharedPreferences].
  ///
  /// Este método guarda cada una de las configuraciones para que puedan
  /// ser recuperadas.
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setBool("isActive", isActive);
    await prefs.setBool("dailyNotifications", dailyNotifications);
    await prefs.setBool("weeklyMotivation", weeklyMotivation);
    await prefs.setBool("newRecordNotification", newRecordNotification);
    await prefs.setBool("trainingReminders", trainingReminders);
    await prefs.setBool("weeklySummary", weeklySummary);
    await prefs.setBool("inactivityNotification", inactivityNotification);
    await prefs.setBool("weeklyStats", weeklyStats);
  }
}