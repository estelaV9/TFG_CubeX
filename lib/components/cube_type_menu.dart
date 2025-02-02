import 'package:esteladevega_tfg_cubex/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../model/cubetype.dart';
import '../state/current_cube_type.dart';
import '../state/current_user.dart';

class CubeTypeMenu extends StatefulWidget {
  // FUNCION PARA ENVIAR EL TIPO DE CUBO SELECCIONADO AL COMPONENTE QUE CREA
  // EL CubeTypeMenu
  final void Function(CubeType selectedCubeType) onCubeTypeSelected;

  const CubeTypeMenu({super.key, required this.onCubeTypeSelected});

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

  Future<void> insertNewType(String name, int idUser) async {
    if (!await cubeTypeDao.isExistsCubeTypeName(name)) {
      if (await cubeTypeDao.insertNewType(name, idUser)) {
        getTotalCubes(); // RECARGAMOS LA LISTA DE TIPOS DE CUBOS
        AlertUtil.showSnackBarInformation(
            context, "The new type was successfully inserted");
      } else {
        // SI NO SE INSERTO CORRECTAMENTE SE MUESTRA UN ERROR
        AlertUtil.showSnackBarError(
            context, "Failed to insert the new type. Try again, please.");
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
            decoration: const BoxDecoration(
              // SE LE AGREGA BORDE CIRCULAR A LA PARTE DE ARRIBA SOLO
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                          fontSize: 25),
                    ), // TITULO

                    // ESPACIO ENTRE EL TITULO Y EL DIVIDER
                    const SizedBox(height: 8),

                    // LINEA DIVISORIA ENTRE EL TITULO Y EL GridView
                    const Divider(
                      height: 10,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                      color: AppColors.darkPurpleColor,
                    ),

                    // ESPACIO ENTRE EL DIVIDER Y EL GridView
                    const SizedBox(height: 10),

                    // EXPANDIR EL GridView
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          // TRES COLUMNAS
                          crossAxisCount: 3,
                          // ESPACIADO HORIZONTAL ENTRE CONTAINERS
                          crossAxisSpacing: 10,
                          // ESPACIADO VERTICAL
                          mainAxisSpacing: 10,
                        ),
                        itemCount: cubeTypes.length, // TOTAL DE CUBOS
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              // SI MANTIENE PULSADO LE SALDRA LA OPCION DE ELIMINAR LA SESION
                              AlertUtil.showDeleteSessionOrCube(
                                  context,
                                  "Delete Cube Type",
                                  "Are you sure you want to delete all your saved times with that cube?",
                                  () async {
                                String cubeName = cubeTypes[index].cubeName;

                                if (await cubeTypeDao
                                    .deleteCubeType(cubeName)) {
                                  AlertUtil.showSnackBarInformation(
                                      context, "Cube type deleted successful");
                                  getTotalCubes(); // VOLVEMOS A CARGAR LOS TIPOS DE CUBO
                                } else {
                                  AlertUtil.showSnackBarError(context,
                                      "Cube type deletion failed. Please try again.");
                                } // SE ELIMINA EL TIPO DE CUBO
                              });
                            },
                            onTap: () {
                              // SE ACTUALIZA EL TIPO DE CUBO EN EL PROVIDER
                              final currentCubeType = Provider.of<CurrentCubeType>(this.context, listen: false);
                              currentCubeType.setCubeType(cubeTypes[index]); // SE ACTUALIZA EL ESTADO GLOBAL
                              print(currentCubeType);
                              widget.onCubeTypeSelected(cubeTypes[index]);
                              // SE CIERRA EL MENU UNA VEZ ELIJA
                              Navigator.of(context).pop();
                            }, // ACCION AL TOCAR
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
                                    // SE MUESTRA EL NOMBRE DEL CUBO
                                    cubeTypes[index].cubeName,
                                    style: const TextStyle(
                                      color: AppColors.darkPurpleColor,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ESPACIO ENTRE EL LISTVIEW Y EL BOTON
                    const SizedBox(height: 10),

                    // BOTON PARA CREAR NUEVO TIPO DE CUBO
                    ElevatedButton(
                        onPressed: () async {
                          String? name = await AlertUtil.showAlertForm(
                              "Insert a new type",
                              "Insert a new type",
                              "Enter a new cube type",
                              context);
                          UserDao userDao = UserDao();
                          // OBTENEMOS LOS DATOS DEL USUARIO
                          final currentUser = context.read<CurrentUser>().user;
                          int idUser = await userDao
                              .getIdUserFromName(currentUser!.username);
                          await insertNewType(name!, idUser);

                          // CREAR SU SESION POR DEFECTO
                          SessionDao sessionDao = SessionDao();
                          CubeType cubeNewType =
                              await cubeTypeDao.cubeTypeDefault(name);
                          if(cubeNewType.idCube == -1){
                            DatabaseHelper.logger.e("No se pudo conseguir el tipo de cubo al buscarlo por su nombre");
                          } else {
                            Session newSession = Session(
                                idUser: idUser,
                                sessionName: "Normal",
                                idCubeType: cubeNewType.idCube!);
                            if (await sessionDao.insertSession(newSession)) {
                              DatabaseHelper.logger.i(
                                  "Se creó la sesión por defecto correctament");
                            } else {
                              DatabaseHelper.logger.e(
                                  "Ocurrió un error al crear la sesion por defecto");
                            } // VERIFICAR SI SE CREO LA SESION POR DEFECTO CORRECTMANTE
                          } // VERIFICAR QUE SE OBTIENE BIEN EL TIPO DE CUBO
                        },
                        child: const Text("Create a new cube type"))
                  ],
                ),
              ),
            )));
  }
}
