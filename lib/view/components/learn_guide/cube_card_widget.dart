import 'package:flutter/material.dart';
import 'package:esteladevega_tfg_cubex/model/cubetype.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';

/// Widget que representa una tarjeta individual para mostrar un cubo
/// en la guia de aprendizaje.
///
/// Muestra un grid con casillas que representan el cubo segun su tipo.
/// Cambia su estilo visual y tamaño cuando esta seleccionado.
class CubeCardWidget extends StatelessWidget {
  /// Tipo de cubo que se mostrara en esta tarjeta
  final CubeType cubeType;

  /// Indica si el cubo esta seleccionado para destacar su estilo
  final bool isSelected;

  const CubeCardWidget({
    super.key,
    required this.cubeType,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    // DETERMINAMOS EL TAMAÑO DEL CUBO SEGUN SU NOMBRE
    int dimension = _getCubeDimension(cubeType.cubeName);
    int totalTiles = dimension * dimension;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // SI ESTA SELECCIONADO AUMENTA EL TAMAÑO Y SI NO SE HACE MAS PEQUEÑO
      width: 120,
      height: 120,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // SI ESTA SELECCIONADO SE PINTA CON COLOR MORADO Y CON BORDE Y SI NO
        // E PINTA NEGRO Y SIN BORDE
        color: isSelected ? AppColors.darkPurpleColor : Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.purpleIntroColor : Colors.transparent,
          width: isSelected ? 3 : 0,
        ),
      ),

      // GRID QUE REPRESENTA EL CUBO
      child: GridView.count(
        crossAxisCount: dimension,
        padding: EdgeInsets.zero,
        children: List.generate(totalTiles, (index) {
          return Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: AppColors.rightColor,
              borderRadius: BorderRadius.circular(6),
            ),
          );
        }),
      ),
    );
  }

  /// Metodo privado para obtener la dimension del cubo según el nombre que se pasa.
  /// Si no es ninguno de los esperados, devuelve 2 por defecto.
  int _getCubeDimension(String cubeName) {
    if (cubeName == "2x2x2") return 2;
    if (cubeName == "3x3x3") return 3;
    if (cubeName == "4x4x4") return 4;
    return 2; // POR DEFECTO
  }
}