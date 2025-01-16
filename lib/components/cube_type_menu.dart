import 'package:esteladevega_tfg_cubex/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../model/cubetype.dart';

class CubeTypeMenu extends StatefulWidget {
  const CubeTypeMenu({super.key});

  @override
  State<CubeTypeMenu> createState() => _CubeTypeMenuState();
}

class _CubeTypeMenuState extends State<CubeTypeMenu> {
  CubeTypeDao cubeTypeDao = CubeTypeDao();
  List<CubeType> cubeTypes = [];

  void getTotalCubes() async {
    List<CubeType> result = await cubeTypeDao.getCubeTypes();
    setState(() {
      cubeTypes = result;
    });
  } // METODO PARA SETTEAR EL NUMERO DE TIPOS DE CUBOS

  void insertNewType (String name) async {
    if(!await cubeTypeDao.isExistsCubeTypeName(name)){
      if(await cubeTypeDao.insertNewType(name)){
        getTotalCubes(); // RECARGAMOS LA LISTA DE TIPOS DE CUBOS
        AlertUtil.showSnackBarInformation(context, "The new type was successfully inserted");
      } else {
        // SI NO SE INSERTO CORRECTAMENTE SE MUESTRA UN ERROR
        AlertUtil.showSnackBarError(context, "Failed to insert the new type. Try again, please.");
      } // INSERTAR TIPO DE CUBO
    } else {
      // SI EL NOMBRE YA EXISTE SE MUESTRA UN ERROR
      AlertUtil.showSnackBarError(context, "The chosen name already exists");
    } // VERIFICAR SI EXISTE EL TIPO DE CUBo
  }

  @override
  void initState() {
    super.initState();
    getTotalCubes(); // AL INCIIALIZARSE LA APLICACION SE ACTUALIZA EL TOTAL
  }

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
                        children: cubeTypes.map((cubeType) {
                          // GESTURE DETECTOR PARA CUANDO PULSE EL TIPO DE CUBO
                          return GestureDetector(
                            onTap: () {
                              print(cubeType.cubeName);
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
                                  cubeType.cubeName, // MUESTRA EL NOMBRE DEL CUBO
                                  style: const TextStyle(
                                    color: AppColors.darkPurpleColor,
                                    fontSize: 14,
                                  )
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // ESPACIO ENTRE EL LISTVIEW Y EL BOTON
                    const SizedBox(height: 10),

                    // BOTON PARA CREAR NUEVA SESION
                    ElevatedButton(
                        onPressed: () async {
                          String? name = await  AlertUtil.showAlertForm("Insert a new type", "Insert a new type", "Enter a new cube type", context);
                          insertNewType(name!);
                        }, child: const Text("Create a new cube type"))
                  ],
                ),
              ),
            )));
  }
}
