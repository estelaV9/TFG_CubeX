import 'dart:async';

import 'package:esteladevega_tfg_cubex/data/dao/supebase/cubetype_dao_sb.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/dao/supebase/session_dao_sb.dart';
import '../../data/dao/supebase/time_training_dao_sb.dart';
import '../../data/dao/supebase/user_dao_sb.dart';
import '../../data/database/database_helper.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../../viewmodel/current_time.dart';
import '../../viewmodel/current_user.dart';
import '../utilities/internationalization.dart';
import 'tooltip/animated_tooltip.dart';

/// Widget contenedor que muestra un botón para añadir un tiempo manualmente.
///
/// Al presionar el botón de añadir tiempo, se despliega un cuadro de diálogo que contiene
/// dos campos de formulario donde el usuario puede introducir un "scramble" y un "tiempo".
/// Después de insertar los datos, estos se guardan en la base de datos y se muestra un mensaje
/// (snackbar) para indicar si la inserción fue exitosa o no.
///
/// Tambien tiene la opción de buscar por tiempo o por comentario, el cual filtra todos los tiempos
/// según el valor proporcionado.
class SearchTimeContainer extends StatefulWidget {
  const SearchTimeContainer({super.key});

  @override
  State<SearchTimeContainer> createState() => _SearchTimeContainerState();
}

class _SearchTimeContainerState extends State<SearchTimeContainer> {
  CubeTypeDaoSb cubeTypeDaoSb = CubeTypeDaoSb();
  SessionDaoSb sessionDaoSb = SessionDaoSb();
  UserDaoSb userDaoSb = UserDaoSb();
  TimeTrainingDaoSb timeTrainingDaoSb = TimeTrainingDaoSb();

  // VARIABLE PARA SABER SI SE ESTA BUSCANDO
  bool _isSearching = false;

  // CONTROLADOR PARA MANEJAR EL TEXTO DEL BUSCADOR
  final TextEditingController _searchController = TextEditingController();

  // FOCUS NODE PARA DETECTAR CUANDO SE PIERDE EL FOCO DEL TEXTFIELD
  final FocusNode _focusNode = FocusNode();

  // VARIABLE PARA GUARDAR EL TEXTO SI PIERDE EL FOCO O LO BUSCA
  String _searchText = "";

