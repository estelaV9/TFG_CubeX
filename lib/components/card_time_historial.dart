import 'package:flutter/material.dart';
import '../dao/time_training_dao.dart';
import '../model/time_training.dart';
import '../utilities/app_color.dart';

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
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: listTimes.length,
      itemBuilder: (context, index) {
        final time = listTimes[index];
        return SizedBox(
          child: Card(
            color: AppColors.lightVioletColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: Center(
              child: Text(
                "${time.timeInSeconds.toStringAsFixed(2)} s",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
