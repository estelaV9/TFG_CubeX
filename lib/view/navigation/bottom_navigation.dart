import 'package:esteladevega_tfg_cubex/view/screen/timer_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../screen/historial_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../screen/statistics_screen.dart';
import 'app_drawer.dart';

/// Clase que representa la **barra de navegación inferior** de la aplicación.
///
/// Esta clase permite a los usuarios cambiar entre diferentes pantallas de la aplicación mediante:
/// - Un menú de navegación en la parte inferior de la pantalla (`CurvedNavigationBar`).
/// - Gestos de deslizamiento lateral gracias a la integración con `PageView`.
///
/// La selección de un elemento en el menú o el gesto de deslizamiento actualiza el estado y
/// muestra la pantalla correspondiente.
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1; // INDICE ACTUAL DEL BOTTOM NAVIGATION BAR
  late PageController _pageController = PageController(initialPage: _currentIndex);

  // LISTA DE WIDGETS PARA CADA PANTALLA
  final List<Widget> _screens = [
    const HistorialScreen(),
    const TimerScreen(),
    const StatisticsScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
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
    return Scaffold(
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
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}