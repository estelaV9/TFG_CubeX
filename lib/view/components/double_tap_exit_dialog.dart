import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:flutter/material.dart';

/// Clase que implementa la funcionalidad de salir de la aplicación con un
/// doble toque en el boton de ir para atras.
///
/// Esta clase se utiliza sobretodo como una manera de evitar salidas accidentales,
/// por ejemplo, cuando un usuario está en la pantalla principal y podría salir sin querer al login.
///
/// Se muestra un mensaje para confirmar si el usuario desea salir de la aplicacion
/// al presionar dos veces el boton de ir para atrás.
class DoubleTapExitDialog extends StatefulWidget {
  /// Widget que se va a envolver con esta funcionalidad.
  final Widget child;

  const DoubleTapExitDialog({super.key, required this.child});

  @override
  State<DoubleTapExitDialog> createState() => _DoubleTapExitDialogState();
}

class _DoubleTapExitDialogState extends State<DoubleTapExitDialog> {
  /// Almacena la hora de la ultima vez que se presiono el boton de retroceso.
  DateTime? _lastBackButtonTime;

  /// Limite de tiempo que determina si se considera un doble toque
  /// para salir de la aplicacion (2 segundos).
  final Duration _exitLimitTime = const Duration(seconds: 2);

  /// Metodo para cuando se presiona el boton de retroceso.
  ///
  /// Si la diferencia de tiempo entre dos pulsaciones es menor que el limite,
  /// se muestra un mensaje de confirmacion antes de cerrar la aplicación.
  ///
  /// Si no es un doble toque, muestra un snackbar de advertendcia al usuario
  /// para que pulse de nuevo para confirmar su salida.
  Future<bool> _confirmExit() async {
    final now = DateTime.now();

    if (_lastBackButtonTime == null ||
        now.difference(_lastBackButtonTime!) > _exitLimitTime) {
      // PRIMERA PULSACION MOSTRAR MENSAJE
      _lastBackButtonTime = now;
      AlertUtil.showSnackBarWithDuration(context, 2, "press_again_to_exit");
      return false;
    } // SE VERIFICA SI ES LA PRIMERA VEZ O YA PASO EL TIEMPO LIMITE ENTRE PULSACIONES

    // LA SEGUNDA PULSACION MUESTRA LA ALERTA DE SALIDA
    AlertUtil.showExitAlert(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // EVITAR QUE SE PUEDA SALIR DIRECTAMENTE CON EL BOTON DE ATRAS
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          // MOSTRAR ALERTA O MENSAJE DE CONFIRMACION
          await _confirmExit();
        } // SI NO SE HIZO POP, SE MANEJA MANUALMENTE LA SALIDA
      },
      // CONTENIDO PRINCIPAL QUE SE MUESTRA EN LA PANTALLA
      child: widget.child,
    );
  }
}