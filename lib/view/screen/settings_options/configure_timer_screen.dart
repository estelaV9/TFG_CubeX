import 'package:esteladevega_tfg_cubex/viewmodel/settings_option/current_configure_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/settings_option/option_switch_tile.dart';
import '../../utilities/app_color.dart';
import '../../utilities/app_styles.dart';
import '../../utilities/internationalization.dart';

/// Pantalla de configuración del temporizador.
///
/// Esta pantalla permite al usuario personalizar distintas opciones relacionadas
/// con el temporizador del cubo, como ocultar el tiempo mientras realiza una resolución o activar
/// alertas específicas al finalizar una resolución. Las opciones incluyen:
/// - Ocultar el tiempo en ejecución.
/// - Alerta al registrar un nuevo mejor tiempo personal.
/// - Alerta de mejor media.
/// - Alerta de peor tiempo.
///
/// Se utiliza el `Provider` de [CurrentConfigurationTimer] para acceder y modificar
/// las configuraciones actuales del temporizador.
class ConfigureTimerScreen extends StatefulWidget {
  const ConfigureTimerScreen({super.key});

  @override
  State<ConfigureTimerScreen> createState() => _ConfigureTimerScreenState();
}

class _ConfigureTimerScreenState extends State<ConfigureTimerScreen> {
  @override
  Widget build(BuildContext context) {
    // OBTIENE LA CONFIGURACION ACTUAL DEL TIMER
    final configurations = context.watch<CurrentConfigurationTimer>().configurationTimer;
    // ACCEDE AL PROVIDER PARA MODIFICAR LOS VALORES DE CONFIGURACION
    final currentConfiguration = context.read<CurrentConfigurationTimer>();

    return Scaffold(
        appBar: AppBar(
          title: Internationalization.internationalization.localizedTextOnlyKey(
            context,
            "configure_timer",
            style: const TextStyle(fontFamily: 'Broadway', fontSize: 35),
          ),
          centerTitle: true,
          backgroundColor: AppColors.lightVioletColor,
        ),
        body: Container(
            decoration: AppStyles.boxDecorationContainer(),
            child: SingleChildScrollView(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          OptionSwitchTile(
                              titleKey: "hide_time",
                              value: configurations.hideRunningTime,
                              onChanged: (value) => currentConfiguration.changeValue(hideRunningTime: value)),
                          const SizedBox(height: 40),

                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Internationalization.internationalization.localizedTextOnlyKey(
                                      context,
                                      "alerts",
                                      style: const TextStyle(fontSize: 30, color: Colors.white),
                                    ),
                                    const Divider(),
                                  ],
                                )),
                          ),

                          OptionSwitchTile(
                              titleKey: "record_time_alert",
                              value: configurations.recordTimeAlert,
                              onChanged: (value) => currentConfiguration.changeValue(recordTimeAlert: value)),
                          const SizedBox(height: 10),

                          OptionSwitchTile(
                              titleKey: "best_average_alert",
                              value: configurations.bestAverageAlert,
                              onChanged: (value) => currentConfiguration.changeValue(bestAverageAlert: value)),
                          const SizedBox(height: 10),

                          OptionSwitchTile(
                              titleKey: "worst_time_alert",
                              value: configurations.worstTimeAlert,
                              onChanged: (value) => currentConfiguration.changeValue(worstTimeAlert: value)),

                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/cubix_timer.png",
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    )))));
  }
}