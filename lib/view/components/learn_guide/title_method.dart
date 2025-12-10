import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/learn_guide/method_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/learn_guide/cube_selection_provider.dart';
import '../../utilities/app_color.dart';
import '../Icon/icon.dart';

/// Widget que muestra un desplegable (`DropdownButton`) para seleccionar
/// el método de resolución del cubo.
///
/// Este widget permite al usuario elegir entre distintos métodos de resolución
/// según el tipo de cubo que haya elegido el usuario.
///
/// ### Características:
/// - Carga automaticamente la lista de metodos disponibles segun el cubo.
/// - Restaura el metodo guardado previamente en `SharedPreferences`.
/// - Permite cambiar el metodo y lo guarda de nuevo.
/// - Muestra un indicador de carga mientras se obtienen los datos.
///
/// Al seleccionar una nueva opción, el estado del widget se actualiza con el
/// método elegido.
class TitleMethod extends StatefulWidget {
  const TitleMethod({super.key});

  @override
  State<TitleMethod> createState() => _TitleMethodState();
}

class _TitleMethodState extends State<TitleMethod> {
  // ALMACENA EL ULTIMO CUBO PARA DETECTAR CAMBIOS
  String? _lastCube;

  /// Método del ciclo de vida que se ejecuta cuando cambian dependencias
  /// obtenidas mediante Provider.of(context).
  ///
  /// Características:
  /// - Detectar si el usuario ha cambiado el tipo de cubo en la app.
  /// - Volver a cargar los métodos correspondientes a ese cubo.
  /// - Restaurar el método seleccionado anteriormente desde SharedPreferences.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final cubeProvider = Provider.of<CubeSelectionProvider>(context);
    final methodProvider = Provider.of<MethodSelectionProvider>(context);

    if (_lastCube != cubeProvider.selectedCube) {
      _lastCube = cubeProvider.selectedCube;

      // CARGA LOS METODOS Y EL METODO SELECCIONADO GUARDADO guardado
      methodProvider.loadMethods(_lastCube!, context);
    } // SI EL CUBO HA CAMBIADO, CARGAMOS SUS METODOS

    // ACTUALIZAR ID DEL METODO
    methodProvider.setIdMethod(methodProvider.selectedMethod, _lastCube!);
  }

  @override
  Widget build(BuildContext context) {
    final cubeName = Provider.of<CubeSelectionProvider>(context).selectedCube;
    final methodProvider = Provider.of<MethodSelectionProvider>(context);

    return Align(
        alignment: Alignment.centerLeft,
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
              child: methodProvider.isLoading == true
                  ? const CircularProgressIndicator()
                  : DropdownButton(
                      isExpanded: true,
                      // shrink() ELIMINA EL HUECO DEL ICONO
                      icon: const SizedBox.shrink(),
                      dropdownColor: AppColors.downLinearColor,
                      value: methodProvider.selectedMethod,
                      iconDisabledColor: Colors.black,
                      // QUITAR EL SUBRAYADO
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(12),
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: "Caprasimo"),

                      // ITEMS DEL DESPLEGABLE
                      items: methodProvider.methods
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(Internationalization.internationalization
                              .getLocalizations(context, value)),
                          onTap: () {
                            // GUARDAR EL METODO CUANDO SE SELECCIONA EN LA LISTA
                            methodProvider.setSelectedMethod(value, cubeName);
                          },
                        );
                      }).toList(),

                      // TEXTO DEL ITEM SELECCIONADO
                      selectedItemBuilder: (BuildContext context) {
                        return methodProvider.methods.map((String value) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Internationalization.internationalization
                                  .getLocalizations(context, value)),
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
                        if (value != null) {
                          methodProvider.setSelectedMethod(value, cubeName);
                        }
                      },
                    ),
            )));
  }
}