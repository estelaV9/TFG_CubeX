import 'package:carousel_slider/carousel_slider.dart';
import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:esteladevega_tfg_cubex/view/components/learn_guide/cube_card_widget.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../viewmodel/cube_selection_provider.dart';

/// Widget que muestra una franja horizontal con un carrusel de cubos
/// para seleccionar el tipo de cubo en la guia de aprendizaje.
///
/// Integra un CarouselSlider que permite seleccionar entre distintos tipos
/// de cubos, resaltando el cubo seleccionado y guardando la seleccion con el
/// `CubeSelectionProvider` y [SharedPreferences].
class CubeSelectorRow extends StatefulWidget {
  const CubeSelectorRow({super.key});

  @override
  State<CubeSelectorRow> createState() => _CubeSelectorRowState();
}

class _CubeSelectorRowState extends State<CubeSelectorRow> {
  // CONTROLADOR PARA EL CARRUSEL DE LOS CUBOS
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // LISTA DE TIPOS DE CUBOS DISPONIBLES PARA LA SELECCION
  final List<CubeType> _cubeTypes = [
    CubeType(cubeName: "2x2x2"),
    CubeType(cubeName: "3x3x3"),
    CubeType(cubeName: "4x4x4"),
  ];

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.sizeOf(context).width;
    final cubeProvider = Provider.of<CubeSelectionProvider>(context);

    // OBTENEMOS EL INDICE DEL CUBO SELECCIONADO ACTUALMENTE EN EL PROVIDER
    int selectedIndex = 0; // POR DEFECTO EL PRIMERO
    for (int i = 0; i < _cubeTypes.length; i++) {
      if (_cubeTypes[i].cubeName == cubeProvider.selectedCube) {
        selectedIndex = i;
        break; // TERMINAMOS EL BUCLE AL ENCONTRARLO
      }
    }

    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 120,
            // SE AJUSTA EL TAMAÑO DEL VIEWPORT SEGUN EL ANCHO DE PANTALLA
            viewportFraction: sizeWidth > 340 ? 0.4 : 0.8,
            initialPage: selectedIndex,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            // CUANDO CAMBIA LA PAGINA DEL CARRUSEL ACTUALIZA EL PROVIDER
            onPageChanged: (index, reason) {
              setState(() {
                // ACTUALIZA EN EL PROVIDER Y GUARDA EN PREFERENCIAS
                cubeProvider.setSelectedCube(_cubeTypes[index].cubeName);
              });
            },
          ),
          items: _cubeTypes.asMap().entries.map((entry) {
            int index = entry.key;
            CubeType cube = entry.value;

            return GestureDetector(
              onTap: () {
                // AL TOCAR UN CUBO ACTUALIZA EL PROVIDER Y MUEVE EL CARRUSEL A ESA PAGINA
                cubeProvider.setSelectedCube(cube.cubeName);
                _carouselController.animateToPage(index);
              },
              child: CubeCardWidget(
                cubeType: cube,
                // PASA SI EL CUBO ESTA SELECCIONADO PARA CAMBIAR EL ESTILO
                isSelected: cube.cubeName == cubeProvider.selectedCube,
              ),
            );
          }).toList(),
        ),

        // INDICADORES
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _cubeTypes.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // CAMBIA LA OPACIDAD SEGUN SI ESTA SELECCIONADO O NO
                  color: AppColors.rightColor.withOpacity(
                      cubeProvider.selectedCube == entry.value.cubeName
                          ? 0.9
                          : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}