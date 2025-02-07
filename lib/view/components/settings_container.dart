import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:flutter/material.dart';

import '../../utilities/internationalization.dart';

class SettingsContainer extends StatefulWidget {
  final void Function() functionArrow;
  final IconData icon;
  final String name;
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
            style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurpleColor),
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