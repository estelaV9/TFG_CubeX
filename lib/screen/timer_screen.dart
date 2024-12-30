import 'package:esteladevega_tfg_cubex/components/cube_header_container.dart';
import 'package:esteladevega_tfg_cubex/components/scramble_container.dart';
import 'package:flutter/material.dart';

import '../utilities/app_color.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          // BLOQUE PARA LOS AJUSTES Y EL TIPO DE CUBO Y LA SESION
          const Stack(
            children: [
              // BOTON DE CONFIGURACION ARRIBA A LA IZQUIERDA
              Positioned(
                top: 20,
                left: 20,
                child: Icon(
                  Icons.settings,
                  size: 30,
                  color: AppColors.darkPurpleColor,
                ),
              ),

              // CONTAINER DEL TIPO DE CUBO Y LA SESION UN POCO MAS ABAJO A LA DERECHA
              Positioned(
                top: 40,
                right: 20,
                child: CubeHeaderContainer(),
              ),

              Positioned(
                top: 110,
                right: 20,
                left: 20,
                child: ScrambleContainer(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
