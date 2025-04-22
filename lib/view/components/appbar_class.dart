import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/app_notification.dart';
import '../../viewmodel/settings_option/current_notifications.dart';
import '../utilities/app_color.dart';
import '../utilities/internationalization.dart';

/// Clase **AppBarClass** que contiene métodos estáticos para construir AppBars
/// personalizados dentro de la aplicación.
class AppBarClass {
  /// Método para crear un AppBar con botón de para ir para atrás y título.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación para acceder a la internacionalización.
  /// - `key`: La clave para obtener el texto traducido que se usará como título.
  static AppBar appBarWithBack(BuildContext context, String key) {
    return AppBar(
      title: Internationalization.internationalization.localizedTextOnlyKey(
        context,
        key,
        style: const TextStyle(fontFamily: 'Broadway', fontSize: 35),
      ),
      centerTitle: true,
      backgroundColor: AppColors.lightVioletColor,
    );
  }

  /// Método para crear un AppBar con un botón para reiniciar notificaciones.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación para mostrar el botón y manejar el estado.
  /// - `key`: La clave para obtener el título internacionalizado del AppBar.
  /// - `isActiveNotifications`: Objeto `AppNotification` que indica si las notificaciones están activas.
  ///
  /// Retorna un `AppBar` que permite restablecer las configuraciones de notificaciones, si están activas.
  static AppBar appBarWithReset(BuildContext context, String key,
      AppNotification? isActiveNotifications) {
    return AppBar(
      title: Stack(
        children: [
          // TITULO CENTRADO
          Padding(
            // LO LLEVAMOS A LA IZQUIERDA PARA QUE ESTE CENTRADO
            padding: const EdgeInsets.only(right: 35),
            child: Align(
              alignment: Alignment.center,
              child: Internationalization.internationalization
                  .localizedTextOnlyKey(
                context,
                key,
                style: const TextStyle(fontFamily: 'Broadway', fontSize: 35),
              ),
            ),
          ),

          // BOTON RESET A LA DERECHA SI ESTAN ACTIVADAS LAS NOTIFICACIONES
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              // UBICAR EL BOTON SIGUIENDO EL FINAL DE LAS LETRAS DE NOTIFICATIONS
              padding: const EdgeInsets.only(top: 8),
              child: isActiveNotifications!.isActive == true
                  ? Tooltip(
                      message: Internationalization.internationalization
                          .getLocalizations(
                              context, "reset_notifications_button"),
                      child: TextButton(
                        onPressed: () {
                          // SE PONE POR DEFECTO ACTIVA LAS DE DIARIO, RECORD E INACTIVIDAD
                          context.read<CurrentNotifications>().resetValue();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                            Internationalization.internationalization
                                .getLocalizations(context, "reset"),
                            style: TextStyle(
                                color: AppColors.titlePurple.withOpacity(0.8))),
                      ),
                    )
                  : // TEXTO VACIO
                  const Text(""),
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: AppColors.lightVioletColor,
    );
  }
}