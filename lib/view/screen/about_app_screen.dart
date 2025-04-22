import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/app_styles.dart';
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
        decoration: AppStyles.boxDecorationContainer(),
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
                            .localizedTextOnlyKey(
                          context,
                          "cube_x",
                          style: const TextStyle(
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
                      .localizedTextOnlyKey(
                    context,
                    "version",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),

                // DESCRIPCION
                Internationalization.internationalization.localizedTextOnlyKey(
                  context,
                  "description",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
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
                          .localizedTextOnlyKey(
                        context,
                        "open_source",
                        style: const TextStyle(
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
                          .localizedTextOnlyKey(
                        context,
                        "developer",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Internationalization.internationalization
                          .localizedTextOnlyKey(
                        context,
                        "developer_name",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Internationalization.internationalization
                          .localizedTextOnlyKey(
                        context,
                        "developer_email",
                        style: const TextStyle(
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
                          .localizedTextOnlyKey(
                        context,
                        "tools",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Internationalization.internationalization
                          .localizedTextOnlyKey(
                        context,
                        "tools_list",
                        style: const TextStyle(
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
                            .localizedTextOnlyKey(context, "name_github",
                                style: AppStyles.darkPurpleAndBold(30)))
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