import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

import '../utilities/app_color.dart';
import '../utilities/internationalization.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// Pantalla de introducción de la aplicación CubeX.
///
/// Esta es la primera pantalla que ve el usuario al abrir la aplicación.
/// Se muestra el nombre y logo de la app, junto con opciones para iniciar sesión o registrarse.
/// Además, adapta el diseño visual según el dispositivo (móvil o no) para una mejor experiencia de usuario.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    // VERIFICAR SI ES MOVIL O NO PARA AJUSTAR LE TAMAÑO DE TEXTO
    bool isMobile = Platform.isAndroid || Platform.isIOS;

    // SI ES MOVIL SE LE AUMENTA EL TAMAÑO FUENTE YA QUE CON EL STROKE
    // SE DISMINUYE UN POCO
    double sizeText = isMobile ? 146 : 132;

    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_intro.jpeg"),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          children: [
            // EL CONTENIDO SUPERIOR PUEDE HACER SCROLL, ASI SOLUCIONA EL OVERFLOW DEL INICIO
            // EN PANTALLAS PEQUEÑAS
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 20),
                          child: Internationalization.internationalization
                              .localizedTextOnlyKey(
                            context,
                            "cube_x",
                            style: const TextStyle(
                              fontFamily: 'JollyLodger',
                              fontSize: 132,
                              color: AppColors.purpleIntroColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, top: 20),
                          child: StrokeText(
                            text: "CubeX",
                            textStyle: TextStyle(
                              fontFamily: 'JollyLodger',
                              fontSize: sizeText,
                              color: AppColors.titlePurple,
                            ),
                            strokeColor: AppColors.darkPurpleColor,
                            strokeWidth: 4,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    // LOGO
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/app_logo.png"),
                    ),
                  ],
                ),
              ),
            ),

            // EN LA PARTE INFERIOR, ANCLAMOS LOS BOTONES
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Internationalization.internationalization
                      .createLocalizedSemantics(
                    context,
                    "main_title",
                    "main_title_hint",
                    "main_title",
                    const TextStyle(
                      fontFamily: 'Berlin Sans FB',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BOTON LOGIN
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purpleIntroColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                            ),
                          ),
                          child: Internationalization.internationalization
                              .createLocalizedSemantics(
                            context,
                            "login_label",
                            "login_hint",
                            "login_label",
                            const TextStyle(
                              fontFamily: 'JollyLodger',
                              fontSize: 35,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // BOTON SIGNPUP
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SignUpScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purpleIntroColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                            ),
                          ),
                          child: Internationalization.internationalization
                              .createLocalizedSemantics(
                            context,
                            "signup_label",
                            "signup_hint",
                            "signup_label",
                            const TextStyle(
                              fontFamily: 'JollyLodger',
                              fontSize: 35,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}