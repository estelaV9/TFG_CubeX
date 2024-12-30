import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

import 'icon.dart';

class CubeHeaderContainer extends StatefulWidget {
  const CubeHeaderContainer({super.key});

  @override
  State<CubeHeaderContainer> createState() => _CubeHeaderContainerState();
}

class _CubeHeaderContainerState extends State<CubeHeaderContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      decoration: BoxDecoration(
        color: AppColors.lightVioletColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            const SizedBox(width: 20),
            const Column(
              children: [
                Text(
                  "Cube type name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPurpleColor),
                ),
                Text("Name Session")
              ],
            ),

            // ICONO DE MENU CERRADO/ABIERTO
            const AnimatedIconWidget(
                animatedIconData: AnimatedIcons.menu_close),

            const SizedBox(width: 10),

            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.square,
                  color: AppColors.darkPurpleColor,
                ))
          ],
        ),
      ),
    );
  }
}
