import 'package:esteladevega_tfg_cubex/components/cube_header_container.dart';
import 'package:esteladevega_tfg_cubex/components/scramble_container.dart';
import 'package:esteladevega_tfg_cubex/navigation/app_drawer.dart';
import 'package:flutter/material.dart';

import '../utilities/app_color.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // VALORES DE LAS ESTADISTICAS DE LA SESION
  var averageValue = "--:--.--";
  var pbValue = "--:--.--";
  var worstValue = "--:--.--";
  var countValue = "--:--.--";
  var ao5Value = "--:--.--";
  var ao12Value = "--:--.--";
  var ao50Value = "--:--.--";
  var ao100Value = "--:--.--";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // KEY PARA CONTROLLAR EL SCAFFOLD PARA EL DRAWER
      drawer: const AppDrawer(), // DRAWER
      body: Stack(
        children: [
          // FONDO DEGRADADO
          Positioned.fill(
              child: Container(
            decoration: const BoxDecoration(
              // COLOR DEGRADADO PARA EL FONDO
              gradient: LinearGradient(
                begin: Alignment.topCenter, // DESDE ARRIBA
                end: Alignment.bottomCenter, // HASTA ABAJO
                colors: [
                  // COLOR DE ARRIBA DEL DEGRADADO
                  AppColors.upLinearColor,
                  // COLOR DE ABAJO DEL DEGRADADO
                  AppColors.downLinearColor,
                ],
              ),
            ),
          )),

          // BOTON DE CONFIGURACION ARRIBA A LA IZQUIERDA
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer(); // ABRE EL DRAWER
                },
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                  color: AppColors.darkPurpleColor,
                )),
          ),

          // CONTAINER DEL TIPO DE CUBO Y LA SESION UN POCO MAS ABAJO A LA DERECHA
          const Positioned(
            top: 40,
            right: 20,
            child: CubeHeaderContainer(),
          ),

          // CONTAINER DEL SCRAMBLE
          const Positioned(
            top: 110,
            right: 20,
            left: 20,
            child: ScrambleContainer(),
          ),

          // .fill PARA QUE SE EXPANDA EL TIMER Y SIGA QUEDANDOSE EN EL CENTRO
          Positioned.fill(
            top: 250, // PARA QUE SE COLOQUE JUSTO DESPUES DEL SCRAMBLE
            child: Column(
              children: [
                Container(
                  padding:
                      // TODO_EL ESPACIO QUE OCUPA EL ESPACIO DEL TIMER
                      const EdgeInsets.symmetric(vertical: 95, horizontal: 20),
                  child: Column(
                    // SE CENTRA
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "0.00",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPurpleColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add_comment_rounded,
                                  color: AppColors.darkPurpleColor)),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "DNF",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor,
                                ),
                              )),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "+2",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor,
                                ),
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.close,
                                  color: AppColors.darkPurpleColor)),
                        ],
                      )
                    ],
                  ),
                ),

                // EXPANDE EL CONTENEDOR CON LOS TEXTOS PARA QUE OCUPE TODO_EL ESPACIO
                // DISPONIBLE ENTRE EL TIMER Y LOS TEXTOS
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      // ESPACIO ENTRE LAS COLUMNAS
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // COLUMNA IZQUIERDA
                        Column(
                          // EMPIEZA DESDE ARRIBA A LA IZQUIERDA
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Average: $averageValue",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                            Text(
                              "Pb: $pbValue",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                            Text(
                              "Worst: $worstValue",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                            Text(
                              "Count: $countValue",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                          ],
                        ),

                        //COLUMNA DERECHA
                        Column(
                          // EMPIEZA DESDE ARRIBA A LA DERECHA
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Ao5: $ao5Value",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                            Text(
                              "Ao12: $ao12Value",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                            Text(
                              "Ao50: $ao50Value",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                            Text(
                              "Ao100: $ao100Value",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkPurpleColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
