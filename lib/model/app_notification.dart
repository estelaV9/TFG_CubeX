import 'package:esteladevega_tfg_cubex/model/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa las preferencias de notificaciones del usuario en la aplicación.
///
/// Esta clase tiene la configuración individual de cada tipo de notificación
/// que puede recibir el usuario, permitiendo activar o desactivar cada una según sus
/// necesidades. Además, permite guardar y recuperar estas preferencias desde almacenamiento local.
///
/// Incluye opciones como:
/// - Activación global de notificaciones.
/// - Notificaciones diarias.
/// - Motivación semanal.
/// - Avisos por nuevos récords.
/// - Recordatorios de entrenamiento.
/// - Alertas por inactividad.
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

  /// Indica si las notificaciones por inactividad están activadas.
  final bool inactivityNotification;

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
    this.inactivityNotification = true,
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
    await prefs.setBool("inactivityNotification", inactivityNotification);
  }

  // SHARED PREFEERNCES PARA LAS NOTIFICACIONES
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas para guardar y cargar la notificaciones.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setBool("isActive", true);
      await preferences.setBool("dailyNotifications", false);
      await preferences.setBool("newRecordNotification", true);
      await preferences.setBool("trainingReminders", false);
      await preferences.setBool("inactivityNotification", true);
    }
  }

  /// Método para todas las notificaciones configuradas por el usuario.
  ///
  /// Este método revisa las preferencias de notificación activadas y
  /// agenda cada una para su ejecución futura. Si las notificaciones
  /// están desactivadas globalmente (`isActive == false`), no se agenda nada.
  ///
  /// Las notificaciones que se pueden programar son:
  /// - **Notificación diaria**: Todos los días a las 9:00 AM.
  /// - **Motivación semanal**: Cada lunes a las 9:00 AM.
  /// - **Recordatorio de entrenamiento**: Todos los días a las 18:00.
  /// - **Notificación por inactividad**: Todos los días a las 20:00.
  ///
  /// Parámetros:
  /// - [context]: El `BuildContext` necesario para mostrar notificaciones.
  Future<void> scheduleAllNotifications(BuildContext context) async {
    // SI LAS NOTIFICACIONES ESTAN DESACTIVADAS EN GENERAL, NO HACEMOS NADA
    if (!isActive) return;

    // FUNCION AUXILIAR QUE CALCULA LA PROXIMA HORA PROGRAMADA (MAÑANA SI YA PASO)
    DateTime nextTimeAt(int hour, int minute) {
      final now = DateTime.now();
      var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      return scheduled;
    }

    if (dailyNotifications) {
      await NotificationService.showNotificationSchedule(
        context,
        1,
        "daily_notifications",
        nextTimeAt(9, 0),
      );
    } // NOTIFICACION DIARIA A LAS 9:00 AM

    if (weeklyMotivation) {
      final now = DateTime.now();
      final nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
      final mondayAt9 =
          DateTime(nextMonday.year, nextMonday.month, nextMonday.day, 9, 0);
      await NotificationService.showNotificationSchedule(
        context,
        2,
        "weekly_motivation",
        mondayAt9,
      );
    } // NOTIFICACION DE MOTIVACION SEMANAL, CADA LUNES A LAS 9:00 AM

    if (trainingReminders) {
      await NotificationService.showNotificationSchedule(
        context,
        3,
        "training_reminders",
        nextTimeAt(18, 0),
      );
    } // RECORDATORIO DE ENTRENAMIENTO A LAS 18:00

    if (inactivityNotification) {
      await NotificationService.showNotificationSchedule(
        context,
        4,
        "inactivity_notification",
        nextTimeAt(20, 0),
      );
    } // NOTIFICACION DE INACTIVIDAD A LAS 20:00
  }
}