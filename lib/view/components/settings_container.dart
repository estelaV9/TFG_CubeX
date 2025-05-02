import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:flutter/material.dart';

import '../utilities/app_styles.dart';

/// Widget que representa un contenedor de opción de ajustes, con un ícono, un texto y
/// un botón para redirigir a una pantalla relacionada con la opción seleccionada o
/// mostrar una alerta.
class SettingsContainer extends StatefulWidget {
  /// Función que se ejecuta cuando se presiona el ícono de la opción
  final void Function() functionArrow;
  /// Ícono que representa la opción de ajustes
  final IconData icon;
  /// Nombre de la opción en texto
  final String name;
  /// Tooltip que se muestra cuando se pasa el ratón sobre el ícono
  final String tooltip;

  const SettingsContainer(
      {super.key,
      required this.functionArrow,
      required this.name,
      required this.icon,
      required this.tooltip});

  @override
  State<SettingsContainer> createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.downLinearColor,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          // ICONO QUE REPRESENTA LA OPCION DE AJUSTES
          IconClass.iconMaker(context, widget.icon, widget.tooltip),

          const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),

          // NOMBRE DE LA OPCION
          Text(
            widget.name,
            style: AppStyles.darkPurpleAndBold(23),
          ),

          // EL EXPANDED HACE QUE UBIQUE EL ICON AL FINAL DEL CONTAINER
          Expanded(child: Container()),

          // ICONO PARA CUANDO PULSE ESA OPCION
          IconClass.iconButton(context, widget.functionArrow,
              "Go to ${widget.name}", Icons.arrow_right),
        ],
      ),
    );
  }
}