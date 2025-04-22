import 'package:esteladevega_tfg_cubex/view/components/appbar_class.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings_options/manage_disabled_notification_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings_options/manage_notification_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/settings_option/current_notifications.dart';
import '../../../model/app_notification.dart';

/// Pantalla principal de gestión de notificaciones.
///
/// Esta pantalla permite al usuario gestionar las configuraciones relacionadas con
/// las notificaciones de la aplicación. Dependiendo del estado actual de las notificaciones,
/// se muestra una pantalla con opciones para gestionarlas (`ManageNotificationScreen`)
/// o una pantalla alternativa para volver a activarlas (`ManageDisabledNotificationScreen`).
///
/// Además, tiene un AppBar con un botón de reinicio para restablecer las
/// configuraciones de notificaciones a sus valores por defecto si las notificaciones
/// están activadas.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    AppNotification? isActiveNotifications =
        context.watch<CurrentNotifications>().notification;

    return Scaffold(
      appBar: AppBarClass.appBarWithReset(
          context, "notification", isActiveNotifications),
      body: Container(
        decoration: AppStyles.boxDecorationContainer(),
        child: SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: // SI ESTAN ACTIVAS LAS NOTIFICACIONES MANDA A LA PANTALLA DE NOTIFICACIONES
                  // SI NO MUESTRA UN BOTON PARA ACTIVAR LAS NOTIFICACIONES
                  isActiveNotifications.isActive
                      ? const ManageNotificationScreen()
                      : const ManageDisabledNotificationScreen()),
        ),
      ),
    );
  }
}
