import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../../utilities/internationalization.dart';

/// Widget contenedor que muestra un botón para añadir un tiempo manualmente.
///
/// Al presionar el botón de añadir tiempo, se despliega un cuadro de diálogo que contiene
/// dos campos de formulario donde el usuario puede introducir un "scramble" y un "tiempo".
/// Después de insertar los datos, estos se guardan en la base de datos y se muestra un mensaje
/// (snackbar) para indicar si la inserción fue exitosa o no.

class SearchTimeContainer extends StatefulWidget {
  const SearchTimeContainer({super.key});

  @override
  State<SearchTimeContainer> createState() => _SearchTimeContainerState();
}

class _SearchTimeContainerState extends State<SearchTimeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.lightVioletColor.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconClass.iconButton(context, (){
              // SE MEUSTRA EL FORMUALRIO PARA AÑADIR TIEMPO MANUALMENTE
              AlertUtil.showAlertFormAddTime("add_time", "add_scramble_form", "add_time_form", "add_scramble_form_label", "add_time_form_label", context);
            }, "add_new_time", Icons.add_alarm),

            Text(
                Internationalization.internationalization.getLocalizations(context, "search_time"),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),

            IconClass.iconButton(context, (){}, "more_option", Icons.more_vert)
          ],
        ),
    );

  }
}
