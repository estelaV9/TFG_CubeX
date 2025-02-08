import 'package:esteladevega_tfg_cubex/data/dao/cubetype_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/session_dao.dart';
import 'package:esteladevega_tfg_cubex/data/dao/time_training_dao.dart';
import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/model/time_training.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_language.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/dao/user_dao.dart';
import '../../data/database/database_helper.dart';
import '../../model/cubetype.dart';
import '../../model/session.dart';
import '../../viewmodel/current_user.dart';
import 'internationalization.dart';

/// Clase **AlertUtil** que sirve para mostrar diversos tipos de alertas
/// en la aplicación, con soporte para internacionalización.
class AlertUtil {
  /// Muestra una alerta simple con título y contenido.
  ///
  /// Los parámetros [key] y [contentKey] se utilizan para obtener los textos
  /// localizados a través de claves. El parámetro [title] define el título de la alerta,
  /// y el parámetro [content] define el contenido que se muestra en el cuerpo.
  static void showAlert(String key, String contentKey, String title,
      String content, BuildContext context) {
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
    final cubeTypeDao = CubeTypeDao();
    final sessionDao = SessionDao();
    final userDao = UserDao();
    final timeTrainingDao = TimeTrainingDao();

    // OBTENER EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    // OBTENER EL ID DEL USUARIO
    int idUser = await userDao.getIdUserFromName(currentUser!.username);
    if (idUser == -1) {
      DatabaseHelper.logger.e("Error al obtener el ID del usuario.");
    } // VERIFICAR QUE SI ESTA BIEN EL ID DEL USUARIO

    // BUSCAMOS EL TIPO DE CUBO QUE YA ESTABA ESTABLECIDO
    final tipoCuboEstablecido = context.read<CurrentCubeType>().cubeType;
    final currentSession = context.read<CurrentSession>().session;
    final cubo =
        await cubeTypeDao.cubeTypeDefault(tipoCuboEstablecido!.cubeName);

    // BUSCAMOS EL TIPO DE CUBO QUE TIENE ESA SESION
    Session? sessionTipoActual = await sessionDao.getSessionByUserCubeName(
        idUser, currentSession!.sessionName, cubo.idCube);

    // CUANDO SELECCIONE UNA SESION, SE BUSCA EL TIPO DE CUBO DE ESA SESION
    // GUARDAR LOS DATOS DEL TIPO DE CUBO EN EL ESTADO GLOBAL
    final currentCube = Provider.of<CurrentCubeType>(context, listen: false);

    // SE BUSCA ESE TIPO DE CUBO POR ESE ID
    CubeType? cubeType =
        await cubeTypeDao.getCubeById(sessionTipoActual!.idCubeType);
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
              SizedBox(
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
              onPressed: () async{
                String scramble = controllerScramble.text.trim();
                String time = controllerTime.text.trim();
                if (scramble.isNotEmpty && time.isNotEmpty) {
                  TimeTraining timeTraining = TimeTraining(
                      idSession: sessionTipoActual.idSession,
                      scramble: scramble,
                      timeInSeconds: double.parse(time));

                  // INSERTAR EL TIEMPO
                  bool isInsert = await timeTrainingDao.insertNewTime(timeTraining);
                  if(isInsert){
                    // SI SE INSERTO CORRECTAMENTE SE MUESTRA UN SNACKBAR
                    AlertUtil.showSnackBarInformation(context, "add_time_succesfully");
                  } else {
                    // SI SE INSERTO CORRECTAMENTE SE MUESTRA UN SNACKBAR
                    AlertUtil.showSnackBarInformation(context, "add_time_error");
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
  /// Parametros:
  /// `context`: El contexto de la aplicación para poder mostrar el diálogo.
  /// `deleteTime`: Función que se ejecutará si el usuario confirma la eliminación del tiempo.
  /// `timeTraining`: Objeto que contiene los detalles del tiempo.
  static showDetailsTime(BuildContext context,
      Future<void> Function() deleteTime, TimeTraining timeTraining) {
    var colorPressed = AppColors.purpleButton;
    var isTextPressed = false;
    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
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
                IconClass.iconButton(
                    context, () {}, "add_penalty", Icons.block),
                Text(
                  timeTraining.timeInSeconds.toString(),
                  style: const TextStyle(
                    color: AppColors.darkPurpleColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
                      style: const TextStyle(
                          color: AppColors.darkPurpleColor, fontSize: 16),
                    )
                  ],
                ),

                // LINEA DIVISORIA ENTRE EL LA FECHA Y EL CONTENIDO EN SI
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
                    GestureDetector(
                      onTap: () {
                        isTextPressed = !isTextPressed;
                      },
                      child: Container(
                        width: 95,
                        height: 30,
                        color: isTextPressed
                            ? AppColors.purpleButton
                            : Colors.transparent,
                        child: Card(
                          color: isTextPressed
                              ? AppColors.purpleButton
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ), // RADIO DEL CARD
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Scramble",
                              style: TextStyle(
                                  color: AppColors.darkPurpleColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ), // RADIO DEL CARD
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Comments",
                            style: TextStyle(
                                color: AppColors.darkPurpleColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 190,
                      child: Text(
                        timeTraining.scramble,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconClass.iconButton(context, () async {
                      await Clipboard.setData(
                          ClipboardData(text: timeTraining.scramble));
                      // MUESTRA MENSAJE DE QUE SE COPIO CORRECTAMENTE
                      showSnackBarInformation(context, "copied_successfully");
                    }, "copy_scramble", Icons.copy)
                  ],
                )
              ],
            ),
          );
        });
  } // METODO PARA MOSTRAR DETALLES DEL TIEMPO SELECCIONADO

  /// Método para mostrar un cuadro de diálogo para cambiar el idioma de la aplicación.
  ///
  /// Parámetros:
  /// `context`: El contexto de la aplicación para mostrar el diálogo.
  /// `key`: Clave para obtener la traducción de la interfaz del diálogo.
  static showChangeLanguague(
    BuildContext context,
    String key,
  ) {
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