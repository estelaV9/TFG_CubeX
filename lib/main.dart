import 'package:esteladevega_tfg_cubex/model/notification_service.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/bottom_navigation.dart';
import 'package:esteladevega_tfg_cubex/view/screen/IntroScreen.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/database/database_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'model/app_notification.dart';
import 'model/configuration_timer.dart';
import 'model/user.dart';

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
  await User.startPreferences();

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
/// La clase `CubeXApp` es el punto de entrada de la aplicación, aqui se configura
/// el idioma y la pantalla inicial de la aplicación a través de un `MaterialApp`.
/// En esta clase, se inicializa el sistema de localización, se verifica el estado de sesión del usuario,
/// y se establece la pantalla correspondiente (ya sea la pantalla de inicio de sesión
/// o la pantalla principal, dependiendo de si esta logeado o no)
class CubeXApp extends StatefulWidget {
  const CubeXApp({super.key});

  @override
  State<CubeXApp> createState() => _CubeXAppState();
}

class _CubeXAppState extends State<CubeXApp> {
  // ATRIBUTO PARA EL USUARIO
  User? newUser;

  /// Método para cargar el usuario desde SharedPreferences.
  ///
  /// Este método recupera el usuario almacenado en las preferencias.
  /// Si el usuario existe, se actualiza el estado global del usuario.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación para acceder al `Provider`.
  Future<void> loadUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // SE CARGA EL USUARIO ALMACENADO EN LAS PREFERENCIAS
    newUser = User.loadFromPreferences(prefs);
    if (newUser != null) {
      final currentUser = Provider.of<CurrentUser>(context, listen: false);
      currentUser.setUser(newUser!); // SE ACTUALIZA EL ESTADO GLOBAL
    } // SI EL USUARIO NO ES NULO
  }

  @override
  Widget build(BuildContext context) {
    // ESTABLECER IDIOMA
    final locale = context.watch<CurrentLanguage>().locale;
    // SE LLAMA AL METODO PARA VER SI HAY UN USUARIO YA LOGEADO
    loadUser(context);

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
        supportedLocales: const [Locale('es'), Locale('en')],
        locale: locale,
        // QUITAR MARCA DEBUG
        debugShowCheckedModeBanner: false,
        // SI HAY UN USUARIO Y ESTA LOGEADO ENTONCES SE LE REDIRIGE DE NUEVO A
        // LA PANTALLA DEL TIMER, SI NO A LA PANTALLA DE INICIAR SESION
        home: newUser != null && newUser!.isLoggedIn
            ? const BottomNavigation(index: 1)
            : const IntroScreen());
  }
}