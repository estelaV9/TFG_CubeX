import 'package:esteladevega_tfg_cubex/view/screen/settings.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_language.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_statistics.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_user.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/signup_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/database/database_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Método principal de la aplicación: Inicio de la app.
///
/// Este método inicializa la base de datos y las preferencias,
/// y luego ejecuta la aplicación en un `MultiProvider` que maneja
/// el estado global de la aplicación.
void main() async {
  // ASEGURA LA INICIACION DE LOS BINDING
  WidgetsFlutterBinding.ensureInitialized();
  // SE INICIALIZA LA BASE DE DATOS Y SE CONFIGURA LAS PREFERENCIAS
  await DatabaseHelper.initDatabase();
  await SettingsScreenState.startPreferences();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentCubeType()),
        ChangeNotifierProvider(create: (_) => CurrentLanguage()),
        ChangeNotifierProvider(create: (_) => CurrentStatistics()),
        ChangeNotifierProvider(create: (_) => CurrentScramble()),
        ChangeNotifierProvider(create: (_) => CurrentSession()),
        ChangeNotifierProvider(create: (context) => CurrentUser()),
      ],
      child: CubeXApp(), // SE INICIA LA APLICACIÓN
    ),
  ); // SE INICIA LA APLICACION DENTRO DE UN PROVIDER PARA GESTIONAR EL USUARIO
}

/// Clase principal de la aplicación CubeX.
///
/// La clase CubeXApp configura el idioma y la pantalla inicial
/// de la aplicación a través de un `MaterialApp`.
class CubeXApp extends StatelessWidget {
  const CubeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ESTABLECER IDIOMA
    final locale = context.watch<CurrentLanguage>().locale;

    return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('es'),
          Locale('en')
        ],
        locale: locale,
        debugShowCheckedModeBanner: false,
        // QUITAR MARCA DEBUG
        home: const IntroScreen());
  }
}

/// Pantalla de introducción de la aplicación.
///
/// Esta pantalla se muestra al inicio de la aplicación y contiene
/// el logo, el nombre de la aplicación y botones para iniciar sesión
/// o registrarse.
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
          Stack(
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
                    fontSize: 132,
                    color: AppColors.purpleIntroColor,
                  ),
                ),
              ),
              const Padding(
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
                // Take your skills to the next level.
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
                                // Log in
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
                                // Sign up
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
                    ))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
