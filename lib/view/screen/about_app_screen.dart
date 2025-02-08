import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/internationalization.dart';

/// Pantalla de información acerca de la aplicación.
///
/// Esta pantalla muestra información relevante sobre la aplicación, incluyendo
/// su nombre, logo, versión, una breve descripción, el hecho de que es de código abierto,
/// el desarrollador de la aplicación, las herramientas utilizadas en su desarrollo y
/// un enlace al perfil de GitHub del desarrollador.
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Internationalization.internationalization
            .getLocalizations(context, "about_the_app")),
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
                Align(
                  alignment: Alignment.center,
                  child: Internationalization.internationalization
                      .createLocalizedSemantics(
                    context,
                    "version",
                    "version",
                    "version",
                    const TextStyle(fontSize: 18, color: Colors.grey),
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

                const SizedBox(height: 20),

                // CODIGO ABIERTO
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.lightVioletColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "open_source",
                        "open_source",
                        "open_source",
                        const TextStyle(
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
                          child: IconClass.iconMaker(
                              context, Icons.exit_to_app_sharp, "go_github")),
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
                  child: Column(
                    children: [
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "developer",
                        "developer",
                        "developer",
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "developer_name",
                        "developer_name",
                        "developer_name",
                        const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "developer_email",
                        "developer_email",
                        "developer_email",
                        const TextStyle(
                          fontSize: 16,
                        ),
                      )
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
                  child: Column(
                    children: [
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "tools",
                        "tools",
                        "tools",
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Internationalization.internationalization
                          .createLocalizedSemantics(
                        context,
                        "tools_list",
                        "tools_list",
                        "tools_list",
                        const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // GITHUB
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconClass.iconMaker(
                        context, Icons.account_circle_sharp, "github", 40),
                    TextButton(
                        onPressed: () async {
                          // CUANDO PULSE IRA A MI GITHUB
                          const url = 'https://github.com/estelaV9';

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'No se pudo abrir la URL';
                          } // VERIFICA SI LA URL ES VALIDA
                        },
                        child: Internationalization.internationalization
                            .createLocalizedSemantics(
                          context,
                          "name_github",
                          "name_github",
                          "name_github",
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkPurpleColor,
                            fontSize: 30,
                          ),
                        ))
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
