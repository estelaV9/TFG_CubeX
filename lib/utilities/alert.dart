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
          Navigator.of(context).pop();
        },
      ),
      content: Row(
        children: [Icon(icon), const SizedBox(width: 10), Text(message)],
      ), // EL TEXTO QUE SE MOSTRARA EN EL SNACKBAR
    );

    // MOSTRAMOS EL SNACKBAR
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // SE CIERRA EL SNACKBAR PASADOS LOS 5 SEGUNDOS
    Future.delayed(const Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  } // MOSTRAR UN SNACKBAR
}
