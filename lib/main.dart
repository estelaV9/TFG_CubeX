import 'package:esteladevega_tfg_cubex/state/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/state/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/state/current_session.dart';
import 'package:esteladevega_tfg_cubex/state/current_user.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database_helper.dart';

void main() async {
  // SE INICIALIZA LA BASE DE DATOS
  await DatabaseHelper.initDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentCubeType()),
        ChangeNotifierProvider(create: (_) => CurrentScramble()),
        ChangeNotifierProvider(create: (_) => CurrentSession()),
        ChangeNotifierProvider(create: (context) => CurrentUser()),
      ],
      child: CubeXApp(), // SE INICIA LA APLICACIÓN
    ),
  ); // SE INICIA LA APLICACION DENTRO DE UN PROVIDER PARA GESTIONAR EL USUARIO
}

class CubeXApp extends StatelessWidget {
  const CubeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, // QUITAR MARCA DEBUG
        home: IntroScreen());
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // PADDING HORIZONTAL PARA TODA LA VISTA
      // IMAGEN DE FONDO
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background_intro.jpeg"),
          fit: BoxFit.cover, // AJUSTAR LA IMAGEN AL TAMAÑO DE LA PANTALLA
        ),
      ),
      child: Column(
        children: [
          const Stack(
            children: [
              Padding(
                // SE DESPLAZA LA POSICIÓN PARA QUE SE VEA EL OTRO TEXTO
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  "CubeX",
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 132,
                    color: AppColors.purpleIntroColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 7),
                child: Text(
                  "CubeX",
                  style: TextStyle(
                    fontFamily: 'JollyLodger',
                    fontSize: 132,
                    color: AppColors.titlePurple,
                  ),
                ),
              ),
            ],
          ),

          // TRANSFORM MUEVE HACIA ARRIBA LOS ELEMENTOS
          Transform.translate(
            offset: const Offset(0, -30),
            child: Column(
              children: [
                Image.asset("assets/app_logo.png"),
                const Text(
                  "Take your skills to the next level.",
                  style: TextStyle(
                    fontFamily: 'Berlin Sans FB',
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                    alignment: Alignment.bottomCenter,
                    // LOS BOTONES SE UBICAN AL FINAL DE LA PANTALLA
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // UBICAR LOS BOTONES ABAJO
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // CENTRAR LOS BOTONES
                      children: [
                        // BOTÓN LOGIN
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
                                  // COLOR DE FONDO
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    // BORDES REDONDEADOS
                                    side: const BorderSide(
                                        color: Colors.black,
                                        width: 1), // BORDE NEGRO
                                  ),
                                ),
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
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
                        // ESPACIO ENTRE LOS BOTONES

                        // BOTÓN SIGN UP
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
                                  // COLOR DE FONDO
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    // BORDES REDONDEADOS
                                    side: const BorderSide(
                                        color: Colors.black,
                                        width: 1), // BORDE NEGRO
                                  ),
                                ),
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
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
                    ))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
