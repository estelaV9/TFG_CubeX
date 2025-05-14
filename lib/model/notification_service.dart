import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../view/utilities/internationalization.dart';

/// Clase **NotificationService** encargada de manejar las notificaciones locales
/// en la aplicación, incluyendo la inicialización, solicitud de permisos, y la
/// creación de notificaciones tanto simples como programadas.
///
/// Esta clase proporciona métodos para gestionar las notificaciones en plataformas
/// Android e iOS, solicitando los permisos necesarios y mostrando notificaciones.
///
/// Métodos principales:
/// - **initNotification**: Inicializa las notificaciones en la aplicación.
/// - **requestNotificationPermissions**: Solicita permisos de notificación.
/// - **checkNotificationPermissions**: Verifica si los permisos de notificación están activados.
/// - **showNotification**: Muestra una notificación simple.
/// - **showNotificationSchedule**: Muestra una notificación programada en una fecha específica.
class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Método para inicializar las notificaciones locales.
  ///
  /// Este método configura los parámetros necesarios para inicializar las
  /// notificaciones en plataformas Android e iOS. Si la plataforma es Android o iOS,
  /// se configuran los permisos para recibir notificaciones y se solicita permiso
  /// al usuario si es necesario.
  ///
  /// Retorna `true` si la inicialización fue exitosa y los permisos fueron concedidos o
  /// `false` si la plataforma no es Android ni iOS, o si los permisos no se concedieron.
  static Future<bool> initNotification() async {
    // SI NO ES ANDROID NI IOS, NO HACE NADA POR AHORA
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false;
    }

    // CONFIGURACION PARA ANDROID
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // CONFIGURACION PARA IOS
    const DarwinInitializationSettings initSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // CONFIGURACION GENERAL DE INICIALIZACION
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // INICIALIZAMOS EL PLUGIN
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // LUEGO PEDIMOS LOS PERMISOS
    return await requestNotificationPermissions();
  }

  /// Método para solicitar permisos de notificación.
  ///
  /// Este método solicita permisos de notificación al usuario dependiendo
  /// de la plataforma. En Android, se utiliza el paquete `permission_handler`
  /// para solicitar los permisos, mientras que en iOS se usa la API de
  /// `flutter_local_notifications` para gestionarlos.
  ///
  /// Retorna `true` si el permiso fue concedido o`false` si el permiso fue
  /// denegado o si no es posible solicitarlo en la plataforma.
  static Future<bool> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      // SI ES ANDROID
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // SI ES OIS
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return false;
  }

  /// Método para verificar si los permisos de notificación están activos.
  ///
  /// Este método comprueba si la aplicación tiene permisos de notificación.
  /// En Android, se verifica el estado de los permisos utilizando `permission_handler`.
  /// En iOS, se asume que los permisos están activos después de haber sido solicitados.
  ///
  /// Retorna `true` si los permisos están concedidos o `false` si los permisos no están
  /// concedidos o no son verificables en la plataforma.
  static Future<bool> checkNotificationPermissions() async {
    if (Platform.isAndroid) {
      return await Permission.notification.status.isGranted;
    } else if (Platform.isIOS) {
      // EN IOS NO SE PUEDE VERIFICAR FACILMENTE, ASIQUE ASUMIMOS QUE ES TRUE TRAS PEDIRLOS
      return true;
    }
    return false;
  }

  /// Método para mostrar una notificación simple.
  ///
  /// Este método crea y muestra una notificación local con un título y un cuerpo.
  /// Primero verifica si los permisos de notificación están activos, y si no lo
  /// están, solicita al usuario que los conceda. Si no se conceden, se muestra
  /// un mensaje de error.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación para internacionalizar el texto de la notificación.
  /// - `id`: El ID único de la notificación.
  /// - `titleKey`: La clave para obtener el título de la notificación.
  /// - `bodyKey`: La clave para obtener el cuerpo de la notificación.
  ///
  /// Si los permisos son concedidos, se muestra la notificación en la pantalla.
  static Future<void> showNotification({
    required BuildContext context,
    required int id,
    required String titleKey,
    required String bodyKey,
  }) async {
    // INTERNACIONALIZAMOS LA ALERTA
    final title = Internationalization.internationalization
        .getLocalizations(context, titleKey);
    final body = Internationalization.internationalization
        .getLocalizations(context, bodyKey);

    // PRIMERO COMPROBAMOS PERMISOS
    bool hasPermission = await checkNotificationPermissions();

    if (!hasPermission) {
      hasPermission = await requestNotificationPermissions();
      if (!hasPermission) {
        // MOSTRAR UN ERROR SI NO TIENE PERMISOS
        AlertUtil.showSnackBarError(context, "notification_permissions_denied");
        return;
      }
    }

    // DETALLES DE LA NOTIFICACION
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // MOSTRAMOS LA NOTIFICACION
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
    );
  }

  /// Método para mostrar una notificación programada.
  ///
  /// Este método permite programar una notificación que se mostrará en una fecha
  /// y hora específicas. La notificación será enviada con el título y el cuerpo
  /// proporcionados, y se mostrará en el horario definido.
  ///
  /// Parámetros:
  /// - `title`: El título de la notificación.
  /// - `body`: El cuerpo de la notificación.
  /// - `scheduleDate`: La fecha y hora en que debe aparecer la notificación.
  static Future<void> showNotificationSchedule(BuildContext context, int id,
      String title, DateTime scheduleDate) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails("cubex_channel", "CubeX Notification",
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        Internationalization.internationalization.getLocalizations(context, "${title}_title"),
        Internationalization.internationalization.getLocalizations(context, "${title}_content"),
        tz.TZDateTime.from(scheduleDate, tz.local),
        platformDetails,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }
}