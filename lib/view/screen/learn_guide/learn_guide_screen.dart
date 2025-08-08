import 'package:flutter/material.dart';
import '../../components/appbar_class.dart';
import '../../components/learn_guide/cube_selector_row.dart';
import '../../utilities/app_styles.dart';

// PANTALLA PRINCIPAL QUE CONTIENE LOS PASOS PARA SOLUCIONAR DISTINTOS TIPOS DE CUBOS
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
          child: const SingleChildScrollView(
            child: Column(
              children: [
                // FRANJA HORIZONTAL CON LOS TIPOS DE CUBOS A ELEGIR
                CubeSelectorRow(),
              ],
            ),
          ),
        ));
  }
}