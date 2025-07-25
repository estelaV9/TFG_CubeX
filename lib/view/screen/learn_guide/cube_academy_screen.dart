import 'package:flutter/material.dart';

import '../../components/appbar_class.dart';
import '../../utilities/app_styles.dart';

// PANTALLA PRINCIPAL QUE CONTIENE EL CUBO
class CubeAcademyScreen extends StatefulWidget {
  const CubeAcademyScreen({super.key});

  @override
  State<CubeAcademyScreen> createState() => _CubeAcademyScreenState();
}

class _CubeAcademyScreenState extends State<CubeAcademyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarClass.appBarWithBack(context, "cube_academy"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: AppStyles.boxDecorationContainer(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: Alignment.center,
                children: [],
              ),
            ),
          ),
        ));
  }
}