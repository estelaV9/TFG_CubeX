import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../data/database/database_helper.dart';
import '../../../model/notification_service.dart';
import '../../../viewmodel/settings_option/current_notifications.dart';
import '../../utilities/app_color.dart';
import '../../utilities/app_styles.dart';
import '../../utilities/internationalization.dart';

/// Pantalla de activación de notificaciones.
///
/// Esta pantalla se muestra cuando las notificaciones están desactivadas.
/// Permite al usuario volver a habilitarlas solicitando los permisos necesarios
/// del sistema. También gestiona automáticamente los cambios de estado de la
/// aplicación para detectar si el usuario ha modificado los permisos desde los ajustes.
class ManageDisabledNotificationScreen extends StatefulWidget {
  const ManageDisabledNotificationScreen({super.key});

  @override
  State<ManageDisabledNotificationScreen> createState() =>
      _ManageDisabledNotificationScreenState();
}

class _ManageDisabledNotificationScreenState
    extends State<ManageDisabledNotificationScreen>
    with WidgetsBindingObserver {
  // ATRIBUTO PARA EL HOVER DEL BOTON DE ACTIVAR LAS NOTIFICACIONES
  bool _isHovering = false;

  /// Registra el observador del ciclo de vida de la app al inicializar el widget.
  ///
  /// Esto permite detectar cambios en el estado de la aplicación, como cuando se
  /// vuelve al primer plano después de haber estado en segundo plano. (utilizado para los ajustes)
  @override
  void initState() {
    super.initState();
    // REGISTRAMOS EL OBSERVEER PARA DETECTAR CAMBIOS
    WidgetsBinding.instance.addObserver(this);
  }

  /// Elimina el observador del ciclo de vida al destruir el widget.
  @override
  void dispose() {
    // DESREGISTRAMOS EL OBSERVER
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Método que se ejecuta cuando cambia el estado del ciclo de vida de la app.
  ///
  /// Si la app vuelve al primer plano (`resumed`), se comprueba si el usuario ha
  /// modificado los permisos de notificación desde los ajustes del dispositivo.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // CUANDO LA APP VUELVE AL PRIMER PLANO SE CHEQUEAN LOS PERMISOS
      _checkNotificationPermissions();
    }
  } // ESTE METODO SE LLAMARA CUANDO LA APP CAMBIE SU ESTADO DE CICLO DE VIDA
  // ES DECIR, CUANDO EL USUARIO SE VAYA DE LA APP Y VUELVA SE CHEQUEARA LOS PERMISOS
  // POR SI HA IDO A QUITAR EL PERMISO DE AJUSTES

  /// Comprueba si los permisos de notificación están activados.
  ///
  /// Si lo están, actualiza el estado global y muestra un mensaje. Si no, actualiza
  /// el estado a desactivado.
  /// Así, si el usuario permite las notificaciones y luego en los ajustes lo deshabilita
  /// se controla para que no pueda gestionar las notificaciones hasta que no sean activadas.
  Future<void> _checkNotificationPermissions() async {
    final status = await Permission.notification.status;
    final configuration = context.read<CurrentNotifications>();

    if (status.isGranted) {
      // SI EL USUARIO HA ACTIVADO LAS NOTIFICACIONES SE CAMBIA EL SHARED PREFERENCE A TRUE
      if (mounted) {
        configuration.changeValue("isActive", true);
        AlertUtil.showSnackBarInformation(context, "active_notifications");
      }
    } else {
      // SI NO SE CAMBIA A FALSE
      if (mounted) configuration.changeValue("isActive", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configuration = context.read<CurrentNotifications>();

    return Stack(
      children: [
        // IMAGEN UBICADO UN POCO ANTES DEL CENTRO
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 240, bottom: 40),
            child: Image.asset(
              "assets/cubix/cubix_notification.png",
              width: 200,
            ),
          ),
        ),

        // TEXTOS Y BOTON ABAJO
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 500, right: 20, left: 20),
            child: Column(
              // PARA QUE SOLO OCUPE LO NECESARIO
              mainAxisSize: MainAxisSize.min,
              children: [
                // TITULO
                Internationalization.internationalization
                    .createLocalizedSemantics(
                        context,
                        "enable_notifications_label",
                        "enable_notifications_hint",
                        "enable_notifications_title",
                        AppStyles.darkPurpleAndBold(30)),
                const SizedBox(height: 10),

                // DESCRIPCION
                Semantics(
                  label: Internationalization.internationalization
                      .getLocalizations(
                          context, "enable_notifications_description"),
                  child: Text(
                    Internationalization.internationalization.getLocalizations(
                        context, "enable_notifications_description"),
                    style: const TextStyle(fontSize: 20),
                    // EN CASO DE OVERFLOW, SALTA DE LINEA
                    overflow: TextOverflow.visible,
                    // TEXTO JUSTIFICADO
                    textAlign: TextAlign.justify,
                  ),
                ),

                const SizedBox(height: 30),

                // BOTON PARA ACTIVAR LAS NOTIFICACIONES
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering = false;
                    });
                  },
                  child: GestureDetector(
                    onTap: () async {
                      // PRIMERO SE VERIFICA EL ESTADO ACTUAL DE LOS PERMISOS DE NOTIFICACION
                      var statusActual = await Permission.notification.status;

                      // SI ESTA DENEGADO PERMANENTEMENTE, SE ABRE LA CONFIGURACION DIRECTAMENTE
                      if (statusActual.isPermanentlyDenied) {
                        openAppSettings();
                        return;
                      }

                      // SE SOLICITA EL PERMIDO
                      var status = await Permission.notification.request();
                      DatabaseHelper.logger.i(status);

                      if (status.isGranted) {
                        if (context.mounted) {
                          // SI EN LOS AJUSTES ESTA PERMITIDO, SE CAMBIA EL VALOR DE LAS PREFERENCIAS A TRUE
                          // POR LO QUE SE MUESTRAN LA PANTALLA CON LAS NOTIFICACIONES
                          configuration.changeValue("isActive", true);
                          AlertUtil.showSnackBarInformation(
                              context, "active_notifications");

                          // SE ENVIA UNA NOTIFICACION DE QUE SE ACTIVARON LAS NOTIFICACIONES
                          NotificationService.showNotification(
                              id: 0,
                              title: "notification",
                              body: "notifications_activated");
                        }
                      } else {
                        // SI ESTA DENEGADO EL PERMISO SE MUESTRA UNA ALERTA QUE ABRE LOS SETTINGS
                        if (context.mounted) {
                          AlertUtil.showAlertSimple(
                              context,
                              "permission_required_title",
                              "permission_required_description",
                              "open_settings_button", () {
                            // ABRE LAS NOTIFICACIONES
                            openAppSettings();
                          });
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _isHovering
                            ? AppColors.lightPurpleColor
                            : AppColors.listTileHover,
                        border: Border.all(
                            color: AppColors.darkPurpleColor, width: 1),
                        // AÑADIMOS EL EFECTO DE "drop shadow"
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkPurpleColor.withOpacity(0.5),
                            // COLOR DE LA SOMBRA
                            spreadRadius: 2,
                            // LARGURA DE LA SOMBRA
                            blurRadius: 5,
                            // EFECTO BLUR DE LA SOMBRA
                            // DONDE SE VA A COLOCAR HORIZONTAL Y VERTICALMENTE
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "enable_notifications_label",
                        "enable_notifications_button_hint",
                        "enable_notifications_button_title",
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: _isHovering
                              ? AppColors.listTileHover
                              : AppColors.darkPurpleColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}