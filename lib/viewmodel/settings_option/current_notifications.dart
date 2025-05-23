import 'package:flutter/cupertino.dart';

import '../../model/app_notification.dart';

/// Provider para gestionar el estado actual de las **notificaciones** en la aplicación.
///
/// Este provider permite activar, desactivar, restablecer y personalizar
/// los distintos tipos de notificaciones que ofrece la aplicación.
/// Las configuraciones se almacenan en `SharedPreferences` para que persistan
/// entre sesiones del usuario.
class CurrentNotifications extends ChangeNotifier {
  /// Configuraciones actuales de notificaciones, iniciando por si estan habilitadas/deshabilitadas según
  /// lo que se guardó en las preferencias de la aplicación.
  AppNotification notification = AppNotification(
      isActive: AppNotification.preferences.getBool("isActive") ?? false);

  /// Preferencias de las notificaciones (`SharedPreferences`) de la aplicación.
  final prefs = AppNotification.preferences;

  /// Método que restablece las notificaciones a sus valores por defecto.
  ///
  /// Activa las notificaciones generales, así como las diarias,
  /// de nuevos récords y de inactividad. Desactiva las demás por defecto.
  ///
  /// Guarda los valores en `SharedPreferences` y notifica a los listeners.
  void resetValue() async {
    final prefs = AppNotification.preferences;
    notification = AppNotification(
      isActive: true,
      dailyNotifications: true,
      weeklyMotivation: false,
      newRecordNotification: true,
      trainingReminders: false,
      inactivityNotification: true,
    );
    await notification.saveToPreferences(prefs);
    notifyListeners();
  }

  /// Método que desactiva **todas las notificaciones**.
  ///
  /// Guarda los valores en `SharedPreferences` y notifica a los listeners.
  void turnOffValue() async {
    final prefs = AppNotification.preferences;
    notification = AppNotification(
      isActive: false,
      dailyNotifications: false,
      weeklyMotivation: false,
      newRecordNotification: false,
      trainingReminders: false,
      inactivityNotification: false,
    );
    await notification.saveToPreferences(prefs);
    notifyListeners();
  }

  /// Método que modifica un valor específico de configuración de notificación.
  ///
  /// Este método permite modificar una opción concreta de notificación,
  /// actualizando el objeto `AppNotification`, guardando el cambio en
  /// `SharedPreferences`, y notificando a los listeners.
  ///
  /// Parámetros:
  /// - [key]: Clave que representa el nombre del campo a modificar.
  /// - [value]: Nuevo valor booleano que se desea asignar.
  void changeValue(String key, bool value) async {
    final prefs = AppNotification.preferences;

    switch (key) {
      case 'isActive':
        notification = AppNotification(
          isActive: value,
          dailyNotifications: notification.dailyNotifications,
          weeklyMotivation: notification.weeklyMotivation,
          newRecordNotification: notification.newRecordNotification,
          trainingReminders: notification.trainingReminders,
          inactivityNotification: notification.inactivityNotification,
        );
        break;
      case 'dailyNotifications':
        notification = AppNotification(
          isActive: notification.isActive,
          dailyNotifications: value,
          weeklyMotivation: notification.weeklyMotivation,
          newRecordNotification: notification.newRecordNotification,
          trainingReminders: notification.trainingReminders,
          inactivityNotification: notification.inactivityNotification,
        );
        break;
      case 'weeklyMotivation':
        notification = AppNotification(
          isActive: notification.isActive,
          dailyNotifications: notification.dailyNotifications,
          weeklyMotivation: value,
          newRecordNotification: notification.newRecordNotification,
          trainingReminders: notification.trainingReminders,
          inactivityNotification: notification.inactivityNotification,
        );
        break;
      case 'newRecordNotification':
        notification = AppNotification(
          isActive: notification.isActive,
          dailyNotifications: notification.dailyNotifications,
          weeklyMotivation: notification.weeklyMotivation,
          newRecordNotification: value,
          trainingReminders: notification.trainingReminders,
          inactivityNotification: notification.inactivityNotification,
        );
        break;
      case 'trainingReminders':
        notification = AppNotification(
          isActive: notification.isActive,
          dailyNotifications: notification.dailyNotifications,
          weeklyMotivation: notification.weeklyMotivation,
          newRecordNotification: notification.newRecordNotification,
          trainingReminders: value,
          inactivityNotification: notification.inactivityNotification,
        );
        break;
      case 'inactivityNotification':
        notification = AppNotification(
          isActive: notification.isActive,
          dailyNotifications: notification.dailyNotifications,
          weeklyMotivation: notification.weeklyMotivation,
          newRecordNotification: notification.newRecordNotification,
          trainingReminders: notification.trainingReminders,
          inactivityNotification: value,
        );
        break;
    }

    await notification.saveToPreferences(prefs);
    notifyListeners();
  }
}