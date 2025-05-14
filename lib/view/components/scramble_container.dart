import 'dart:math';

import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cubetype.dart';
import '../utilities/ScrambleGenerator.dart';
import '../utilities/app_styles.dart';

/// Widget que contiene el contenedor para mostrar el scramble y el botón para añadir manualmente.
class ScrambleContainer extends StatefulWidget {
  const ScrambleContainer({super.key});

  @override
  State<ScrambleContainer> createState() => ScrambleContainerState();
}

class ScrambleContainerState extends State<ScrambleContainer> {
  Scramble scramble = Scramble();
  String scrambleName = "";
  late CurrentCubeType _currentCubeType;

  // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
  int random = (Random().nextInt(25 - 20 + 1) + 20);

  /// Genera un nuevo scramble basado en el tipo de cubo actual guardado en las preferencias
  /// o en el estado global.
  ///
  /// Este método realiza carga el tipo de cubo (`CubeType`) desde las preferencias almacenadas.
  /// Si el tipo de cubo contiene datos válidos (`idUser` o `idCube` diferentes de -1),
  /// se actualiza el estado global a través del provider `CurrentCubeType`. Si no,
  /// se mantiene el tipo de cubo actual del provider.
  ///
  /// Genera y devuelve un scramble usando el nombre del cubo obtenido.
  Future<String> _generator() async {
    // SE OBTIENE LAS SHAREDPERFERENDCES GUARDADAS
    final prefs = await SharedPreferences.getInstance();
    // CARGA EL TIPO DE CUBO ACTUAL DESDE LAS PREFERENCIAS
    CubeType cubeType = CubeType.loadFromPreferences(prefs);
    if (cubeType.idUser != -1 || cubeType.idCube != -1) {
      _currentCubeType = Provider.of<CurrentCubeType>(context, listen: false);
      _currentCubeType.setCubeType(cubeType); // SE ACTUALIZA EL ESTADO GLOBAL
    } else {
      // SI NO HAY NINGUNA PREFERENCIAS GUARDADAS ESTABLECE DEL ESTADO GLOBAL
      _currentCubeType = context.read<CurrentCubeType>();
    } // SE VERIFICA SI EXISTEN DATOS VALIDOS

    return scramble.generateScramble(_currentCubeType.cubeType!.cubeName);
  }

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
  void updateScramble() async {
    String newScramble = await _generator();  // SE ASIGNA UN NUEVO SCRAMBLE
    setState(() {
      scrambleName = newScramble;
    });
    // ESTABLECEMOS EL SCRAMBLE ACTUAL
    final currentScramble = Provider.of<CurrentScramble>(context, listen: false);
    currentScramble.setScramble(scrambleName);
  } // METODO PARA ACTUALIZAR EL SCRAMBLE

  @override
  void initState() {
    super.initState();
    // EJECUTA LA FUNCION DESPUES DE QUE EL FRAME ACTUAL TERMINE DE CONSTRUIRSE,
    // ASI NO CAUSA ERRORES DURANTE EL BUILD PARA HACER CAMBIOS EN EL STATE O EN PROVIDERS
    // (se soluciona el mensaje de error cuando pulsas en el timer de setState() or
    // markNeedsBuild() called during build)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ESTABLECEMOS EL SCRAMBLE ACTUAL
      scrambleName = await _generator();
      final currentScramble = Provider.of<CurrentScramble>(context, listen: false);
      currentScramble.setScramble(scrambleName);
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrentScramble scramble = context.watch<CurrentScramble>();
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
              // SE AÑADE UN SCROLL POR SI ES MUY LARGO EL SCRAMBLE
              child: SingleChildScrollView(
                child: Text(
                  // MOSTRAMOS EL SCRAMBLE
                    scramble.scramble.toString(),
                  style: AppStyles.darkPurpleAndBold(20),
                ),
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
