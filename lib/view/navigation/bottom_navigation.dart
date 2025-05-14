import 'package:esteladevega_tfg_cubex/view/screen/timer_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../model/user.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../../viewmodel/current_user.dart';
import '../components/double_tap_exit_dialog.dart';
import '../screen/historial_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../screen/statistics_screen.dart';

/// Clase que representa la **barra de navegación inferior** de la aplicación.
///
/// Esta clase permite a los usuarios cambiar entre diferentes pantallas de la aplicación mediante:
/// - Un menú de navegación en la parte inferior de la pantalla (`CurvedNavigationBar`).
/// - Gestos de deslizamiento lateral gracias a la integración con `PageView`.
///
/// La selección de un elemento en el menú o el gesto de deslizamiento actualiza el estado y
/// muestra la pantalla correspondiente. Además, carga los del usuario, tipo de cubo y
/// sesión al iniciarse si el usuario esta logeado y actualiza su estado global.
///
/// Parámetros:
/// - [index]: Índice inicial que se desea mostrar al iniciar la pantalla.
class BottomNavigation extends StatefulWidget {
  final int? index;

  const BottomNavigation({super.key, this.index});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex; // INDICE ACTUAL DEL BOTTOM NAVIGATION BAR
  late PageController _pageController = PageController(initialPage: _currentIndex);

  // LISTA DE WIDGETS PARA CADA PANTALLA
  final List<Widget> _screens = [
    const HistorialScreen(),
    const TimerScreen(),
    const StatisticsScreen()
  ];

  @override
  void initState() {
    super.initState();
    // SI SE HA PASADO UN INDICE SE ESTABLECE ESE, SI NO SE ESTABLECE EL TIMER
    _currentIndex = widget.index ?? 1;
    _pageController = PageController(initialPage: _currentIndex);

    // MANEJAR LOS DATOS SI EL USUARIO SE MANTIENE LOGEADO
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // SE OBTIENE LAS SHAREDPERFERENDCES GUARDADAS
      final prefs = await SharedPreferences.getInstance();

      // CARGA LOS DATOS DEL USUARIO DESDE LAS PREFERENCIAS
      UserClass user = UserClass.loadFromPreferences(prefs);
      if (user.username != "") {
        final currentUser = Provider.of<CurrentUser>(this.context, listen: false);
        currentUser.setUser(user); // SE ACTUALIZA EL ESTADO GLOBAL
      } // SE VERIFICA SI HAY UN USUARIO GUARDADO

      // CARGA EL TIPO DE CUBO ACTUAL DESDE LAS PREFERENCIAS
      CubeType cubeType = CubeType.loadFromPreferences(prefs);
      if (cubeType.idUser != -1 || cubeType.idCube != -1) {
        final currentCubetype = Provider.of<CurrentCubeType>(context, listen: false);
        currentCubetype.setCubeType(cubeType); // SE ACTUALIZA EL ESTADO GLOBAL
      } // SE VERIFICA SI EXISTEN DATOS VALIDOS

      // CARGA LA SESION ACTUAL DESDE LAS PREFERENCIAS
      SessionClass session = SessionClass.loadFromPreferences(prefs);
      if (session.idUser != -1 || session.idSession != -1) {
        final currentSession = Provider.of<CurrentSession>(context, listen: false);
        currentSession.setSession(session); // SE ACTUALIZA EL ESTADO GLOBAL
      } // SE VERIFICA SI EXISTEN DATOS VALIDOS
    });
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index; // ACTUALIZA EL INDICE
      // ANIMA EL CAMBIO DE PAGINA EN EL PAGEVIEW HACIA EL INDICE SELECCIONADO CON UNA TRANSICIAN SUAVE
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  } // METODO PARA CUANDO PULSE EN LA BARRA DE NAVEGACION

  /// Método para generar un `Icon` con un ícono, tamaño y color.
  ///
  /// Este método sirve para evitar la duplicación de código al crear los iconos
  /// del menú inferior. Según su index, pasará del color morado oscuro a blanco
  /// y tendra un tamaño preestablecido.
  ///
  /// Parametros:
  /// - `iconData`: El icono que se va a mostrar en el menú.
  /// - `index`: La posición de la opción de menú elegida por el usuario para
  /// cambiar de morado oscuro a blanco.
  Icon iconItem(IconData iconData, int index) {
    return Icon(iconData, size: 30,
        color: _currentIndex == index ? Colors.white : AppColors.darkPurpleColor);
  } // METODO QUE DEVUELVE UN ICON CON UN COLOR U OTRO DEPENDIENDO EL INDEX

  @override
  Widget build(BuildContext context) {
    // PARA LAS PANTALLAS PRINCIPALES QUE MANEJA EL BOTTOM NAVIGATION SE LES APLICA
    // LA VERIFICACION DE SALIDA DE LA APP, Y ASI EVITAR SALIDAS ACCIDENTALES
    return DoubleTapExitDialog(
      child: GestureDetector(
        // CUANDO SE TOCA EN CUALQUIER LADO DE LA PANTALLA
        onTap: () {
          // SE QUITA EL FOCO DEL ELEMENTO ACTUAL, LO QUE CIERRA EL TECLADO SI ESTA ABIERTO
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          extendBody: true,
          body: PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: _currentIndex,
            height: 60,
            // FONDO DEL NAVIGATION BAR (el color del espacio que deja el elemento seleccionado)
            backgroundColor: Colors.transparent,
            color: AppColors.lightVioletColor,
            // COLOR DE LA BARRA
            animationDuration: const Duration(milliseconds: 350),
            // ANIMACION
            onTap: _onTap,
            items: <Widget>[
              iconItem(Icons.manage_search, 0),
              iconItem(Icons.timer, 1),
              iconItem(Icons.auto_graph, 2)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}