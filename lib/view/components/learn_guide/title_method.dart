import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/dao/supebase/method_dao_sb.dart';
import '../../../viewmodel/cube_selection_provider.dart';
import '../../utilities/app_color.dart';
import '../Icon/icon.dart';

/// Widget que muestra un desplegable (`DropdownButton`) para seleccionar
/// el método de resolución del cubo.
///
/// Este widget permite al usuario elegir entre distintos métodos de resolución
/// según el tipo de cubo que haya elegido el usuario.
///
/// ### Características:
/// - El valor inicial del desplegable es el primer método de la lista.
/// - Incluye un `Tooltip` con el mensaje internacionalizado.
/// - Los métodos se cargan desde la base de datos según el tipo de cubo seleccionado.
/// - Muestra un indicador de carga hasta que los métodos han sido obtenidos.
///
/// Al seleccionar una nueva opción, el estado del widget se actualiza con el
/// método elegido.
class TitleMethod extends StatefulWidget {
  const TitleMethod({super.key});

  @override
  State<TitleMethod> createState() => _TitleMethodState();
}

class _TitleMethodState extends State<TitleMethod> {
  // LISTA DE METODOS DEL TIPO DE CUBO
  MethodDaoSb methodDaoSb = MethodDaoSb();
  List<String> listOfMethods = [];
  bool isLoading = true;

  // VALOR DEL DROPDOWNBUTTON
  late String? dropdownValue;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    // CARGAR LOS METODOS DEL DDB Y DARLE EL VALOR INICIAL
    final cubeProvider =
        Provider.of<CubeSelectionProvider>(context, listen: false);
    _loadMethods(cubeProvider.selectedCube);
  }

  /// Carga los métodos de resolución asociados al tipo de cubo indicado
  /// en [cubeName] y actualiza el estado del widget.
  ///
  /// *Características*:
  /// - Limpia la lista anterior.
  /// - Añade los métodos obtenidos desde la base de datos aplicando internacionalización.
  /// - Establece el valor inicial del `DropdownButton`.
  /// - Actualiza el indicador de carga.
  Future<void> _loadMethods(String cubeName) async {
    // METODOS DE UN CUBO
    final loadedMethods = await methodDaoSb.getMethods(cubeName);

    // LIMPIAMOS LA LISTA POR SI CAMBIA DE CUBO
    listOfMethods.clear();

    for (final method in loadedMethods) {
      listOfMethods.add(
        // GUARDAMOS LOS DATOS INTERNACIONALIZANDO
        Internationalization.internationalization
            .getLocalizations(context, method.methodName),
      );
    } // RECORREMOS LOS DATOS OBTENIDOS Y LOS AÑADIMOS A LA LISTA DE METODO

    setState(() {
      // SETTEAMOS LOS VALORES DE LOS METODOS Y AÑADIMOS EL PRIMER VALOR DEL DDB
      dropdownValue = listOfMethods.isNotEmpty ? listOfMethods.first : null;
      isLoading = listOfMethods.isEmpty; // DEJA DE CARGAR EL PRIMER VALOR
    });
  }

  @override
  Widget build(BuildContext context) {
    // SI CAMBIA DE CUBO CAMBIA
    final cubeProvider =
        Provider.of<CubeSelectionProvider>(context, listen: false);
    _loadMethods(cubeProvider.selectedCube);
    return Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {},
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.downLinearColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Tooltip(
                message: Internationalization.internationalization
                    .getLocalizations(context, "change_cube_method"),
                child: isLoading == true
                    ? const CircularProgressIndicator()
                    : DropdownButton(
                        isExpanded: true,
                        // shrink() ELIMINA EL HUECO DEL ICONO
                        icon: const SizedBox.shrink(),
                        dropdownColor: AppColors.downLinearColor,
                        value: dropdownValue,
                        iconDisabledColor: Colors.black,
                        // QUITAR EL SUBRAYADO
                        underline: const SizedBox(),
                        borderRadius: BorderRadius.circular(12),
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: "Caprasimo"),
                        items: listOfMethods
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return listOfMethods.map((String value) {
                            return Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(value),
                                // ICONO
                                IconClass.iconButton(
                                    context,
                                    null,
                                    "",
                                    Icons.swap_horiz,
                                    null,
                                    30,
                                    const EdgeInsets.all(0),
                                    Colors.white),
                              ],
                            );
                          }).toList();
                        },
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
              )),
        ));
  }
}