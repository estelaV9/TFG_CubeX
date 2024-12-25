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
                  Navigator.of(context).pop(); // SE CIERRA EL DIALOGO CUANDO PULSE "aceptar"
                },
                child: const Text("Accept"),
              ),
            ],
          );
        });
  } // METODO PARA MOSTRAR UNA ALERTA
}
