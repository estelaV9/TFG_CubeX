import 'dart:math';

import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/view/components/cube_header_container.dart';
import 'package:esteladevega_tfg_cubex/view/components/scramble_container.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/app_drawer.dart';
import 'package:esteladevega_tfg_cubex/view/screen/show_time_screen.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_statistics.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../components/Icon/icon.dart';
import '../../data/dao/session_dao.dart';
import '../../data/dao/time_training_dao.dart';
import '../../data/dao/user_dao.dart';
import '../../data/database/database_helper.dart';
import '../../model/time_training.dart';
import '../../viewmodel/current_user.dart';
import '../components/waves_painter/small_wave_container_painter.dart';
import '../utilities/ScrambleGenerator.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';

import '../utilities/alert.dart';
import '../utilities/app_styles.dart';


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
        ],
      ),
    );
  }
}