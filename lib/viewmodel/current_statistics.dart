import 'package:flutter/cupertino.dart';
import '../data/dao/time_training_dao.dart';
import '../model/time_training.dart';

class CurrentStatistics extends ChangeNotifier {
  List<TimeTraining> _timesList = [];

  List<TimeTraining> get timesList => _timesList;

  void updateStatistics({required List<TimeTraining> timesListUpdate}) {
    _timesList = timesListUpdate;
    notifyListeners();
  } // ACTUALIZA LA LISTA DE TIEMPOS

  Future<String> getPbValue() async {
    return await TimeTrainingDao().getPbTimeBySession(_timesList);
  } // OBTIENE EL PB DE TODOS LOS TIEMPOS DE LA SESION

  Future<String> getWorstValue() async {
    return await TimeTrainingDao().getWorstTimeBySession(_timesList);
  } // OBTIENE EL PEOR TIEMPO DE TODOS LOS TIEMPOS DE LA SESION

  Future<String> getCountValue() async {
    int count = await TimeTrainingDao().getCountBySession(_timesList);
    print(count);
    return count.toString();
  } // METODO PARA OBTENER EL TOTAL DE TIEMPOS EN LA SESION


  /*Future<String> getAoXValue(int numAvg) async {
    return await TimeTrainingDao().getAoX(_timesList, numAvg);
  } // METODO AUXILIAR OBTENER LA MEDIA DE LOS X TIEMPOS DE LA SESION

  Future<String> getAo5Value() async {
    return await getAoXValue(5);
  } // OBTIENE LA MEDIA DE LOS 5 TIEMPOS MAS RECIENTES

  Future<String> getAo12Value() async {
    return await getAoXValue(12);
  } // OBTENER LA MEDIA DE LOS 12 TIEMPOS MAS RECIENTES

  Future<String> getAo50Value() async {
    return await getAoXValue(50);
  } // METODO PARA OBTENER LA MEDIA DE LOS 50 TIEMPOS MAS RECIENTES

  Future<String> getAo100Value() async {
    return await getAoXValue(100);
  } // METODO PARA OBTENER LA MEDIA DE LOS 100 TIEMPOS MAS RECIENTES*/
}