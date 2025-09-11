import 'package:esteladevega_tfg_cubex/view/components/learn_guide/stepper/stepper_widget.dart';
import 'package:esteladevega_tfg_cubex/view/components/learn_guide/title_method.dart';
import 'package:flutter/material.dart';
import '../../components/appbar_class.dart';
import '../../components/learn_guide/cube_selector_row.dart';
import '../../components/learn_guide/stepper/navigation_buttons_stepper.dart';
import '../../utilities/app_styles.dart';

/// Pantalla principal de la guía de aprendizaje.
///
/// Esta pantalla permite al usuario seguir una guía paso a paso para resolver
/// distintos tipos de cubos usando un método específico. Contiene un carrusel
/// para seleccionar el tipo de cubo, gestionado por un `SliverAppBar` que se
/// expande o colapsa al hacer scroll, y un `StepperWidget` que guia al usuario por
/// los pasos del metodo.
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
        decoration: AppStyles.boxDecorationContainer(),
        // SLIVER QUE CONTIENE EL CARROUSEL, QUE SE EXPANDE O COLAPSA AL HACER SCROLL
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              // NO MUESTRA AUTOMATICAMENTE LA FLECHA DE BACK
              automaticallyImplyLeading: false,
              // ALTURA EXPANDIDA DEL APPBAR
              expandedHeight: 170,
              // EL APPBAR ES TRANSPARENTE
              backgroundColor: Colors.transparent,

              // ZONA FLEXIBLE DEL APPBAR QUE SE EXPANDE O COLAPSA AL HACER SCROLL (carousel)
              flexibleSpace: FlexibleSpaceBar(
                // EFECTO DE PARALLAX AL HACER SCROLL
                collapseMode: CollapseMode.parallax,
                // FRANJA HORIZONTAL PARA SELECCIONAR TIPOS DE CUBO
                background: Padding(
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: CubeSelectorRow(),
                ),
              ),
            ),
            SliverPadding(
              // ESPACIADO INTERNO DE TODOS LOS ELEMENTOS DEL SLIVERLIST
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                // LISTA DE ELEMENTOS QUE SE MUEVEN CON EL SCROLL
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      // TITULO DEL METODO A LA IZQUIERDA CON UN FONDO
                      const TitleMethod(),

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
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationButtonsStepper(
        currentStepIndex: currentStepIndex,
        goToPrevious: _goToPrevious,
        goToNext: _goToNext,
        completeProcess: _completeProcess,
      ),
    );
  }
}