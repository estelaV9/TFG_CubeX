import 'package:esteladevega_tfg_cubex/view/components/learn_guide/stepper/stepper_widget.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/material.dart';
import '../../components/appbar_class.dart';
import '../../components/learn_guide/cube_selector_row.dart';
import '../../utilities/app_styles.dart';

/// Pantalla principal de la guía de aprendizaje.
///
/// Esta pantalla permite al usuario seguir una guía paso a paso para resolver
/// distintos tipos de cubos utilizando un método específico
///
/// Contiene un carrusel para seleccionar el tipo de cubo y muestra un `StepperWidget`
/// personalizado que guía al usuario a través de los pasos necesarios para completar
/// el método elegido
///
/// Gestiona el estado actual del paso en el que se encuentra el usuario,
/// permitiendo avanzar, retroceder o completar el proceso.
/// También permite cambiar entre diferentes tipos de cubos y métodos relacionados,
/// actualizando los pasos mostrados
///
/// Métodos principales:
/// - [_onStepChanged] -> Cambia al paso seleccionado desde el Stepper
/// - [_goToPrevious] -> Retrocede un paso, si no es el primero
/// - [_goToNext] -> Avanza al siguiente paso, si no es el último
/// - [_completeProcess] -> Marca el proceso como finalizado y muestra un mensaje
///   de confirmación (actualmente con un `SnackBar`)
class LearnGuideScreen extends StatefulWidget {
  const LearnGuideScreen({super.key});

  @override
  State<LearnGuideScreen> createState() => _LearnGuideScreenState();
}

class _LearnGuideScreenState extends State<LearnGuideScreen> {
  // VARIABLE DE ESTADO QUE ALMACENA EL INDICE DEL PASO ACTUAL
  int currentStepIndex = 0;

  /// Metodo que cambia el paso actual al recibir un nuevo index
  ///
  /// Parametros:
  /// - [newIndex]: Indice del paso seleccionado
  void _onStepChanged(int newIndex) {
    setState(() {
      currentStepIndex = newIndex;
    });
  }

  /// Metodo que retrocede al paso anterior
  ///
  /// Comprueba que el `currentStepIndex` sea mayor que 0 antes de restar,
  /// evitando salir de los limites
  void _goToPrevious() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    } // SI ES MAYOR DE 0
  }

  /// Metodo que avanza al siguiente paso
  ///
  /// Comprueba que el `currentStepIndex` sea menor a 4 antes de sumar.
  /// (Actualmente el numero maximo de pasos esta fijo en 5, de 0 a 4).
  void _goToNext() {
    if (currentStepIndex < 4) {
      setState(() {
        currentStepIndex++;
      });
    } // SI ES MENOR DE 4
  }

  /// Metodo que completa el proceso de aprendizaje
  ///
  /// Actualmente muestra un `SnackBar` con un mensaje de confirmacion.
  /// En el futuro se mostrara la mascota felicitando al usuario
  void _completeProcess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Proceso completado :)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarClass.appBarWithBack(context, "learning_guide"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: AppStyles.boxDecorationContainer(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // FRANJA HORIZONTAL CON LOS TIPOS DE CUBOS A ELEGIR
              const CubeSelectorRow(),
              const SizedBox(height: 20),
              // TITULO A LA IZQUIERDA CON UN FONDO
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.downLinearColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Método Fridrich",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: "Caprasimo"),
                    ),
                  )),
              const SizedBox(height: 20),

              // STEPPER
              StepperWidget(
                currentIndex: currentStepIndex,
                onStepChanged: _onStepChanged,
                onPrevious: _goToPrevious,
                onNext: _goToNext,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppStyles.boxBottomNavigationContainer(),
        child: Row(
          // FILA PARA PONER LOS BOTONES DE PREVIOUS Y CONTINUE
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BOTON PARA IR AL PASO ANTERIOR
            ElevatedButton(
              // SI NO HAY PASO ANTERIOR, EL BOTON SE DESACTIVA
              onPressed: currentStepIndex > 0 ? _goToPrevious : null,
              style: ElevatedButton.styleFrom(
                // ESTILO DEL BOTON
                // CAMBIA EL COLOR SEGUN DISPONIBILIDAD
                backgroundColor:
                currentStepIndex > 0 ? AppColors.topColor : Colors.grey,
                // COLOR DEL TEXTO
                foregroundColor: Colors.white,
                // ESPACIADO INTERNO DEL BOTON
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Internationalization.internationalization
                  .localizedTextOnlyKey(context, "previous_step",
                  style: const TextStyle()),
            ),

            // BOTON PARA IR AL SIGUIENTE PASO O COMPLETAR EL PROCESO
            ElevatedButton(
              // SI NO ES EL ULTIMO PASO, AVANZA
              onPressed: currentStepIndex < 4
                  ? _goToNext
              // SI ES EL ULTIMO PASO, COMPLETA EL PROCESO, SI NO, SE DESACTIVA
                  : (currentStepIndex == 4 ? _completeProcess : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.topColor, // COLOR DE FONDO FIJO
                foregroundColor: Colors.white, // COLOR DEL TEXTO
                // ESPACIADO INTERNO DEL BOTON
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      ),
    );
  }
}