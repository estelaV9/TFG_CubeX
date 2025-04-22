import 'package:esteladevega_tfg_cubex/model/configuration_timer.dart';
import 'package:esteladevega_tfg_cubex/view/components/settings_option/option_switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/settings_option/current_configure_timer.dart';
import '../../utilities/app_color.dart';
import '../../utilities/app_styles.dart';
import '../../utilities/internationalization.dart';

/// Pantalla de configuración de las opciones avanzadas.
///
/// Esta pantalla permite configurar opciones avanzadas del temporizador de inspección:
/// - Muestra la opción de activar o desactivar alertas visuales y sonoras a los
///   ocho y doce segundos de la inspección.
/// - Permite seleccionar el tipo de alerta que se activará (vibración, sonido o ambas)
///   cuando se llegue a esos tiempos de inspección.
///
/// Se utiliza el `Provider` de [CurrentConfigurationTimer] para acceder y modificar
/// las configuraciones actuales del temporizador.
class AdvancedOptionsScreen extends StatefulWidget {
  const AdvancedOptionsScreen({super.key});

  @override
  State<AdvancedOptionsScreen> createState() => _AdvancedOptionsScreenState();
}

class _AdvancedOptionsScreenState extends State<AdvancedOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    // OBTIENE LA CONFIGURACION ACTUAL DEL TIMER
    final configurations =
        context.watch<CurrentConfigurationTimer>().configurationTimer;
    // ACCEDE AL PROVIDER PARA MODIFICAR LOS VALORES DE CONFIGURACION
    final currentConfiguration = context.read<CurrentConfigurationTimer>();

    // COLOR PARA EL TEXTO DE LOS SEGUNDOS DEPENDIENDO SE ESTA ACTIVADO O DESACTIVADO LA INSPECCION
    Color colorFromItems = configurations.alertAt8And12Seconds
        ? Colors.white.withOpacity(0.9)
        : Colors.white.withOpacity(0.5);

    // EL TIPO DE ALERTA QUE SELECCIONO PARA LA ALERTA DE LOS 8 Y 12 SEGUNDOS
    String? selectedAlertType = configurations.inspectionAlertType.name;

    /// Metodo que construye el título de la pantalla de opciones avanzadas.
    ///
    /// Este método devuelve un widget que contiene un título y un [Divider] justo debajo.
    /// El título se alinea a la izquierda y se muestra con un tamaño de fuente de 30
    /// y color blanco.
    ///
    /// Parámetros:
    /// - [context]: contexto para acceder a la localización.
    Widget buildTitle(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Internationalization.internationalization.localizedTextOnlyKey(
              context,
              "inspection_advanced_title",
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
            const Divider(),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Internationalization.internationalization.localizedTextOnlyKey(
            context,
            "advanced_options_title",
            style: const TextStyle(fontFamily: 'Broadway', fontSize: 35),
          ),
          centerTitle: true,
          backgroundColor: AppColors.lightVioletColor,
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppStyles.boxDecorationContainer(),
            child: SingleChildScrollView(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                       buildTitle(context),

                        OptionSwitchTile(
                            titleKey: "alert_at_8_12",
                            value: configurations.alertAt8And12Seconds,
                            onChanged: (value) => currentConfiguration
                                .changeValue(alertAt8And12Seconds: value)),

                        ListTile(
                            title: Internationalization.internationalization
                                .localizedTextOnlyKey(
                                    context, "alert_type_title",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    )),
                            subtitle: Internationalization.internationalization
                                .localizedTextOnlyKey(
                              context,
                              "alert_type_description",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                            // DROPDOWNBUTTON PARA LAS OPCIOENS
                            trailing: DropdownButton<String>(
                              value: selectedAlertType,
                              dropdownColor: AppColors.purpleIntroColor,
                              items: [
                                DropdownMenuItem<String>(
                                  value: InspectionAlertType.vibrant.name,
                                  child: Text("Vibrant",
                                      style: TextStyle(color: colorFromItems)),
                                ),
                                DropdownMenuItem<String>(
                                  value: InspectionAlertType.sound.name,
                                  child: Text("Sound",
                                      style: TextStyle(color: colorFromItems)),
                                ),
                                DropdownMenuItem<String>(
                                  value: InspectionAlertType.both.name,
                                  child: Text("Both",
                                      style: TextStyle(color: colorFromItems)),
                                ),
                              ],
                              onChanged: configurations.alertAt8And12Seconds
                                  ? (value) {
                                      setState(() {
                                        selectedAlertType = value;
                                        currentConfiguration.changeValue(
                                            inspectionAlertType:
                                                ConfigurationTimer
                                                    .returnInspectinoTypeString(
                                                        value!));
                                      });
                                    }
                                  : null,
                            )),
                        const SizedBox(height: 70),

                        // IMAGEN UBICADO UN POCO ANTES DEL CENTRO
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/cubix/cubix_advanced_options.png",
                            width: 200,
                          ),
                        ),
                      ],
                    )))));
  }
}