import 'package:esteladevega_tfg_cubex/view/components/learn_guide/stepper/stepper_widget.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/material.dart';
import '../../components/Icon/icon.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}