import 'package:esteladevega_tfg_cubex/view/screen/timer_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../screen/historial_screen.dart';

/// Clase que representa la **barra de navegación inferior** de la aplicación.
///
/// Esta clase permite al usuario navegar entre diferentes pantallas de la aplicación utilizando
/// una barra de navegación en la parte inferior de la pantalla.
/// El índice seleccionado determina qué pantalla se muestra.
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1; // INDICE ACTUAL DEL BOTTOM NAVIGATION BAR

  // LISTA DE WIDGETS PARA CADA PANTALLA
  final List<Widget> _screens = [
    /// nota: se cambiara, pero se necesita una para que el timer empiece en 1 en el medio
    const HistorialScreen(),
    const TimerScreen(),
    // StatisticScreen()
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index; // ACTUALIZA EL INDICE
    });
  } // METODO PARA CUANDO PULSE EN LA BARRA DE NAVEGACION

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_search), label: "Historial"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timer"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph), label: "Statistics")
        ],
        currentIndex: _currentIndex,
        onTap: _onTap,
        // COLOR DE FONDO DEL NAVIGATION
        backgroundColor: AppColors.lightVioletColor,

        // COLOR Y ESTILO DEL ITEM SELECCIONADO
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: true,
        // MUESTRA EL LABEL

        // COLOR Y ESTILO DEL ITEM NO SELECCIONADO
        unselectedItemColor: AppColors.darkPurpleColor,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        showUnselectedLabels: false, // OCULTA LOS LABELS
      ),
    );
  }
}