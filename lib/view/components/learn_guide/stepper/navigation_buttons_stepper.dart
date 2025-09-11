import 'package:flutter/material.dart';

import '../../../utilities/app_styles.dart';
import '../../../utilities/app_color.dart';
import '../../../utilities/internationalization.dart';

/// Widget para los botones de control de un Stepper de tutorial.
///
/// Este widget muestra una barra con dos botones que permiten al usuario:
/// - Avanzar entre los pasos de un tutorial.
/// - Volver a los pasos anteriores.
///
/// ### Características:
/// - Si el usuario se encuentra en el **primer paso**, el botón *Anterior* estará deshabilitado.
/// - Si el usuario se encuentra en el **último paso**, el botón *Continuar* cambiará a *Finalizar*.
///   Al presionar este botón se ejecutará la acción de completar el proceso
///   (por ahora se muestra un mensaje pero más adelante se implementará un mensaje con la mascota de la aplicación Cubix).
///
/// ### Parámetros:
/// - [currentStepIndex]: Índice actual del paso en el que se encuentra el usuario dentro del tutorial.
/// - [goToPrevious]: Callback que se ejecuta al presionar el botón *Anterior*.
/// - [goToNext]: Callback que se ejecuta al presionar el botón *Continuar* si no es el último paso.
/// - [completeProcess]: Callback que se ejecuta al presionar el botón *Finalizar* en el último paso.
class NavigationButtonsStepper extends StatelessWidget {
  /// Índice actual del paso en el que se encuentra el usuario dentro del tutorial.
  final int currentStepIndex;

  /// Callback que se ejecuta al presionar el botón *Anterior*
  final VoidCallback goToPrevious;

  /// Callback que se ejecuta al presionar el botón *Continuar*
  final VoidCallback goToNext;

  /// Callback que se ejecuta al presionar el botón *Finalizar*
  /// cuando el usuario llega al último paso del tutorial.
  final VoidCallback completeProcess;

  const NavigationButtonsStepper({
    super.key,
    required this.currentStepIndex,
    required this.goToPrevious,
    required this.goToNext,
    required this.completeProcess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.boxBottomNavigationContainer(),
      child: Row(
        // FILA PARA PONER LOS BOTONES DE PREVIOUS Y CONTINUE
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // BOTON PARA IR AL PASO ANTERIOR
          ElevatedButton(
            // SI NO HAY PASO ANTERIOR, EL BOTON SE DESACTIVA
            onPressed: currentStepIndex > 0 ? goToPrevious : null,
            style: ElevatedButton.styleFrom(
              // ESTILO DEL BOTON
              // CAMBIA EL COLOR SEGUN DISPONIBILIDAD
              backgroundColor:
                  currentStepIndex > 0 ? AppColors.topColor : Colors.grey,
              // COLOR DEL TEXTO
              foregroundColor: Colors.white,
              // ESPACIADO INTERNO DEL BOTON
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Internationalization.internationalization
                .localizedTextOnlyKey(context, "previous_step",
                    style: const TextStyle()),
          ),

          // BOTON PARA IR AL SIGUIENTE PASO O COMPLETAR EL PROCESO
          ElevatedButton(
            // SI NO ES EL ULTIMO PASO, AVANZA
            onPressed: currentStepIndex < 4
                ? goToNext
                // SI ES EL ULTIMO PASO, COMPLETA EL PROCESO, SI NO, SE DESACTIVA
                : (currentStepIndex == 4 ? completeProcess : null),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.topColor, // COLOR DE FONDO FIJO
              foregroundColor: Colors.white, // COLOR DEL TEXTO
              // ESPACIADO INTERNO DEL BOTON
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            // SI ES EL ULTIMO PASO CAMBIA EL TEXTO A "COMPLETE" SI NO SE QUEDA EN "CONTINUE"
            child: currentStepIndex == 4
                ? Internationalization.internationalization
                    .localizedTextOnlyKey(context, "complete_step",
                        style: const TextStyle())
                : Internationalization.internationalization
                    .localizedTextOnlyKey(context, "continue_step",
                        style: const TextStyle()),
          ),
        ],
      ),
    );
  }
}