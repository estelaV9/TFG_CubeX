import 'dart:io';

import 'package:esteladevega_tfg_cubex/model/notification_service.dart';
import 'package:esteladevega_tfg_cubex/view/screen/settings.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/settings_option/current_configure_timer.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/settings_option/current_language.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/settings_option/current_notifications.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_statistics.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_time.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_usage_timer.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_user.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/screen/login_screen.dart';
import 'package:esteladevega_tfg_cubex/view/screen/signup_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:stroke_text/stroke_text.dart';
import 'data/database/database_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'model/app_notification.dart';
import 'model/configuration_timer.dart';

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
  await AppNotification.startPreferences();
  await ConfigurationTimer.startPreferences();

  // INICIALIZAR EL TIMEZONES
  tz.initializeTimeZones();

  // SE INICIALIZAN LAS NOTIFICACIONES DONDE TE PIDE LOS PERMISOS
  await NotificationService.initNotification();

  // QUITA EL STATUS BAR EN EL MOVIL
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentCubeType()),
        ChangeNotifierProvider(create: (_) => CurrentTime()),
        ChangeNotifierProvider(create: (_) => CurrentLanguage()),
        ChangeNotifierProvider(create: (_) => CurrentNotifications()),
        ChangeNotifierProvider(create: (_) => CurrentConfigurationTimer()),
        ChangeNotifierProvider(create: (_) => CurrentStatistics()),
        ChangeNotifierProvider(create: (_) => CurrentScramble()),
        ChangeNotifierProvider(create: (_) => CurrentSession()),
        ChangeNotifierProvider(create: (context) => CurrentUser()),
        // INICIAR EL CONTADOR CUANDO INICIE LA APP
        ChangeNotifierProvider(create: (context) => CurrentUsageTimer()..start()),
      ],
      child: const CubeXApp(), // SE INICIA LA APLICACIÓN
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
        // OBSERVADOR PARA MANEJAR COMO SE MUESTRAN LOS DIALOGOS CUANDO NAVEGAN
        // ENTRE PANTALLAS
        navigatorObservers: [FlutterSmartDialog.observer],

        // SE INICIALIZA EL SISTEMA PARA MOSTRAR DIALOGOS PERSONALIZADOS EN LA APP
        // ESTOS DOS ATRIBUTOS HACEN QUE FUNCIONE EL FLUTTER SMART DIALOG
        builder: FlutterSmartDialog.init(),

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
    // VERIFICAR SI ES MOVIL O NO
    bool isMobile = Platform.isAndroid || Platform.isIOS;

    double sizeText = 132;

    if (isMobile) {
      // SI ES MOVIL SE LE AUMENTA EL TAMAÑO FUENTE YA QUE CON EL STROKE
      // SE DISMINUYE UN POCO
      sizeText = 146;
    }

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SE DIVIDE EN DOSS GRUPOS, LA SUPERIOR Y LA INFERIOR
          // GRUPO SUPERIOR: COLUMNA CON EL TITULO, Y LA IMAGEN
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    // SE DESPLAZA LA POSICION PARA QUE SE VEA EL OTRO TEXTO
                    padding: const EdgeInsets.only(right: 10, top: 20),
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
                        // CENTRAR TEXTO
                        textAlign: TextAlign.center,
                      ))
                ],
              ),

              // TRANSFORM MUEVE HACIA ARRIBA LOS ELEMENTOS
              Align(
                alignment: Alignment.center,
                child: Image.asset("assets/app_logo.png"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // GRUPO INFERIOR CON LOS BOTONES Y EL TEXTO
          // EL OBJETIVO ES FINAR ESTOS ELEMENTOS EN LA PARTE DE ABAJO DE LA PANTALLA
          Padding(
            // PADDING BORDE INFERIOR
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
                                color: Colors.black, width: 1), // BORDE NEGRO
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
            ),
          ),
        ],
      ),
    ));
  }
}
