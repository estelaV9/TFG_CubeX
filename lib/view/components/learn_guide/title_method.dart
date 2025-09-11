import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/material.dart';

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
///
/// Al seleccionar una nueva opción, el estado del widget se actualiza con el
/// método elegido.
class TitleMethod extends StatefulWidget {
  const TitleMethod({super.key});

  @override
  State<TitleMethod> createState() => _TitleMethodState();
}

class _TitleMethodState extends State<TitleMethod> {
  // LISTA DE METODOS DE PRUEBA
  List<String> listOfMethods = [
    "Principiante",
    "Fridrich Completo",
    "Fridrich Reducido"
  ];

  // VALOR DEL DROPDOWNBUTTON
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    // VALOR INICIAL DEL DROPDOWNBUTTON
    dropdownValue = listOfMethods.first;
  }

  @override
  Widget build(BuildContext context) {
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
                child: DropdownButton(
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