  /// Este método se llama cuando el `State` del widget cambia de dependencias.
  /// Es utilizado para obtener la localización del texto "search_time" antes de que
  /// el `State` sea completamente inicializado, asi se evita un error de context
  /// que ocurre si se intenta acceder a un `InheritedWidget` (como la localización)
  /// dentro de `initState()`.
  ///
  /// Este método reemplaza el uso de `initState()` para inicializar los valores relacionados
  /// con la localización y evitar problemas con la dependencia del `context`.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchText = Internationalization.internationalization
        .getLocalizations(context, "search_time");
  } // METODO PARA INICIALIZAR EL TEXTO DE BUSCAR EN VEZ DE E EL initState()

  /// Este método para cuando se inicializa el `State` del widget.
  /// Aquí configuramos un `Listener` para el `FocusNode` que detecta cuando el usuario
  /// deja de escribir en el campo de búsqueda, y dependiendo de si el campo tiene texto o no,
  /// se actualiza el texto de búsqueda mostrado.
  ///
  /// Cracteristicas:
  /// - Si el campo de texto no tiene foco, se oculta el `TextField` y se actualiza el
  ///   texto de búsqueda con lo que el usuario haya escrito o con el texto por defecto "search_time".
  /// - Este `Listener` ayuda a controlar el estado de búsqueda del widget y actualizar la UI
  ///   según lo que haga el usuario.
  @override
  void initState() {
    super.initState();
    // SE AGREGA UN LISTENER PARA DETECTAR CUANDO EL USUARIO DEJA DE ESCRIBIR
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isSearching = false; // OCULTAR EL TEXTFIELD CUANDO SE PIERDE EL FOCO
          if (_searchController.text.isNotEmpty) {
            // SI HA ESCRITO ALGO, EL TEXTO SERA LO QUE HAYA BUSCADO
            _searchText = _searchController.text;
          } else {
            // SINO, SE VUELVE A PONER "Search time"
            _searchText = Internationalization.internationalization
                .getLocalizations(context, "search_time");
          } // MOSTRAR UN TEXTO DEPENDIENDO SI EL USUARIO HA BUSCADO ALGO O NO
        });
      }
    });
  }

  /// Método para la eliminación de todos los tiempos asociados a la sesion actual.
  ///
  /// Primero obtiene el ID del usuario y verifica si es válido. Luego obtiene la sesión
  /// actual y el tipo de cubo actual. A continuación, se verifica si el tipo de cubo es válido
  /// y se busca la sesión relacionada con el usuario y el cubo. Si la sesión es válida,
  /// se eliminan todos los tiempos asociados a esa sesión y se muestra un `Snackbar`
  /// indicando si la eliminación fue exitosa o no.
  ///
  /// Si algún paso falla (como no encontrar el ID del usuario o el tipo de cubo), se
  /// muestra un error.
  Future<void> _deleteAllTimes() async {
    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDaoSb.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
      return;
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    // OBTENER LA SESSION Y EL TIPO DE CUBO ACTUAL
    final currentSession = context.read<CurrentSession>().session;
    final currentCube = context.read<CurrentCubeType>().cubeType;

    CubeType? cubeType =
        await cubeTypeDaoSb.getCubeTypeByNameAndIdUser(currentCube!.cubeName, idUser);
    if (cubeType.idCube == -1) {
      DatabaseHelper.logger.e("Error al obtener el tipo de cubo.");
      return;
    } // VERIFICAR QUE SI RETORNA EL TIPO DE CUBO CORRECTAMENTE

    // OBJETO SESION CON EL ID DEL USUARIO, NOMBRE Y TIPO DE CUBO
    SessionClass? session = await sessionDaoSb.getSessionByUserCubeName(
        idUser, currentSession!.sessionName, cubeType.idCube);

    if (session!.idSession != -1) {
      if (await timeTrainingDaoSb.deleteAllTimeBySession(session.idSession)) {
        AlertUtil.showSnackBarInformation(
            context, "all_times_deleted_successful");
      } else {
        AlertUtil.showSnackBarError(context, "all_times_deletion_failed");
      } // SE VERIFICA SI SE ELIMINAN TODOS LOS TIEMOPS
    } else {
      DatabaseHelper.logger.e(
          "No se encontro el id de la session actual: ${session.toString()}");
    } // SE VERIFICA QUE SE BUSCO BIEN EL ID
  } // ELIMINAR TODOS LOS TIEMPOS ASOCIADOS CNO LA SESION ACTUAL

  Widget build(BuildContext context) {
    // TIEMPO ACTUAL
    final currentTime = context.read<CurrentTime>();

    return Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.lightVioletColor.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SE MEUSTRA EL FORMUALRIO PARA AÑADIR TIEMPO MANUALMENTE
              IconClass.iconButton(context, () {
                // SE MEUSTRA EL FORMUALRIO PARA AÑADIR TIEMPO MANUALMENTE
                AlertUtil.showAlertFormAddTime(
                    "add_time",
                    "add_scramble_form",
                    "add_time_form",
                    "add_scramble_form_label",
                    "add_time_form_label",
                    context);
              }, "add_new_time", Icons.add_alarm),

              // CAMPO DE BUSQUEDA (SE MUESTRA SEGUN EL ESTADO)
              Expanded(
                child: _isSearching
                    ? TextField(
                        textAlign: TextAlign.center,
                        // ASIGNA EL CONTROLADOR AL TEXTFIELD
                        controller: _searchController,
                        // ASIGNA EL FOCUS NODE PARA DETECTAR CUANDO SE PIERDE EL FOCO
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: Internationalization.internationalization
                              .getLocalizations(
                                  context, "search_time_or_comments"),
                          border: InputBorder.none, // QUITAR BORDE
                        ),

                        onChanged: (value) {
                          // MIENTRAS EL USUARIO ESCRIBE, SE ACTUALIZAN LOS PARAMETROS DE BUSQUEDA

                          if (RegExp(r'^[\d.]+$').hasMatch(value)) {
                            // SI CONTIENE NUMEROS O UN PUNTO -> BUSQUEDA POR TIEMPO
                            currentTime.setSearchTime(value);
                          }
                          // SE VE si la entrada contiene solo letras (para la búsqueda por comentario)
                          else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            // SI CONTIENE SOLO LETRAS -> BUSQUEDA POR COMENTARIO
                            currentTime.setSearchComment(value);
                          } else {
                            // SI LO DEJA EN BLANCO SE RESTABLECE LOS VALORES
                            currentTime.setResetTimeTraining();
                          }
                        },

                        // AL PRESIONAR "ENTER", SE CIERRA EL CAMPO DE BUSQUEDA
                        onSubmitted: (value) {
                          setState(() {
                            _isSearching = false;
                            if (_searchController.text.isNotEmpty) {
                              // SI HA ESCRITO ALGO, EL TEXTO SERA LO QUE HAYA BUSCADO
                              _searchText = _searchController.text;

                              // FILTRADO
                              if (RegExp(r'^[\d.]+$').hasMatch(value)) {
                                // SI CONTIENE NUMEROS O UN PUNTO -> BUSQUEDA POR TIEMPO
                                currentTime.setSearchTime(value);
                              }
                              // SE VE si la entrada contiene solo letras (para la búsqueda por comentario)
                              else if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                // SI CONTIENE SOLO LETRAS -> BUSQUEDA POR COMENTARIO
                                currentTime.setSearchComment(value);
                              }
                            } else {
                              // SINO, SE VUELVE A PONER "Search time"
                              _searchText = Internationalization
                                  .internationalization
                                  .getLocalizations(context, "search_time");

                              // SE RESETEA EL CURRENT TIME
                              currentTime.setResetTimeTraining();
                            } // MOSTRAR UN TEXTO DEPENDIENDO SI EL USUARIO HA BUSCADO ALGO O NO
                          });
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSearching = true; // CAMBIA AL MODO DE BUSQUEDA
                          });
                          // SOLICITA EL FOCO PARA ESCRIBIR AUTOMATICAMENTE
                          _focusNode.requestFocus();
                        },
                        child: Text(
                          textAlign: TextAlign.center,
                          _searchText,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
              ),

              // BOTON PARA ELIMINAR TODOS LOS TIEMPOS DE UNA SESION
              IconClass.iconButtonImage(context, () {
                AlertUtil.showDeleteSessionOrCube(
                    context, "delete_all_times_label", "delete_all_times_hint",
                    () async {
                  await _deleteAllTimes();
                });
              }, "assets/trash-list.png", "choose_session", 28),

              // BOTON DE OPCIONES ADICIONALES
              Align(
                alignment: Alignment.centerRight,
                child: CustomPopover(
                  child: IconClass.iconButton(
                      context, null, "more_option", Icons.more_vert),
                ),
              ),
            ]));
  }
}
