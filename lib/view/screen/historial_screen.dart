import 'package:esteladevega_tfg_cubex/view/components/card_time_historial.dart';
import 'package:esteladevega_tfg_cubex/view/components/search_time_container.dart';
import 'package:flutter/material.dart';

import '../components/Icon/icon.dart';
import '../../view/components/cube_header_container.dart';
import '../../view/navigation/app_drawer.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';

/// Pantalla del historial
///
/// Esta clase muestra los tiempos de una sesión de un tipo de cubo determinado.
/// Se encuentra compuesta por:
/// - El header con la información sobre el tipo de cubo y la sesión que se está usando. Se ubica en la parte superior derecha.
/// - El contenedor para añadir un tiempo manualmente.
/// - Una lista de tarjetas que contiene los tiempos registrados para la sesión y cubo seleccionados.
class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
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
                icon: IconClass.iconMaker(context, Icons.settings, "settings", 30)),
          ),

          // CONTAINER DEL TIPO DE CUBO Y LA SESION UN POCO MAS ABAJO A LA DERECHA
          const Positioned(
            top: 40,
            right: 20,
            child: CubeHeaderContainer(),
          ),

          const Positioned(
            top: 110,
            right: 20,
            left: 20,
            bottom: 465,
            child: SearchTimeContainer(),
          ),

          const Positioned(
            top: 175,
            right: 20,
            left: 20,
            bottom: 20,
            child: CardTimeHistorial(),
          ),
        ],
      ),
    );
  }
}
