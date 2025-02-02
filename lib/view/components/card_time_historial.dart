import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:flutter/material.dart';
import '../../data/dao/time_training_dao.dart';
import '../../model/time_training.dart';
import '../../utilities/app_color.dart';

class CardTimeHistorial extends StatefulWidget {
  const CardTimeHistorial({Key? key}) : super(key: key);

  @override
  State<CardTimeHistorial> createState() => _CardTimeHistorialState();
}

class _CardTimeHistorialState extends State<CardTimeHistorial> {
  List<TimeTraining> listTimes = [];

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  Future<void> _loadTimes() async {
    final timeTrainingDao = TimeTrainingDao();
    final times =
        await timeTrainingDao.getTimesOfSession(1); // ID DE SESION DE PRUBEA
    setState(() {
      listTimes = times;
    });
  }

  @override
  Widget build(BuildContext context) {
    // USA MediaQuery PARA OBTENER EL ANCHO DE LA VENTANA
    final screenWidth = MediaQuery.sizeOf(context).width;

    // DEFINE LA CANTIDAD DE COLUMNAS BASADA EN EL ANCHO DE LA VENTANA
    int crossAxisCount;
    // TAMAÑO DE LA LETRA DEPENDIENTO EL TAMAÑO DE LA PANTALLA
    double fontSize;
    if (screenWidth < 300) {
      crossAxisCount = 3; // TRES COLUMNA PARA MENOS DE 300PX
      fontSize = 8;
    } else if (screenWidth < 1000) {
      crossAxisCount = 4; // CUATRO COLUMNAS ENTRE 300PX Y 1000PX
      fontSize = 16;
      if (screenWidth > 700) {
        fontSize = 18;
      } // SI LA PANTALLA ES MAYOR QUE 800, AUMENTA UN POCO EL TAMAÑO DE LA LETRA
    } else {
      crossAxisCount = 5; // CINCO COLUMNAS PARA MAS DE 1000PX
      fontSize = 20;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: listTimes.length,
      itemBuilder: (context, index) {
        final time = listTimes[index];
        return SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: (){
              AlertUtil.showDetailsTime(context, listTimes[index]);
            },
            child: Card(
              color: AppColors.lightVioletColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Center(
                child: Text(
                  "${time.timeInSeconds.toStringAsFixed(2)}",
                  style:
                      TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
