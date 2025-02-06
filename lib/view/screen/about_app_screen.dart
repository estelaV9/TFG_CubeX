import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/internationalization.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the App'),
        backgroundColor: AppColors.lightVioletColor,
      ),
      body: Container(
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
        child: SingleChildScrollView(
          // SCROLL
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // TITULO CUBEX
                Align(
                  alignment: Alignment.center,
                  // CubeX
                  child: Stack(
                    children: [
                      Padding(
                        // SE DESPLAZA LA POSICIÓN PARA QUE SE VEA EL OTRO TEXTO
                        padding: const EdgeInsets.only(right: 10),
                        // CubeX
                        child: Internationalization.internationalization
                            .createLocalizedSemantics(
                          context,
                          "cube_x",
                          "cube_x",
                          "cube_x",
                          const TextStyle(
                            fontFamily: 'JollyLodger',
                            fontSize: 100,
                            color: AppColors.purpleIntroColor,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "CubeX",
                          style: TextStyle(
                            fontFamily: 'JollyLodger',
                            fontSize: 100,
                            color: AppColors.titlePurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // IMAGEN LOGO APP
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/app_logo.png',
                    width: 150,
                  ),
                ),

                // VERSION
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),

                // DESCRIPCION
                Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  "description",
                  "description",
                  "description",
                  const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Text(
                  'CubeX es una aplicación diseñada para speedcubers, '
                      'ofreciendo herramientas avanzadas para entrenar y mejorar tiempos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Código abierto con el enlace de GitHub
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.lightVioletColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'CubeX es una aplicación de código abierto',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          // CUANDO PULSE IRA A MI GITHUB
                          const url = 'https://github.com/estelaV9/TFG_CubeX';

                          if (await canLaunch(url)) {
                          await launch(url);
                          } else {
                          throw 'No se pudo abrir la URL';
                          } // VERIFICA SI LA URL ES VALIDA
                        },
                        child: IconClass.iconMaker(context, Icons.exit_to_app_sharp, "go_github")
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Divider(thickness: 1, color: AppColors.darkPurpleColor),

                // EQUIPO DE DESARROLLO
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.lightVioletColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Desarrollador Principal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Estela de Vega Martín'),
                      SizedBox(height: 5),
                      Text('Correo: esteladevega.dev9@gmail.com'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Divider(thickness: 1, color: AppColors.darkPurpleColor),

                // HERRAMIENTAS PRINCIPALES
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.lightVioletColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Herramientas Principales',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('• Flutter'),
                      Text('• SQLite'),
                      Text('• IntelliJ IDEA'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // GITHUB
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconClass.iconMaker(context, Icons.account_circle_sharp, "github", 40),
                    TextButton(onPressed: () async {
                      // CUANDO PULSE IRA A MI GITHUB
                      const url = 'https://github.com/estelaV9';

                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'No se pudo abrir la URL';
                      } // VERIFICA SI LA URL ES VALIDA
                    }, child: const Text("estelaV9", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurpleColor,
                      fontSize: 30,
                    ),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
