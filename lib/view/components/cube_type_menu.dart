import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/time_training_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/user_dao.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/database/database_helper.dart';
import '../../model/cubetype.dart';
import '../utilities/internationalization.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../../viewmodel/current_user.dart';

/// Componente de menú para seleccionar un tipo de cubo.
///
/// Este componente permite al usuario seleccionar entre diferentes tipos de cubos
/// o crear un nuevo tipo de cubo. Además, permite la gestión de los tipos de cubos
/// como la creación, selección y eliminación de los tipos de cubos.
///
/// Se utiliza en un contexto de base de datos para gestionar los
/// tipos de cubos y las sesiones asociadas a estos.
class CubeTypeMenu extends StatefulWidget {
  /// Función de devolución de llamada que se ejecuta cuando se selecciona un tipo de cubo.
  ///
  /// El tipo de cubo seleccionado se pasa como argumento a la función.
  final void Function(CubeType selectedCubeType) onCubeTypeSelected;

  const CubeTypeMenu({super.key, required this.onCubeTypeSelected});

  @override
  State<CubeTypeMenu> createState() => _CubeTypeMenuState();
}

class _CubeTypeMenuState extends State<CubeTypeMenu> {
  CubeTypeDao cubeTypeDao = CubeTypeDao();
  UserDao userDao = UserDao();
  List<CubeType> cubeTypes = [];

  /// Obtiene todos los tipos de cubos desde la base de datos y los carga en la
  /// lista `cubeTypes`.
  void getTotalCubes() async {
    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    List<CubeType> result = await cubeTypeDao.getCubeTypes(idUser);
    setState(() {
      cubeTypes = result;
    });
  } // METODO PARA SETTEAR EL NUMERO DE TIPOS DE CUBOS

  /// Inserta un nuevo tipo de cubo en la base de datos.
  ///
  /// Si el nombre del tipo de cubo no existe, lo inserta y recarga la lista de
  /// tipos de cubos.
  ///
  /// Se muestra un `SnackBar` si se insertó correctamente o no.
  Future<void> insertNewType(String name, int idUser) async {
    if (!await cubeTypeDao.isExistsCubeTypeName(name)) {
      if (await cubeTypeDao.insertNewType(name, idUser)) {
        getTotalCubes(); // RECARGAMOS LA LISTA DE TIPOS DE CUBOS
        AlertUtil.showSnackBarInformation(
            context, "The new type was successfully inserted");
      } else {
        // SI NO SE INSERTO CORRECTAMENTE SE MUESTRA UN ERROR
        AlertUtil.showSnackBarError(
            context, "cube_type_deletion_failed");
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
                    Internationalization.internationalization
                        .createLocalizedSemantics(
                      context,
                      "select_cube_type",
                      "select_cube_type",
                      "select_cube_type",
                      const TextStyle(
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
                                  "delete_cube_type_label",
                                  "delete_cube_type_hint",
                                  () async {
                                String cubeName = cubeTypes[index].cubeName;

                                if (await cubeTypeDao
                                    .deleteCubeType(cubeName)) {
                                  AlertUtil.showSnackBarInformation(
                                      context, "cube_type_deleted_successful");
                                  getTotalCubes(); // VOLVEMOS A CARGAR LOS TIPOS DE CUBO
                                } else {
                                  AlertUtil.showSnackBarError(context,
                                      "cube_type_deletion_failed");
                                } // SE ELIMINA EL TIPO DE CUBO
                              });
                            },
                            onTap: () async {
                              SessionDao sessionDao = SessionDao();
                              UserDao userDao = UserDao();
                              TimeTrainingDao timeTrainingDao = TimeTrainingDao();

                              // SE ACTUALIZA EL TIPO DE CUBO EN EL PROVIDER
                              final currentCubeType = Provider.of<CurrentCubeType>(this.context, listen: false);
                              currentCubeType.setCubeType(cubeTypes[index]); // SE ACTUALIZA EL ESTADO GLOBAL

                              CubeType? cubeType = await cubeTypeDao.cubeTypeDefault(currentCubeType.cubeType!.cubeName);
                              if (cubeType == null) {
                                DatabaseHelper.logger.e("Error al obtener el tipo de cubo.");
                                return;
                              } // VERIFICAR QUE SI RETORNA EL TIPO DE CUBO CORRECTAMENTE


                              // CUANDO SE CAMBIE EL TIPO DE CUBO, SE CAMBIA LA SESION A LA DE POR DEFECTO
                              // OBTENER EL USUARIO ACTUAL
                              final currentUser = context.read<CurrentUser>().user;
                              // OBTENER EL ID DEL USUARIO
                              int idUser = await userDao.getIdUserFromName(currentUser!.username);
                              if (idUser == -1) {
                                DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
                                return;
                              } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

                              // GUARDAR LOS DATOS DE LA SESION EN EL ESTADO GLOBAL
                              final currentSession = Provider.of<CurrentSession>(
                                  this.context,
                                  listen: false);
                              Session? sessionDefault =
                                await sessionDao.getSessionByUserCubeName(idUser, "Normal", cubeType.idCube);

                              if(sessionDefault != null){
                                // SE ACTUALIZA EL ESTADO GLOBAL
                                currentSession.setSession(sessionDefault);

                                var timesList = await timeTrainingDao.getTimesOfSession(currentSession.session!.idSession);

                                // GUARDAR LOS DATOS DE LAS ESTADISTICAS EN EL ESTADO GLOBAL
                                final currentStatistics = Provider.of<CurrentStatistics>(
                                    this.context, listen: false);
                                // SE ACTUALIZA EL ESTADO GLOBAL
                                currentStatistics.updateStatistics(timesListUpdate: timesList);


                                widget.onCubeTypeSelected(cubeTypes[index]);
                                // SE CIERRA EL MENU UNA VEZ ELIJA
                                Navigator.of(context).pop();
                              } else{
                                DatabaseHelper.logger.e("No se encontro la sesion ${sessionDefault.toString()} del tipo de cubo ${cubeType.toString()}");
                              } // VERIFICA QUE LA SESION POR DEFECTO DE ESE TIPO DE CUBO NO SEA NULO
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
                              "insert_new_type_label",
                              "insert_new_type_label",
                              "enter_new_cube_type",
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
                        child: Internationalization.internationalization
                            .createLocalizedSemantics(
                          context,
                          "create_new_cube_type",
                          "create_new_cube_type",
                          "create_new_cube_type",
                          const TextStyle(
                              fontSize: 16),
                        ),)
                  ],
                ),
              ),
            )));
  }
}
