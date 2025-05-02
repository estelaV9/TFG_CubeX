import 'package:flutter/material.dart';

import '../../model/time_training.dart';
import '../utilities/alert.dart';

/// Clase que representa un ítem de menú con texto y un ícono.
///
/// Esta clase se utiliza para definir los diferentes tipos de penalizaciones
/// que se pueden aplicar a un tiempo registrado en una sesión, como "No Penalty",
/// "DNF" (Did Not Finish) o "+2".
class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text; // TEXTO PARA EL ITEM DEL MENU
  final IconData icon; // ICONO PARA EL ITEM DEL MENU
}

/// Clase que agrupa los ítems de menú para las penalizaciones.
///
/// Esta clase contiene una lista de ítems predefinidos:
/// - "No Penalty".
/// - "DNF".
/// - "+2".
/// Maneja la lógica de actualización del icono de penalización en función
/// del ítem seleccionado. Además, puede construir un `Widget` para cada item del
/// menú y un método para manejar la selección de penalizaciones.
class MenuItems {
  // LISTA DE LOS ITEM DEL MENU DE LAS PENALIZACIONES
  static const List<MenuItem> items = [noPenalty, dnf, plusTwo];

  // ITEM DEL MENU DE PENALIZACIONS
  static const noPenalty = MenuItem(text: 'No Penalty', icon: Icons.block);
  static const dnf = MenuItem(text: 'DNF', icon: Icons.close);
  static const plusTwo = MenuItem(text: '+2', icon: Icons.timer);

  /// `Widget` que representa un ítem de menú visualmente con su ícono y texto.
  ///
  /// Este método es utilizado para construir la interfaz del menú cuando se despliega
  /// el `DropdownButton`, mostrando cada ítem con su ícono y texto.
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Método que se ejecuta cuando el usuario selecciona un ítem del menú.
  /// Actualiza el icono de la penalización en la clase `AlertUtil` en función
  /// del ítem elegido.
  ///
  /// [context] El contexto de la aplicación.
  /// [item] El ítem de menú seleccionado.
  /// [timetraining] El objeto de tiempo que será modificado según la penalización seleccionada.
  static void onChanged(
      BuildContext context, MenuItem item, TimeTraining timetraining) {
    switch (item) {
      case MenuItems.noPenalty:
        AlertUtil.iconPenalty = Icons.block;
        break;
      case MenuItems.dnf:
        AlertUtil.iconPenalty = Icons.close;
        break;
      case MenuItems.plusTwo:
        AlertUtil.iconPenalty = Icons.timer;
        break;
    }
  }
}