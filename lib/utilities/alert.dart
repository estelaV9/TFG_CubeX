import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/model/time_training.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_language.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'internationalization.dart';

class AlertUtil {
  static void showAlert(String key, String contentKey, String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Internationalization.internationalization.createLocalizedSemantics(
              context,
              '${key}_label',
              '${key}_hint',
              key,
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Internationalization.internationalization.createLocalizedSemantics(
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
                child: Internationalization.internationalization.createLocalizedSemantics(
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

  static Future<String?> showAlertForm(String titleKey, String contentKey,
      String labelText, BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    // MOSTRAR EL DIALOG
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Internationalization.internationalization.createLocalizedSemantics(
            context,
            '${titleKey}_label',
            '${titleKey}_hint',
            titleKey,
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // AJUSTE DE TAMAÑO DEL CONTENIDO
            children: [
              Internationalization.internationalization.createLocalizedSemantics(
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
                  labelText: Internationalization.internationalization.getLocalizations(context, labelText),
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
              child: Internationalization.internationalization.createLocalizedSemantics(
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

  static showDeleteSessionOrCube(BuildContext context, String key, String contentKey,
       Function delete) {
    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // TITULO DE LA ALERTA
            title: Internationalization.internationalization.createLocalizedSemantics(
              context,
              '${key}_label',
              '${key}_hint',
              key,
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Internationalization.internationalization.createLocalizedSemantics(
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
                child:Internationalization.internationalization.createLocalizedSemantics(
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
                child: Internationalization.internationalization.createLocalizedSemantics(
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

  static showDetailsTime(BuildContext context, TimeTraining timeTraining) {
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
                IconClass.iconButton(context, (){}, "add_penalty", Icons.block),

                Text(
                  timeTraining.timeInSeconds.toString(),
                  style: const TextStyle(
                    color: AppColors.darkPurpleColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconClass.iconButton(context, (){}, "delete_time", Icons.delete)
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min, // QUE OCUPE EL MINIMO
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconClass.iconButton(context, (){}, "date", Icons.calendar_month),
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
                    IconClass.iconButton(context,() async {
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


  static showChangeLanguague(BuildContext context, String key,) {
    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.lightVioletColor,
            // TITULO DE LA ALERTA
            title: Text("Select a language:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Column(
              // NOS ASEGURAMOS QUE EL TAMAÑO SEA EL MINIMO
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: (){
                  context.read<CurrentLanguage>().cambiarIdioma('es');
                }, child: Text("Spanish")),
                TextButton(onPressed: (){
                  context.read<CurrentLanguage>().cambiarIdioma('en');
                }, child: Text("English")),
              ],
            ),
          );
        });
  } // ALERTA PARA ESTABLECER EL IDOMA

  static showSnackBar(
      BuildContext context, IconData icon, String message, Color color) {
    // CREAMOS EL SNACKBAR
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color, // COLOR DE FONDO
      action: SnackBarAction(
        label: Internationalization.internationalization.getLocalizations(context, "accept_label"), // TEXTO DEL BOTON DE ACCION
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

  static showSnackBarError(BuildContext context, String messageKey) {
    final message = Internationalization.internationalization.getLocalizations(context, messageKey);
    showSnackBar(context, Icons.error, message, Colors.redAccent);
  } // SNACKBAR PARA MOSTRAR UN ERROR

  static showSnackBarInformation(BuildContext context, String messageKey) {
    final message = Internationalization.internationalization.getLocalizations(context, messageKey);
    showSnackBar(context, Icons.info, message, Colors.green);
  } // SNACKBAR PARA MOSTRAR UNA INFORMACION
}
