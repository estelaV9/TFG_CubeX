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
              Positioned.fill(
                  child: Container(
                decoration: const BoxDecoration(
                  // COLOR DEGRADADO PARA EL FONDO
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, // DESDE ARRIBA
                    end: Alignment.bottomCenter, // HASTA ABAJO
                    colors: [
                      AppColors.upLinearColor,
                      // COLOR DE ARRIBA DEL DEGRADADO
                      AppColors.downLinearColor,
                      // COLOR DE ABAJO DEL DEGRADADO
                    ],
                  ),
                ),
              )),
    ]));
  }
}
