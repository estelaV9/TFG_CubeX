import 'package:flutter/material.dart';

class AlertUtil {
  static void showAlert(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  // SE CIERRA EL DIALOGO CUANDO PULSE "aceptar"
                  Navigator.of(context).pop();
                },
                child: const Text("Accept"),
              ),
            ],
          );
        });
  } // METODO PARA MOSTRAR UNA ALERTA

  static Future<String?> showAlertForm(
      String title, String content, String labelText, BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    // MOSTRAR EL DIALOG
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min, // AJUSTE DE TAMAÑO DEL CONTENIDO
            children: [
              Text(content),
              SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: OutlineInputBorder(),
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
              child: const Text("Accept"),
            ),
          ],
        );
      },
    );
  } // METODO PARA MOSTRAR UNA ALERTA FORMULARIO

  static showDeleteSessionOrCube(
      BuildContext context, String title, String content, Function delete) {
    // SE MUESTRA EL DIALOG
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // TITULO DE LA ALERTA
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              // BOTONES PARA CANCELAR O DARLE OK
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  delete(); // FUNCION PARA ELIMINAR SI PULSA OK
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  } // METODO PARA MOSTRAR UNA ALERTA DE SI DESEA ELIMINAR LA SESION O EL TIPO DE CUBO

  static showSnackBar(
      BuildContext context, IconData icon, String message, Color color) {
    // CREAMOS EL SNACKBAR
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color, // COLOR DE FONDO
      action: SnackBarAction(
        label: "Accept", // TEXTO DEL BOTON DE ACCION
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

  static showSnackBarError(BuildContext context, String message) {
    showSnackBar(context, Icons.error, message, Colors.redAccent);
  } // SNACKBAR PARA MOSTRAR UN ERROR

  static showSnackBarInformation(BuildContext context, String message) {
    showSnackBar(context, Icons.info, message, Colors.green);
  } // SNACKBAR PARA MOSTRAR UNA INFORMACION
}
