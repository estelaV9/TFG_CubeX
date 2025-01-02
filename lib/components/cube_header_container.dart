import 'package:esteladevega_tfg_cubex/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/components/session_menu.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../dao/cubetype_dao.dart';
import '../model/cubetype.dart';
import 'Icon/animated_icon.dart';

class CubeHeaderContainer extends StatefulWidget {
  const CubeHeaderContainer({super.key});

  @override
  State<CubeHeaderContainer> createState() => _CubeHeaderContainerState();
}

class _CubeHeaderContainerState extends State<CubeHeaderContainer> {
  // SE AÑADE EN ESTA CLASE EL OVERLAY DEL MENU SESSION
  bool isMenuVisible = false; // COMPROBAR SI EL MENU ESTA VISIBLE O NO
  OverlayEntry? _overlayEntry; // MANEJAR EL MENU COMO OVERLAY

  late CubeType cubeType = CubeType("DefaultCube"); // VALOR INCIAL
  CubeTypeDao cubeTypeDao = CubeTypeDao();

  void getCubeTypeDefault() async{
    CubeType result = await cubeTypeDao.cubeTypeDefault("3x3x3");
    print(result);
    setState(() {
      cubeType = result;
    });
  } // SETTEAR EL TIPO DE CUBO POR DEFECTO (sera el 3x3x3)

  @override
  void initState() {
    super.initState();
    getCubeTypeDefault();
  } // AL INICIAR LA APLICAION, SE SETTEA EL TIPO DE CUBO POR DEFECTO

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // AL TOCAR FUERA, SE CIERRA EL MENU
            _removeOverlay(); // ELIMINAR EL OVERLAY
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  // SE PONE EL FONDO MEDIO OSCURO CUANDO APARECE EL MENU
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Center(
                // ESTE CONTAINER SIRVE PARA CENTRARLO EN LA PANTALLA EL OTRO CONTAINER
                child: Container(
                  width: 250,
                  height: 300,
                  child: const SessionMenu(), // SESSION MENU
                ),
              ),
            ],
          ),
        );
      },
    );

    // SE INSERTA EL OVERLAY EN LA PANTALLA
    Overlay.of(context)?.insert(_overlayEntry!);
    setState(() {
      isMenuVisible = true; // SE HACE VISIBLE EL MENU
    });
  } // METODO PARA AÑADIR EL OVERLAY

  void _removeOverlay() {
    _overlayEntry?.remove(); // SE ELIMINA EL OVERLAY
    setState(() {
      isMenuVisible = false;
    }); // SE ACTUALIZA EL ESTADO VISIBLE
  } // METODO PARA ELIMINAR EL OVERLAY

  void logicSessionIcon(){
    // CUANDO SE TOCA, SE MUESTRA/OCULTA EL MENU DE SESSION
    if (isMenuVisible) {
      _removeOverlay(); // SI EL MENU ESTA VISIBLE, SE OCULTA
    } else {
      _showOverlay(); // SI NO ESTA VISIBLE, SE MUESTRA
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      decoration: BoxDecoration(
        color: AppColors.lightVioletColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Column(
              children: [
                Text(
                  cubeType.cubeName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurpleColor),
                ),
                Text("Name Session")
              ],
            ),

            const SizedBox(width: 5),

            // ICONO DE MENU CERRADO/ABIERTO
            const AnimatedIconWidget(
                animatedIconData: AnimatedIcons.menu_close),

            const SizedBox(width: 5),

            IconClass.iconButtonImage(logicSessionIcon, "assets/session_icon.png", "Choose a session")
          ],
        ),
      ),
    );
  }
}