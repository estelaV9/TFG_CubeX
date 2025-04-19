import 'package:esteladevega_tfg_cubex/view/utilities/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/settings_option/current_configure_timer.dart';
import '../../components/settings_option/option_switch_tile.dart';
import '../../utilities/alert.dart';
import '../../utilities/app_color.dart';
import '../../utilities/internationalization.dart';

/// Pantalla de configuración de la inspección del temporizador.
///
/// Esta pantalla permite al usuario habilitar o deshabilitar la fase de inspección
/// previa al inicio de la resolución, así como definir el número de segundos asignados
/// a dicha inspección. Las funcionalidades incluyen:
/// - Activar o desactivar la inspección.
/// - Configurar el tiempo de inspección en segundos mediante un formulario si dicha
/// inspección esta activada.
///
/// Se utiliza el `Provider` de [CurrentConfigurationTimer] para acceder y modificar
/// las configuraciones actuales del temporizador.
class ConfigureInspectionScreen extends StatefulWidget {
  const ConfigureInspectionScreen({super.key});

  @override
  State<ConfigureInspectionScreen> createState() =>
      _ConfigureInspectionScreenState();
}

class _ConfigureInspectionScreenState extends State<ConfigureInspectionScreen> {
  @override
  Widget build(BuildContext context) {
    // OBTIENE LA CONFIGURACION ACTUAL DEL TIMER
    final configurations = context.watch<CurrentConfigurationTimer>().configurationTimer;
    // ACCEDE AL PROVIDER PARA MODIFICAR LOS VALORES DE CONFIGURACION
    final currentConfiguration = context.read<CurrentConfigurationTimer>();

    // COLOR PARA EL TEXTO DE LOS SEGUNDOS DEPENDIENDO SE ESTA ACTIVADO O DESACTIVADO LA INSPECCION
    Color colorFromSeconds = configurations.isActiveInspection
        ? Colors.white.withOpacity(0.9)
        : Colors.white.withOpacity(0.5);

    return Scaffold(
        appBar: AppBar(
          title: Internationalization.internationalization.localizedTextOnlyKey(
              context, "inspection_title",
              style: const TextStyle(fontFamily: 'Broadway', fontSize: 35)),
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
                        OptionSwitchTile(
                            titleKey: "inspection",
                            value: configurations.isActiveInspection,
                            onChanged: (value) => currentConfiguration
                                .changeValue(isActiveInspection: value)),

                        ListTile(
                            title: Internationalization.internationalization
                                .localizedTextOnlyKey(
                                    context, "inspection_time_title",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    )),
                            subtitle: Internationalization.internationalization
                                .localizedTextOnlyKey(
                              context,
                              "inspection_time_description",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                            trailing: Semantics(
                                label: Internationalization.internationalization
                                    .getLocalizations(context,
                                        "inspection_time_button_hint"),
                                child: Tooltip(
                                  message: Internationalization.internationalization
                                      .getLocalizations(context,
                                          "inspection_time_button_title"),
                                  child: TextButton(
                                      onPressed: () {
                                        if (configurations.isActiveInspection) {
                                          // SI LA INSPECCION ESTA ACTIVA ABRE UN
                                          // FORMULARIO PARA EL TIEMPO DE INSPECCION
                                          AlertUtil.addSecondsTimeOfInspectionForm(
                                                  "inspection_time", context);
                                        }
                                      },
                                      child: Container(
                                        // CONTENEDOR PARA AGREGARLE UN UNDERLINE
                                        // AL TEXTO NO TAN PEGADO
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: colorFromSeconds,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          // SE MUESTRA EL TIEMPO DE INSPECCION
                                          // QUE HAYA ESTABLECIDO EL USUARIO
                                          configurations.inspectionSeconds.toString(),
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: colorFromSeconds,
                                          ),
                                        ),
                                      )),
                                ))),

                        const SizedBox(height: 60,),

                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/cubix/cubix_inspection.png",
                            width: 200,
                          ),
                        ),
                      ],
                    )))));
  }
}