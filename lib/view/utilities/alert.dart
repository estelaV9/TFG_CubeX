import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:esteladevega_tfg_cubex/data/dao/supebase/cubetype_dao_sb.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/model/time_training.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/validator.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/settings_option/current_language.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/dao/supebase/session_dao_sb.dart';
import '../../data/dao/supebase/time_training_dao_sb.dart';
import '../../data/dao/supebase/user_dao_sb.dart';
import '../../data/database/database_helper.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../model/user.dart';
import '../../viewmodel/current_user.dart';
import '../../viewmodel/settings_option/current_configure_timer.dart';
import '../components/menu_item.dart';
import '../components/password_field_row.dart';
import '../navigation/bottom_navigation.dart';
import 'app_styles.dart';
import 'internationalization.dart';

/// Clase **AlertUtil** que sirve para mostrar diversos tipos de alertas
/// en la aplicación, con soporte para internacionalización.
class AlertUtil {
  /// Icono para las penalizaciones
  static IconData iconPenalty = Icons.block;
  /// Objeto para el dao de los tiempos de resolucion
  static final timeTrainingDaoSb = TimeTrainingDaoSb();

  /// Muestra una alerta simple con título y contenido.
  ///
  /// Los parámetros [key] y [contentKey] se utilizan para obtener los textos
  /// localizados a través de claves. El parámetro [title] define el título de la alerta,
  /// y el parámetro [content] define el contenido que se muestra en el cuerpo.
  static void showAlert(String key, String contentKey, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${key}_label',
              '${key}_hint',
              key,
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${contentKey}_label',
              '${contentKey}_hint',
              contentKey,
              const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // SE CIERRA EL DIALOGO CUANDO PULSE "aceptar"
                  Navigator.of(context).pop();
                },
                child: Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  'accept_label',
                  'accept_hint',
                  'accept_label',
                  const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          );
        });
  } // METODO PARA MOSTRAR UNA ALERTA

  /// Muestra un formulario con un campo de texto para que el usuario ingrese información.
  ///
  /// El parámetro [titleKey] se usa para localizar el título del diálogo.
  /// [contentKey] se usa para localizar el contenido del diálogo, y [labelText]
  /// es el texto que se muestra en la etiqueta del campo de texto.
  /// Si el campo no está vacío, el valor ingresado se retorna.
  static Future<String?> showAlertForm(String titleKey, String contentKey,
      String labelText, BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    // MOSTRAR EL DIALOG
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Internationalization.internationalization
              .createLocalizedSemantics(
            context,
            '${titleKey}_label',
            '${titleKey}_hint',
            titleKey,
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // AJUSTE DE TAMAÑO DEL CONTENIDO
            children: [
              Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                '${contentKey}_label',
                '${contentKey}_hint',
                contentKey,
                const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: Internationalization.internationalization
                      .getLocalizations(context, labelText),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String newCubeName = controller.text.trim();
                if (newCubeName.isNotEmpty) {
                  Navigator.of(context).pop(newCubeName); // RETORNA EL NOMBRE
                } else {
                  Navigator.of(context).pop(); // SE ESTA VACIO, NO RETORNA NADA
                }
              },
              child: Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                'accept_label',
                'accept_hint',
                'accept_label',
                const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  } // METODO PARA MOSTRAR UNA ALERTA FORMULARIO

  /// Muestra un formulario para agregar un nuevo tiempo y scramble.
  ///
  /// Los parámetros [titleKey], [addScrambleKey] y [addTimeKey] se usan para localizar los textos
  /// del título y contenido del diálogo. [scrambleLabelText] y [timeLabelText] son los textos
  /// que se muestran como etiquetas en los campos de texto para ingresar el scramble y el tiempo.
  static Future<String?> showAlertFormAddTime(
      String titleKey,
      String addScrambleKey,
      String addTimeKey,
      String scrambleLabelText,
      String timeLabelText,
      BuildContext context) async {
    final TextEditingController controllerScramble = TextEditingController();
    final TextEditingController controllerTime = TextEditingController();
    final cubeTypeDaoSb = CubeTypeDaoSb();
    final sessionDaoSb = SessionDaoSb();
    final userDaoSb = UserDaoSb();

    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDaoSb.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    // BUSCAMOS EL TIPO DE CUBO QUE YA ESTABA ESTABLECIDO
    final tipoCuboEstablecido = context.read<CurrentCubeType>().cubeType;
    final currentSession = context.read<CurrentSession>().session;
    final cubo =
        await cubeTypeDaoSb.getCubeTypeByNameAndIdUser(tipoCuboEstablecido!.cubeName, idUser);

    // BUSCAMOS EL TIPO DE CUBO QUE TIENE ESA SESION
    SessionClass? sessionTipoActual = await sessionDaoSb.getSessionByUserCubeName(
        idUser, currentSession!.sessionName, cubo.idCube);

    // CUANDO SELECCIONE UNA SESION, SE BUSCA EL TIPO DE CUBO DE ESA SESION
    // GUARDAR LOS DATOS DEL TIPO DE CUBO EN EL ESTADO GLOBAL
    final currentCube = Provider.of<CurrentCubeType>(context, listen: false);

    // SE BUSCA ESE TIPO DE CUBO POR ESE ID
    CubeType? cubeType =
        await cubeTypeDaoSb.getCubeById(sessionTipoActual!.idCubeType);
    if (cubeType.idCube != -1) {
      // SE ACTUALIZA EL ESTADO GLOBAL
      currentCube.setCubeType(cubeType);
    } else {
      DatabaseHelper.logger
          .e("No se encontro el tipo de cubo: ${cubeType.toString()}");
    } // SE VERIFICA QUE SE HA RETORNADO EL TIPO DE CUBO CORRECTAMENTE

    // MOSTRAR EL DIALOG
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Internationalization.internationalization
              .createLocalizedSemantics(
            context,
            '${titleKey}_label',
            '${titleKey}_hint',
            '${titleKey}_label',
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // AJUSTE DE TAMAÑO DEL CONTENIDO
            children: [
              TextField(
                controller: controllerScramble,
                decoration: InputDecoration(
                  labelText: Internationalization.internationalization
                      .getLocalizations(context, scrambleLabelText),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controllerTime,
                decoration: InputDecoration(
                  labelText: Internationalization.internationalization
                      .getLocalizations(context, timeLabelText),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String scramble = controllerScramble.text.trim();
                String time = controllerTime.text.trim();
                if (scramble.isNotEmpty && time.isNotEmpty) {
                  TimeTraining timeTraining = TimeTraining(
                      idSession: sessionTipoActual.idSession,
                      scramble: scramble,
                      timeInSeconds: double.parse(time));

                  // INSERTAR EL TIEMPO
                  bool isInsert =
                      await timeTrainingDaoSb.insertNewTime(timeTraining);
                  if (isInsert) {
                    // SI SE INSERTO CORRECTAMENTE SE MUESTRA UN SNACKBAR
                    AlertUtil.showSnackBarInformation(
                        context, "add_time_successfully");
                  } else {
                    // SI SE INSERTO CORRECTAMENTE SE MUESTRA UN SNACKBAR
                    AlertUtil.showSnackBarInformation(
                        context, "add_time_error");
                  } // VERIFICAR SI SE INSERTA EL TIEMPO CORRECTAMENTE
                  Navigator.of(context).pop(); // CIERRA EL DIALOG
                } else {
                  Navigator.of(context).pop(); // SE ESTA VACIO, NO RETORNA NADA
                }
              },
              child: Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                'accept_label',
                'accept_hint',
                'accept_label',
                const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  } // METODO PARA MOSTRAR UNA ALERTA FORMULARIO PARA AÑADIR UN TIEMPO

  /// Método para mostrar un cuadro de diálogo que permite confirmar la
  /// eliminación de una sesión o cubo.
  ///
  /// Parametros:
  /// `context`: El contexto de la aplicación para poder mostrar el diálogo.
  /// `key`: La clave que se usa para obtener las traducciones del título de la alerta.
  /// `contentKey`: La clave para obtener el contenido de la alerta.
  /// `delete`: Función que se ejecutará si el usuario confirma la eliminación.
  static showDeleteSessionOrCube(
      BuildContext context, String key, String contentKey, Function delete) {
    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // TITULO DE LA ALERTA
            title: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${key}_label',
              '${key}_hint',
              key,
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${contentKey}_label',
              '${contentKey}_hint',
              contentKey,
              const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              // BOTONES PARA CANCELAR O DARLE OK
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  'cancel_label',
                  'cancel_hint',
                  'cancel_label',
                  const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  delete(); // FUNCION PARA ELIMINAR SI PULSA OK
                },
                child: Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  'accept_label',
                  'accept_hint',
                  'accept_label',
                  const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          );
        });
  } // METODO PARA MOSTRAR UNA ALERTA DE SI DESEA ELIMINAR LA SESION O EL TIPO DE CUBO

  /// Método para mostrar los detalles de un tiempo seleccionado.
  ///
  /// Este método permite visualizar y gestionar un tiempo registrado, mostrando su información
  /// y permitiendo aplicar penalizaciones, eliminar el tiempo o copiar el scramble asociado.
  ///
  /// Parametros:
  /// `context`: El contexto de la aplicación para poder mostrar el diálogo.
  /// `deleteTime`: Función que se ejecutará si el usuario confirma la eliminación del tiempo.
  /// `timeTraining`: Objeto que contiene los detalles del tiempo.
  static showDetailsTime(BuildContext context,
      Future<void> Function() deleteTime, TimeTraining timeTraining) async {
    // ATRIBUTO PARA SABER SI ESTA PRESIONADO EL SCRAMBLE O LOS COMMENTS
    var isTextPressed = true;

    final currentTime = Provider.of<CurrentTime>(context, listen: false);
    currentTime.setResetTimeTraining();
    currentTime.setTimeTraining(timeTraining); // SE ACTUALIZA EL ESTADO GLOBAL

    // REESTABLECER VALORES DE PENALIZACION
    currentTime.isPlusTwoChoose = false;
    currentTime.isDnfChoose = false;

    int idTime = await timeTrainingDaoSb.getIdByTime(
        currentTime.timeTraining!.scramble,
        currentTime.timeTraining!.idSession);

    if (idTime == -1) {
      AlertUtil.showSnackBarError(context, "time_saved_error");
      return;
    } // VALIDAR QUE EL IDTIME NO DE ERROR

    // SE GUARA EL TIEMPO ORIGINAL DEPENDIENDO DE SI TENIA UN +2 O NO DE PENALIZACION
    final timeInSecondsOld = currentTime.timeTraining!.penalty == "+2"
        ? timeTraining.timeInSeconds - 2
        : timeTraining.timeInSeconds;

    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              setState(() {
                // SEGUN LA PENALIZACION DEL TIEMPO, SE PONE UN ICONO
                if (currentTime.timeTraining!.penalty == "+2") {
                  iconPenalty = Icons.timer;
                  currentTime.isDnfChoose = false;
                  currentTime.isPlusTwoChoose = true;
                } else if (currentTime.timeTraining!.penalty == "DNF") {
                  iconPenalty = Icons.close;
                  currentTime.isDnfChoose = true;
                  currentTime.isPlusTwoChoose = false;
                } else if (currentTime.timeTraining!.penalty == "none") {
                  iconPenalty = Icons.block;
                } // INICIALIZAR EL ICONO
              });
              return AlertDialog(
                // SE REDUCE EL PADDING DEL TITULO Y DEL CONTENIDO
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),

                backgroundColor: AppColors.lightVioletColor,
                // TITULO DE LA ALERTA
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        // BOTON PARA EL DROPDOWN
                        customButton: IconClass.iconMaker(
                            context, iconPenalty, "add_penalty"),
                        // ITEMS DEL DROPDOWN
                        items: [
                          ...MenuItems.items.map(
                            (item) => DropdownMenuItem<MenuItem>(
                              value: item,
                              // CONSTRUYE CADA ITEM DEL MENU
                              child: MenuItems.buildItem(item),
                            ),
                          ),
                        ],

                        // CUANDO SE SELECCIONA UNA OPCION, SE ACTUALIZA EL ICONO Y LA PENALIZACION
                        onChanged: (value) async {
                          setState(() {
                            iconPenalty = value!.icon;

                            // ASIGNAR LA PENALIZACION SEGUN EL ICONO SELECCIONADO
                            if (iconPenalty == Icons.close) {
                              // PENALIZACION DNF (NO FINALIZADO)
                              currentTime.setPenalty("DNF", !currentTime.isDnfChoose);
                              currentTime.isDnfChoose = !currentTime.isDnfChoose;
                              currentTime.isPlusTwoChoose = false;
                            } else if (iconPenalty == Icons.timer) {
                              // PENALIZACION +2 SEGUNDOS
                              currentTime.setPenalty("+2", !currentTime.isPlusTwoChoose);
                              currentTime.isDnfChoose = false;
                              currentTime.isPlusTwoChoose = !currentTime.isPlusTwoChoose;
                            } else if (iconPenalty == Icons.block) {
                              // SIN PENALIZACION, RESTA LOS 2 SEGUNDOS SI ESTABA EN +2
                              if (currentTime.timeTraining!.penalty == "+2") {
                                currentTime.timeTraining!.timeInSeconds = timeInSecondsOld;
                              }
                              currentTime.setPenalty("none", true);
                            }
                          });

                          // ACTUALIZAR EL ESTADO GLOBAL
                          currentTime.updateCurrentTime(context);

                          // GUARDAR CAMBIOS EN LA BASE DE DATOS
                          if (await timeTrainingDaoSb.updateTime(
                              idTime, currentTime.timeTraining) == false) {
                            // MOSTRAR ERROR SI FALLA LA ACTUALIZACION
                            AlertUtil.showSnackBarError(
                                context, "time_saved_error");
                            return;
                          }
                        },

                        dropdownStyleData: DropdownStyleData(
                          width: 160, // ANCHO DEL MENU DESPLEGABLE
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            // BORDES REDONDEADOS
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.imagenBg, // COLOR DE FONDO
                          ),
                          offset: const Offset(0, 8), // DESPLAZAMIENTO DEL MENU
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          customHeights: [
                            // ALTURA DE CADA ITEM
                            ...List<double>.filled(MenuItems.items.length, 48),
                          ],
                          // ESPACIADO INTERNO
                          padding: const EdgeInsets.only(left: 16, right: 16),
                        ),
                      ),
                    ),
                    Text(
                      // SI LA PENALIZACION ES 'DNF' SE MUESTRA EN VEZ DEL TIEMPO
                      currentTime.timeTraining!.penalty == "DNF"
                          ? currentTime.timeTraining!.penalty.toString()
                          : currentTime.timeTraining!.timeInSeconds.toString(),
                      style: AppStyles.darkPurpleAndBold(30),
                    ),

                    IconClass.iconButton(context, () async {
                      await deleteTime();
                    }, "delete_time", Icons.delete)
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min, // QUE OCUPE EL MINIMO
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconClass.iconButton(
                            context, () {}, "date", Icons.calendar_month),
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          style: AppStyles.darkPurple(16),
                        )
                      ],
                    ),

                    // LINEA DIVISORIA ENTRE LA FECHA Y EL CONTENIDO EN SI
                    const Divider(
                      height: 10,
                      thickness: 1.3,
                      indent: 10,
                      endIndent: 10,
                      color: AppColors.darkPurpleColor,
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Card(
                          // SEGUN SI ESTA PRESIONADO O NO, SE TORNA DE UN COLOR U OTRO
                          color: isTextPressed
                              ? AppColors.downLinearColor
                              : AppColors.purpleButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ), // RADIO DEL CARD
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                // SI EL SCRAMBLE ES SELECCIONADO, SE PONE A TRUE
                                isTextPressed = true;
                              });
                            },
                            child: Text(
                              "Scramble",
                              style: AppStyles.darkPurpleAndBold(13),
                            ),
                          ),
                        ),
                        Card(
                          // SI EL SCRAMBLE ESTA PRESIONADO SE CAMBIA DE COLOR EL CARD
                          color: isTextPressed
                              ? AppColors.purpleButton
                              : AppColors.downLinearColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ), // RADIO DEL CARD
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                // CUANDO PRESIONE LOS COMENTAIOS, SE PONE A FALSE
                                isTextPressed = false;
                              });
                            },
                            child: Text(
                              Internationalization.internationalization.getLocalizations(context, "comments"),
                              style: AppStyles.darkPurpleAndBold(13),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            // SI EL SCRAMBLE ESTA PRESIONADO SE MUESTRA EL SCRAMBLE
                            // Y SI NO LOS COMENTARIOS
                            isTextPressed
                                ? timeTraining.scramble
                                : (timeTraining.comments ?? Internationalization.internationalization.getLocalizations(context, "no_comments")),
                            style: const TextStyle(fontSize: 14),
                            // HACE UN SALTO DE LINEA SI ES LARGO
                            softWrap: true,
                            // SI TIENE MUCHO OVERFLOW, TRUNCA EL SCRAMBLE Y PONE PUNTOS SUSPENSIVOS
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        IconClass.iconButton(context, () async {
                          await Clipboard.setData(
                              ClipboardData(text: timeTraining.scramble));
                          // MUESTRA MENSAJE DE QUE SE COPIO CORRECTAMENTE
                          showSnackBarInformation(
                              context, "copied_successfully");
                        }, "copy_scramble", Icons.copy)
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  } // METODO PARA MOSTRAR DETALLES DEL TIEMPO SELECCIONADO

  /// Método para mostrar un cuadro de diálogo para cambiar el idioma de la aplicación.
  ///
  /// Parámetros:
  /// `context`: El contexto de la aplicación para mostrar el diálogo.
  /// `key`: Clave para obtener la traducción de la interfaz del diálogo.
  static showChangeLanguague(BuildContext context) {
    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.lightVioletColor,
            // TITULO DE LA ALERTA
            title: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              "select_languages",
              "select_languages",
              "select_languages",
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Column(
              // NOS ASEGURAMOS QUE EL TAMAÑO SEA EL MINIMO
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<CurrentLanguage>().cambiarIdioma('es');
                  },
                  child: Internationalization.internationalization
                      .createLocalizedSemantics(
                    context,
                    "spanish",
                    "spanish_hint",
                    "spanish",
                    const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<CurrentLanguage>().cambiarIdioma('en');
                  },
                  child: Internationalization.internationalization
                      .createLocalizedSemantics(
                    context,
                    "english",
                    "english_hint",
                    "english",
                    const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  } // ALERTA PARA ESTABLECER EL IDOMA

  /// Método para mostrar una alerta cuando el usuario intente salir del perfil sin guardar los cambios.
  ///
  /// Parámetros:
  /// - `context`: Contexto de la aplicación donde se mostrará el diálogo.
  /// - `key`: Clave para la localización del título del diálogo.
  /// - `contentKey`: Clave para la localización del contenido del diálogo.
  static showExitConfirmationDialog(
      BuildContext context, String key, String contentKey) {
    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // TITULO DE LA ALERTA
            title: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${key}_label',
              '${key}_hint',
              key,
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${contentKey}_label',
              '${contentKey}_hint',
              contentKey,
              const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              // BOTONES PARA CANCELAR O DARLE OK
              TextButton(
                onPressed: () {
                  // CIERRA LA ALERTA
                  Navigator.pop(context);
                },
                child: Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  'cancel_label',
                  'cancel_hint',
                  'cancel_label',
                  const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  // CUANDO ACEPTA SIN GUARDAR LOS CAMBIOS, SE VA AL TIMER
                  ChangeScreen.changeScreen(const BottomNavigation(), context);
                },
                child: Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  'accept_label',
                  'accept_hint',
                  'accept_label',
                  const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          );
        });
  } // METODO PARA MOSTRAR UNA ALERTA CUANDO SALGA DEL PROFILE SIN GUARDAR

  /// Método para mostrar una alerta de confirmación con la contraseña antigua.
  ///
  /// Este método muestra un `AlertDialog` en el que el usuario debe ingresar
  /// su contraseña actual para confirmar una acción (como cambiar
  /// la contraseña).
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación donde se mostrará el diálogo.
  /// - `key`: Clave de localización para personalizar el mensaje del diálogo.
  /// - `oldPass`: Clave de localización para el campo de la contraseña actual.
  /// - `currentUser`: Objeto del usuario actual para validar la contraseña.
  ///
  /// Devuelve `true` si la contraseña ingresada es correcta, `false` si el usuario cancela
  /// la acción, y `null` si ocurre un error.
  ///
  /// Validaciones:
  /// - Se valida que la contraseña ingresada cumpla con los requisitos y
  ///   coincida con la actual.
  /// - Si la validación es exitosa, se redirige a la pantalla principal.
  static Future<bool?> showConfirmWithOldPass(
      BuildContext context, String key, String oldPass, UserClass currentUser) {
    final oldPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.lightVioletColor,
            title: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${key}_label',
              '${key}_hint',
              '${key}_label',
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Internationalization.internationalization
                .createLocalizedSemantics(
              context,
              '${oldPass}_form_label',
              '${oldPass}_form_hint',
              '${oldPass}_form_hint',
              const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              // CAMPO PARA INTRODUCIR SU VIEJA CONTRASEÑA
              Form(
                key: formKey,
                child: PasswordFieldForm(
                  icon: IconClass.iconMaker(context, Icons.lock, "password"),
                  labelText: Internationalization.internationalization
                      .getLocalizations(context, '${oldPass}_form_label'),
                  hintText: Internationalization.internationalization
                      .getLocalizations(context, '${oldPass}_form_label'),
                  controller: oldPasswordController,
                  validator: (value) => Validator.validatePassword(
                      value, true, false, currentUser, context),
                  labelSemantics: Internationalization.internationalization
                      .getLocalizations(context, '${oldPass}_form_label'),
                  hintSemantics: Internationalization.internationalization
                      .getLocalizations(context, '${oldPass}_form_label'),
                  borderSize: 15,
                  colorBox: AppColors.imagenBg,
                  passwordOnSaved: (String? value) {},
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // BOTONES PARA CANCELAR O DARLE OK
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // CIERRA LA ALERTA Y RETORNA FALSE
                      Navigator.pop(context, false);
                    },
                    child: Internationalization.internationalization
                        .createLocalizedSemantics(
                      context,
                      'cancel_label',
                      'cancel_hint',
                      'cancel_label',
                      const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // CAMBIAR DE PESTAÑA
                        Navigator.pop(context, true);

                        ChangeScreen.changeScreen(
                            const BottomNavigation(), context);
                      } // VALIDAR SI LOS DATOS ESTAN CORRECTOS
                    },
                    child: Internationalization.internationalization
                        .createLocalizedSemantics(
                      context,
                      'accept_label',
                      'accept_hint',
                      'accept_label',
                      const TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  } // ALERTA PARA PONER LA ANTIGUA CONTRASEÑA

  /// Método para mostrar un diálogo para agregar o editar un comentario asociado a un tiempo registrado.
  ///
  /// Este método muestra un `AlertDialog` en el que el usuario puede
  /// escribir o modificar un comentario relacionado con un tiempo. Si el usuario
  /// ya había registrado un comentario, se muestra automáticamente en el campo de texto.
  ///
  /// Parámetros:
  /// - `context`: Contexto de la aplicación donde se mostrará el diálogo.
  /// - `key`: Clave de localización para personalizar el mensaje del diálogo.
  /// - `addComment`: Función asíncrona que se ejecuta al confirmar, la cual guarda el comentario ingresado.
  ///
  /// Devuelve `true` si el usuario confirma y el comentario es válido, `false` si el usuario cancela
  /// la acción, y `null` si ocurre un error o un cierre.
  ///
  /// Validaciones:
  /// - Se obtiene el `idTime` según `scramble` y la sesión actual.
  /// - Si el `idTime` no es válido (`-1`), se muestra un mensaje de error y se cancela la operación.
  /// - Se recupera el comentario previo, si existe, y se muestra en el campo de texto.
  /// - Se valida que el campo de texto no esté vacío antes de confirmar.
  static Future<bool?> showCommentsTime(BuildContext context, String key,
      Future<void> Function(String comment) addComment) async {
    final commentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final currentTime = context.read<CurrentTime>();

    // CONSEGUIR EL ID DEL TIEMPO ACTUAL
    int idTime = await timeTrainingDaoSb.getIdByTime(
        currentTime.timeTraining!.scramble,
        currentTime.timeTraining!.idSession);

    if (idTime == -1) {
      AlertUtil.showSnackBarError(context, "time_saved_error");
      return false;
    } // VALIDAR QUE EL IDTIME NO DE ERROR

    // CONSEGUIR EL OBJETO A PARTIR DEL ID DEL TIEMPO
    TimeTraining? timeTraining = await timeTrainingDaoSb.getTimeById(idTime);
    if (timeTraining != null) {
      // SI YA HAY UN COMENTARIO SE SETTEA
      commentController.text = timeTraining.comments!;
    } else {
      // SI ES NULO, MUESTRA UN MENSAJE DE ERROR
      //AlertUtil.showSnackBarError(context, "time_error");
    } // VALIDAR SI ES NULO O NO EL TIEMPO

    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.lightVioletColor,
            title: Internationalization.internationalization
                .createLocalizedSemantics(
              context, key, key, key,
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Internationalization.internationalization
                .createLocalizedSemantics(
              context, '${key}_content', '${key}_content', '${key}_content',
              const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              // CAMPO PARA INTRODUCIR EL COMENTARIO
              Form(
                  key: formKey,
                  child: TextFormField(
                    controller: commentController,
                    // SE EXPANDE EL CAMPO INFINITO
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'No se pueden campos vacios';
                      }
                      return null;
                    },
                  )),

              const SizedBox(
                height: 10,
              ),

              // BOTONES PARA CANCELAR O DARLE OK
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // CIERRA LA ALERTA Y RETORNA FALSE
                      Navigator.pop(context, false);
                    },
                    child: Internationalization.internationalization
                        .createLocalizedSemantics(
                      context, 'cancel_label', 'cancel_hint', 'cancel_label',
                      const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context, true);
                        addComment(commentController.text);
                      } // VALIDAR SI LOS DATOS ESTAN CORRECTOS
                    },
                    child: Internationalization.internationalization
                        .createLocalizedSemantics(
                      context, 'accept_label', 'accept_hint', 'accept_label',
                      const TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  /// Metodo para mostrar un diálogo que permita que el usuario introduzca el tiempo de inspección deseado.
  ///
  /// Este diálogo permite al usuario ingresar un valor personalizado para el tiempo de inspección
  /// (en segundos) que se usará antes de iniciar el cronómetro. Por defecto, el campo de texto
  /// se rellena con el valor actualmente configurado que tiene el usuario.
  ///
  /// Parámetros:
  /// - `titleKey`: Clave de localización para el título y textos del diálogo.
  /// - `context`: Contexto de la aplicación donde se mostrará el diálogo.
  ///
  /// Comportamiento:
  /// - Valida que el campo no esté vacío, contenga solo números enteros y esté entre 1 y 59.
  /// - El botón "Predeterminado" restablece el tiempo a 15 segundos.
  /// - El botón "Aceptar" guarda el nuevo valor ingresado.
  /// - El botón "Cancelar" cierra el diálogo sin realizar cambios.
  static Future<String?> addSecondsTimeOfInspectionForm(
      String titleKey, BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();
    final currentSecondsTime = context.read<CurrentConfigurationTimer>();
    // EN EL TEXTO DEL CAMPOS DEL FORMULARIO SE ESTABLECE LOS SEGUNDO DE INSPECCION YA
    // CONFIGURADOS
    controller.text = currentSecondsTime.configurationTimer.inspectionSeconds.toString();

    // MOSTRAR EL DIALOG
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Internationalization.internationalization
              .createLocalizedSemantics(
            context,
            '${titleKey}_title',
            '${titleKey}_description',
            '${titleKey}_title',
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // AJUSTE DE TAMAÑO DEL CONTENIDO
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: Internationalization.internationalization
                        .getLocalizations(context, '${titleKey}_form'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return Internationalization.internationalization.getLocalizations(context, "inspection_field_required");
                    } // SI ESTA VACIO

                    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                      return Internationalization.internationalization.getLocalizations(context, "inspection_only_numbers");
                    } // SI CONTIENE NUMEROS

                    int seconds = int.parse(value.trim());

                    if (seconds < 1 || seconds > 59) {
                      return Internationalization.internationalization.getLocalizations(context, "inspection_range_1_59");
                    } // SI INTRODUCE UN NUMERO MENOR QUE 1 O MAYOR QUE 59

                    return null;
                  },
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // BOTOTN DE PREDETERMINADO
                TextButton(
                  onPressed: () {
                    // EL PREDETERMINADO SON 15 SEGUNDOS
                    currentSecondsTime.changeValue(inspectionSeconds: 15);
                    Navigator.of(context).pop();
                  },
                  child: Internationalization.internationalization
                      .localizedTextOnlyKey(
                    context,
                    'time_default',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),

                // BOTON CANCELAR
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: Internationalization.internationalization
                      .createLocalizedSemantics(
                    context,
                    'cancel_label',
                    'cancel_hint',
                    'cancel_label',
                    const TextStyle(
                        fontSize: 16, color: AppColors.deleteAccount),
                  ),
                ),

                // BOTON ACEPTAR
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      int seconds = int.parse(controller.text.trim());
                      currentSecondsTime.changeValue(
                          inspectionSeconds: seconds);
                      // CIERRA EL DIALOGO
                      Navigator.of(context).pop();
                    }
                  },
                  child: Internationalization.internationalization
                      .createLocalizedSemantics(
                    context,
                    'accept_label',
                    'accept_hint',
                    'accept_label',
                    const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  } // METODO PARA MOSTRAR UNA ALERTA FORMULARIO PARA QUE EL USUARIO


  /// Método para mostrar un diálogo de alerta simple con un botón personalizado
  /// y uno de cancelación.
  ///
  /// Este dialogo permite mostrar un título, una descripción y dos botones:
  /// uno para cancelar y otro para ejecutar una función personalizada pasada como parámetro.
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación donde se mostrará el diálogo.
  /// - `key`: Clave de localización para el título del diálogo.
  /// - `contentKey`: Clave de localización para el contenido del diálogo.
  /// - `functionKey`: Clave de localización para el botón de acción.
  /// - `function`: Función que se ejecutará al pulsar el botón personalizado.
  static void showAlertSimple(BuildContext context, String key,
      String contentKey, String functionKey, Function function) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
            Internationalization.internationalization.localizedTextOnlyKey(
              context,
              key,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content:
            Internationalization.internationalization.localizedTextOnlyKey(
              context,
              contentKey,
              style: const TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              // BOTONES PARA CANCELAR O PARA ACEPTAR/ABRIR CONFIGURACION
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: Internationalization.internationalization
                    .createLocalizedSemantics(
                  context,
                  'cancel_label',
                  'cancel_hint',
                  'cancel_label',
                  const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  function;
                },
                child: Internationalization.internationalization
                    .localizedTextOnlyKey(
                  context,
                  functionKey,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          );
        });
  } // METODO PARA MOSTRAR UNA ALERTA CON TITULO, CONTENIDO, CON BOTONES DE CANCELAR Y OTRO

  /// Método para mostrar una alerta de confirmación para salir de la aplicación.
  ///
  /// Este diálogo muestra un título, un mensaje y una imagen junto con dos botones:
  /// uno para cancelar (cerrando el diálogo) y otro para salir de la app.
  ///
  /// Está diseñado especificamente para prevenir salidas accidentales, como
  /// cuando el usuario está en la pantalla principal y podría salir sin querer al login..
  ///
  /// Parámetros:
  /// - `context`: El contexto de la aplicación donde se mostrará el diálogo.
  static void showExitAlert(BuildContext context) {
    showDialog<void>(
      context: context,
      // EVITA QUE SE CIERRE AL TOCAR FUERA DEL DIALOGO
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Internationalization.internationalization
              .getLocalizations(context, "dialog_exit_app_title")),
          content: SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      Internationalization.internationalization
                          .getLocalizations(context, "dialog_exit_app_message"),
                      style: const TextStyle(fontSize: 15),
                      // SI EL TEXTO ES MUY LARGO, SE PONE PUNTOS SUSPENSIVOS
                      // Y SE MUESTRA HASTA 4 LINEAS
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 200,
                  child: Image.asset(
                    "assets/cubix/cubix_sad.png",
                    // AJUSTA LA IMAGEN COMPLETA DENTRO DEL CONTENEDOR SIN RECORTARLA
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // BOTONES PARA CANCELAR O DARLE OK
            TextButton(
              onPressed: () {
                // CIERRA LA ALERTA
                Navigator.pop(context);
              },
              child: Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                'cancel_label',
                'cancel_hint',
                'cancel_label',
                const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                // SI ACEPTA CIERRA LA APP
                SystemNavigator.pop();
              },
              child: Internationalization.internationalization
                  .createLocalizedSemantics(
                context,
                'accept_label',
                'accept_hint',
                'accept_label',
                const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Método para mostrar un Snackbar con un mensaje personalizado.
  ///
  /// Parámetros:
  /// `context`: El contexto de la aplicación para mostrar el Snackbar.
  /// `icon`: El icono que se mostrará junto al mensaje.
  /// `message`: El mensaje que se mostrará en el Snackbar.
  /// `color`: El color de fondo del Snackbar.
  static showSnackBar(
      BuildContext context, IconData icon, String message, Color color) {
    // CREAMOS EL SNACKBAR
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color, // COLOR DE FONDO
      action: SnackBarAction(
        label: Internationalization.internationalization.getLocalizations(
            context, "accept_label"), // TEXTO DEL BOTON DE ACCION
        textColor: Colors.yellow, // COLOR DEL TEXTO DEL BOTON
        onPressed: () {
          // SE CIERRA EL SNACKBAR CUANDO PULSE "Accept"
        },
      ),
      content: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          // PARA CONTROLAR EL OVERFLOW QUE CAUSA EL TEXTO, SE USA EL WIDGET FLEXIBLE
          Flexible(
            child: Text(
              message,
              overflow: TextOverflow.ellipsis, // CORTA EL TEXTO CON "..."
              maxLines: 5, // LIMITA EL TEXTO A 5 LINEAS SI ES NECESARIO
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ), // EL TEXTO QUE SE MOSTRARA EN EL SNACKBAR
    );

    // MOSTRAMOS EL SNACKBAR
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // SE CIERRA EL SNACKBAR PASADOS LOS 5 SEGUNDOS
    Future.delayed(const Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  } // MOSTRAR UN SNACKBAR

  /// Metodo para mostrar un SnackBar personalizado con una duracion determinada.
  ///
  /// Este método permite mostrar un mensaje con localizacion en la parte inferior de la pantalla
  /// durante una cantidad de segundos especificada.
  ///
  /// Parametros:
  /// - `context`: El contexto de la aplicacion donde se mostrará el SnackBar.
  /// - `seconds`: La duración en segundos que el SnackBar permanecera visible.
  /// - `keyTitle`: Clave de localizacion para obtener el texto del mensaje.
  static showSnackBarWithDuration (BuildContext context, int seconds, String keyTitle){
    final message = Internationalization.internationalization
        .getLocalizations(context, keyTitle);

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  /// Método para mostrar un Snackbar de error.
  ///
  /// Parametros:
  /// `context`: El contexto de la aplicación.
  /// `messageKey`: La clave para obtener el mensaje de error.
  static showSnackBarError(BuildContext context, String messageKey) {
    final message = Internationalization.internationalization
        .getLocalizations(context, messageKey);
    showSnackBar(context, Icons.error, message, Colors.redAccent);
  } // SNACKBAR PARA MOSTRAR UN ERROR

  /// Método para mostrar un Snackbar con información.
  ///
  /// Parámetros:
  /// `context`: El contexto de la aplicación.
  /// `messageKey`: La clave para obtener el mensaje informativo.
  static showSnackBarInformation(BuildContext context, String messageKey) {
    final message = Internationalization.internationalization
        .getLocalizations(context, messageKey);
    showSnackBar(context, Icons.info, message, Colors.green);
  } // SNACKBAR PARA MOSTRAR UNA INFORMACION
}