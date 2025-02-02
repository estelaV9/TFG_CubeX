import 'dart:math';

import 'package:esteladevega_tfg_cubex/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/state/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/ScrambleGenerator.dart';

class ScrambleContainer extends StatefulWidget {
  const ScrambleContainer({super.key});

  @override
  State<ScrambleContainer> createState() => ScrambleContainerState();
}

class ScrambleContainerState extends State<ScrambleContainer> {
  Scramble scramble = Scramble();
  String scrambleName = "";

  // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
  int random = (Random().nextInt(25 - 20 + 1) + 20);

  void logicAddScramble() async {
    // SE MUESTRA UNA ALERTA DE FORMULARIO
    String? newScramble = await AlertUtil.showAlertForm("Add a custom scramble", "", "Enter a new scramble", context);
    if(newScramble == null){
      // MENSAJE DE ERROR POR SI DEJA EL FORMULARIO VACIO
      AlertUtil.showSnackBarError(context, "Please add a scramble that isn't empty.");
    } else {
      setState(() {
        scrambleName = newScramble;
      }); // SE SETTEA EL NOMBRE DEL SCRAMBLE AL AÑADIDO
      // SE MUESTRA UN ALERT DE CONFIRMACION
      AlertUtil.showSnackBarInformation(context, "Scramble added successful");

      // ESTABLECEMOS EL SCRAMBLE ACTUAL
      final currentScramble = Provider.of<CurrentScramble>(this.context, listen: false);
      currentScramble.setScramble(scrambleName);
    } // VALIDA SI EL SCRAMBLE AÑADIDO ES NULO O NO
  } // METODO PARA CUANDO PULSE EL ICONO DE AÑADIR SCRAMBLE


  void updateScramble() {
    setState(() {
      scrambleName = scramble.generateScramble(random);  // SE ASIGNA UN NUEVO SCRAMBLE
      // ESTABLECEMOS EL SCRAMBLE ACTUAL
      final currentScramble = Provider.of<CurrentScramble>(this.context, listen: false);
      currentScramble.setScramble(scrambleName);
    });
  } // METODO PARA ACTUALIZAR EL SCRAMBLE

  @override
  void initState() {
    super.initState();
    scrambleName = scramble.generateScramble(random);
    // ESTABLECEMOS EL SCRAMBLE ACTUAL
    final currentScramble = Provider.of<CurrentScramble>(this.context, listen: false);
    currentScramble.setScramble(scrambleName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 348,
      height: 136,

      decoration: BoxDecoration(
        // COLOR CON 60& DE OPACIDAD
        color: AppColors.lightVioletColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        // AÑADIMOS EL EFECTO DE "drop shadow"
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // COLOR DE LA SOMBRA
            spreadRadius: 2, // LARGURA DE LA SOMBRA
            blurRadius: 5, // EFECTO BLUR DE LA SOMBRA
            // DONDE SE VA A COLOCAR HORIZONTAL Y VERTICALMENTE
            offset: const Offset(2, 4),
          ),
        ],
      ),

      // CONTENIDO DEL CONTAINER (el scramble y el boton para añadir manualmente)
      child: Stack(
        children: [
          // SCRAMBLE
          Positioned(
              top: 10,
              right: 10,
              left: 10,
              bottom: 10,
              child: Text(
                // MOSTRAMOS EL SCRAMBLE
                scrambleName,
                style: const TextStyle(
                    color: AppColors.darkPurpleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),

          // BOTON AÑADIR MANUALMENTE
          Positioned(
              bottom: 10,
              right: 10,
              child: IconClass.iconButton(logicAddScramble,
                  "Add scramble manually", Icons.add_circle_outline))
        ],
      ),
    );
  }
}
