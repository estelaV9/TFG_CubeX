import 'package:esteladevega_tfg_cubex/view/components/cube_header_container.dart';
import 'package:esteladevega_tfg_cubex/view/components/statistics/average_analysis_container.dart';
import 'package:esteladevega_tfg_cubex/view/components/statistics/general_statistics_container.dart';
import 'package:esteladevega_tfg_cubex/view/components/statistics/graphic_performance_container.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/app_drawer.dart';
import 'package:flutter/material.dart';
import '../components/Icon/icon.dart';
import '../components/waves_painter/small_wave_container_painter.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';

import '../utilities/app_styles.dart';

/// Pantalla de estadísticas generales de la sesión actual.
///
/// Esta pantalla muestra diversas estadísticas relacionadas con el rendimiento
/// del usuario en la aplicación, como las mejores y peores resoluciones, el
/// número de resoluciones resueltas, penalizaciones y el tiempo total invertido.
///
/// Se utiliza widgets como `GeneralStatisticsContainer`, `AverageAnalysisContainer`
/// y `GraphicPerformanceContainer`.
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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
            decoration: AppStyles.boxDecorationContainer(),
          )),

          Positioned(
            // UBICARLO EN LA ESQUINA SUPERIOR IZQUIERDA
            top: 0,
            left: 0,
            child: CustomPaint(
              painter: SmallWaveContainerPainter(
                backgroundColor: AppColors.lightVioletColor,
              ),
              child: SizedBox(
                width: 190, // ANCHO
                height: 97, // ALTO
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, top: 0),
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: IconClass.iconMaker(
                          context, Icons.settings, "settings", 26),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // CONTAINER DEL TIPO DE CUBO Y LA SESION UN POCO MAS ABAJO A LA DERECHA
          const Positioned(
            top: 43,
            right: 20,
            child: CubeHeaderContainer(),
          ),

          const Positioned(
              top: 113,
              right: 20,
              left: 20,
              // BOTTOM ALTO PARA PONERLO POR ENCIMA DEL CURVED NAVIGATION
              bottom: 80,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ESTADISTICAS GENERALES
                    GeneralStatisticsContainer(),
                    SizedBox(height: 30),
                    // TABLA CON LAS ESTADISTICAS DE LA MEDIA
                    AverageAnalysisContainer(),
                    SizedBox(height: 30),
                    // GRAFICA ESTADISTICAS DE LSO TIEMPOS
                    GraphicPerformanceContainer()
                  ],
                ),
              )),
        ],
      ),
    );
  }
}