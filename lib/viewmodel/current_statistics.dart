import 'package:flutter/cupertino.dart';

class CurrentStatistics extends ChangeNotifier {
  String averageValue = "--:--.--";
  String pbValue = "--:--.--";
  String worstValue = "--:--.--";
  String countValue = "--:--.--";
  String ao5Value = "--:--.--";
  String ao12Value = "--:--.--";
  String ao50Value = "--:--.--";
  String ao100Value = "--:--.--";

  void updateStatistics({
    required String pb,
    required String worst,
    required String count,
    String? average,
    String? ao5,
    String? ao12,
    String? ao50,
    String? ao100,
  }) {
    pbValue = pb;
    worstValue = worst;
    countValue = count;
    if (average != null) averageValue = average;
    if (ao5 != null) ao5Value = ao5;
    if (ao12 != null) ao12Value = ao12;
    if (ao50 != null) ao50Value = ao50;
    if (ao100 != null) ao100Value = ao100;
    notifyListeners();
  } // METODO PARA ACTUALIZAR LAS ESTADISTICAS
}