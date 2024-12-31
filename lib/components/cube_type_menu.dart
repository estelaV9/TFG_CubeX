import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

class CubeTypeMenu extends StatefulWidget {
  const CubeTypeMenu({super.key});

  @override
  State<CubeTypeMenu> createState() => _CubeTypeMenuState();
}

class _CubeTypeMenuState extends State<CubeTypeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0x00000000), // QUITAR COLOR DE FONDO
        body: Container(
            width: 250,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.purpleIntroColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topCenter, // CENTRAR EL TEXTO
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // CENTRADO
                  children: [
                    const Text(
                      "Select a cube type",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPurpleColor,
                          fontSize: 18),
                    ), // TITULO

                    // ESPACIO ENTRE EL TITULO Y EL GRIDVIEW
                    const SizedBox(height: 10),

                    // EXPANDIR EL GRIDVIEW
                    Expanded(
                      child: GridView.count(
                        // TRES COLUMNAS
                        crossAxisCount: 3,
                        // ESPACIADO HORIZONTAL ENTRE CONTAINERS
                        crossAxisSpacing: 10,
                        // ESPACIADO VERTICAL
                        mainAxisSpacing: 10,

                        // GENERAR LOS TIPOS DE CUBO QUE HAY EN LA BASE DE DATOS
                        children: List.generate(15, (index) {
                          // GESTURE DETECTOR PARA CUANDO PULSE EL TIPO DE CUBO
                          return GestureDetector(
                            onTap: () {
                              print("Hola");
                            }, // ACCIÓN AL TOCAR
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.purpleIntroColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.darkPurpleColor,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Tipo de cubo $index",
                                  style: const TextStyle(
                                    color: AppColors.darkPurpleColor,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
