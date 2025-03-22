import 'dart:math';

import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utilities/ScrambleGenerator.dart';

/// Widget que contiene el contenedor para mostrar el scramble y el botón para añadir manualmente.
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

  /// Método que se ejecuta cuando se quiere añadir un scramble personalizado
  /// de manera manual.
  ///
  /// Muestra un formulario donde el usuario puede ingresar su propio scramble.
  /// Si el usuario deja el campo vacío, muestra un mensaje de error.
  /// Si el scramble es válido, lo establece como el scramble actual.
  void logicAddScramble() async {
    // SE MUESTRA UNA ALERTA DE FORMULARIO
    String? newScramble = await AlertUtil.showAlertForm("add_custom_scramble_label", "add_custom_scramble_label", "enter_new_scramble", context);
    if(newScramble == null){
      // MENSAJE DE ERROR POR SI DEJA EL FORMULARIO VACIO
      AlertUtil.showSnackBarError(context, "add_scramble_empty");
    } else {
      setState(() {
        scrambleName = newScramble;
      }); // SE SETTEA EL NOMBRE DEL SCRAMBLE AL AÑADIDO
      // SE MUESTRA UN ALERT DE CONFIRMACION
      AlertUtil.showSnackBarInformation(context, "scramble_added_successful");

      // ESTABLECEMOS EL SCRAMBLE ACTUAL
      final currentScramble = Provider.of<CurrentScramble>(this.context, listen: false);
      currentScramble.setScramble(scrambleName);
    } // VALIDA SI EL SCRAMBLE AÑADIDO ES NULO O NO
  } // METODO PARA CUANDO PULSE EL ICONO DE AÑADIR SCRAMBLE

  /// Método que se ejecuta para generar un nuevo scramble aleatorio.
  ///
  /// Establece el scramble generado como el scramble actual en el estado global.
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
              bottom: 8,
              right: 35,
              child: IconClass.iconButton(context, logicAddScramble,
                  "add_scramble_manual", Icons.add_circle_outline)),

          // BOTON PARA VOLVER A GENERAR UN NUEVO SCRAMBLE
          Positioned(
              bottom: 8,
              right: 10,
              child: IconClass.iconButton(context, updateScramble,
                  "reset_scramble", Icons.refresh))
        ],
      ),
    );
  }
}
