import 'package:esteladevega_tfg_cubex/viewmodel/current_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/internationalization.dart';

/// Pantalla para gestionar las **notificaciones personalizadas** de la aplicación.
///
/// Esta pantalla permite al usuario activar o desactivar distintas notificaciones según su preferencia,
/// incluyendo notificaciones diarias, de motivación semanal, nuevos récords, recordatorios de entrenamiento,
/// resúmenes semanales, inactividad y estadísticas.
///
/// Además, permite desactivar todas las notificaciones de forma general.
class ManageNotificationScreen extends StatefulWidget {
  const ManageNotificationScreen({super.key});

  @override
  State<ManageNotificationScreen> createState() =>
      _ManageNotificationScreenState();
}

class _ManageNotificationScreenState extends State<ManageNotificationScreen> {
  /// Widget que genera un `ListTile` personalizado para una opción de notificación.
  ///
  /// Este widget muestra el título, la descripción y un `Switch` que permite
  /// activar o desactivar una opción de notificación específica. Además, incluye accesibilidad
  /// mediante `Semantics`, así como `Tooltips`.
  ///
  /// Parámetros:
  /// - [title]: Clave de localización para personalizar los mensajes (`_title`, `_description`, `_button_hint`, `_button_title`).
  /// - [valueOption]: Valor booleano que determina si el `Switch` está activado o desactivado.
  /// - [keyPreferences]: Clave de localización para identificar y modificar la configuración correspondiente
  ///   en el provider [`CurrentNotifications`].
  Widget listTileOptions(
      String title, bool valueOption, String keyPreferences) {
    return ListTile(
      title:
      Internationalization.internationalization.createLocalizedSemantics(
          context, "${title}_title", "${title}_title", "${title}_title",
          const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          )),
      subtitle:
      Internationalization.internationalization.createLocalizedSemantics(
        context, "${title}_description", "${title}_description", "${title}_description",
        TextStyle(
          fontSize: 15,
          color: Colors.white.withOpacity(0.85),
          height: 1.4,
        ),
      ),
      trailing: Semantics(
        label: Internationalization.internationalization
            .getLocalizations(context, "${title}_button_hint"),
        child: Tooltip(
          message: Internationalization.internationalization
              .getLocalizations(context, "${title}_button_title"),
          child: Switch(
            value: valueOption,
            onChanged: (value) {
              // SI LAS NOTIFICACIONES ESTAN ACTIVAS ENTONCES LAS DESACTIVA
              // SINO CAMBIA EL VALOR DE LA NOTIFICACION
              keyPreferences == "isActive"
                  ? context.read<CurrentNotifications>().turnOffValue()
                  : context .read<CurrentNotifications>().changeValue(keyPreferences, value);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appNotif = context.watch<CurrentNotifications>().notification;

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 80),
        child: ListView(
          children: [
            // PERMITIR LAS NOTIFICACIONES
            listTileOptions(
                "enable_notifications", appNotif.isActive, "isActive"),

            const Divider(),

            // NOTIFICACIONES DIARIAS
            listTileOptions("daily_notifications", appNotif.dailyNotifications,
                "dailyNotifications"),

            // MOTIVACION SEMANAL
            listTileOptions("weekly_motivation", appNotif.weeklyMotivation,
                "weeklyMotivation"),

            // NOTIFICACION RECORD
            listTileOptions("new_record_notification",
                appNotif.newRecordNotification, "newRecordNotification"),

            // RECORDATORIO DE ENTRENAMIENTO
            listTileOptions("training_reminders", appNotif.trainingReminders,
                "trainingReminders"),

            // RESUMEN SEMANAL
            listTileOptions(
                "weekly_summary", appNotif.weeklySummary, "weeklySummary"),

            // NOTIFICACION POR INACTIVIDAD
            listTileOptions("inactivity_notification",
                appNotif.inactivityNotification, "inactivityNotification"),

            // ESTADISTICAS SEMANALES
            listTileOptions(
                "weekly_stats", appNotif.weeklyStats, "weeklyStats"),
          ],
        ));
  }
}