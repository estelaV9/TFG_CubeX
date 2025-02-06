import 'dart:ffi';
import 'dart:math';

import 'package:esteladevega_tfg_cubex/model/time_training.dart';

import '../database/database_helper.dart';

class TimeTrainingDao {
  Future<List<TimeTraining>> getTimesOfSession(int? idSession) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIEMPOS DE UNA SESION
      final result = await db.query('timeTraining',
          where: 'idSession = ?', whereArgs: [idSession]);

      if (result.isNotEmpty) {
        // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS TimeTraining
        return result.map((map) {
          return TimeTraining(
            idTimeTraining: map['idTimeTraining'] as int,
            idSession: map['idSession'] as int,
            scramble: map['scramble'] as String,
            timeInSeconds: map['timeInSeconds'] as double,
            comments: map['comments'] as String?,
            penalty: map['penalty'] as String,
            registrationDate: map['registrationDate'] as String,
          );
        }).toList();
      } else {
        DatabaseHelper.logger
            .w("No se encontraron tiempos para la sesion con ID: $idSession.");
        return []; // DEVOLVER UNA LISTA VACIA SI NO HAY RESULTADOS
      } // VERIFICAR SI HAY RESULTADOS
    } catch (e) {
      // SI HAY UN ERROR, MMUESTRA UN MENSAJE
      DatabaseHelper.logger.e("Error al obtener los tiempos de la sesion: $e");
      return []; // DEVOLVER UNA LISTA VACIA EN CASO DE ERROR
    }
  } // METODO QUE DEVUELVE LOS TIEMPOS QUE HAY EN UNA SESION

  Future<bool> insertNewTime(TimeTraining timeTraining) async {
    final db = await DatabaseHelper.database;
    try {
      final result = await db.insert('timeTraining', {
        'idSession': timeTraining.idSession,
        'scramble': timeTraining.scramble,
        'timeInSeconds': timeTraining.timeInSeconds,
        'comments': timeTraining.comments,
        'penalty': timeTraining.penalty,
        'registrationDate': timeTraining.registrationDate
      });

      if (result > 0) {
        return true; // SE INSERTO CORRECTAMENTE
      } else {
        return false; // NO SE INSERTO CORRECTAMENTE
      } // VERIFICAMOS SI SE HA INSERTADO CORRECTAMENTE
    } catch (e) {
      DatabaseHelper.logger.e("Error al insertar un nuevo registro: $e");
      return false; // DEVUELVE FALSE EN CASO DE ERROR
    }
  } // METODO PARA INSERTAR UN NUEVO REGISTRO DE TIEMPO DE UNA SESION

  /** CALCULAR LAS ESTADISTICAS **/
  // pbValue, worstValue, countValue,
  // averageValue, ao5Value, ao12Value,
  // ao50Value, ao100Value

  Future<String> getPbTimeBySession(List<TimeTraining> timesList) async {
    var pbTime = 0.0; // INICIALIZAR EL MEJOR TIEMPO
    var worstTime = 0.0; // INICIALIZAR EL PEOR TIEMPO
    int minutes = 0;

    for (var times in timesList) {
      if (times.timeInSeconds > worstTime) {
        worstTime = times.timeInSeconds;
      } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
    } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL PEOR TIEMPO DE LA SESION

    pbTime = worstTime; // EL MEJOR TIEMPO ES EL PEOR (para darle un valor)

    for (var times in timesList) {
      if (times.timeInSeconds < pbTime) {
        pbTime = times.timeInSeconds;
      } // SI EL TIEMPO ES MAYOR AL MEJOR TIEMPO SE ESTABLECE
    } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL MEJOR TIEMPO DE LA SESION

    while (pbTime >= 60) {
      minutes++;
      pbTime -= 60; // RESTANIS 60 SEGUNDO CUANDO PASE UN MINUTO
    } // RECORREMOS EL TIEMPO MIENTRAS TENGA MINUTOS

    if (pbTime < 10) {
      return "$minutes:0${pbTime.toStringAsFixed(2)}";
    } else {
      return "$minutes:${pbTime.toStringAsFixed(2)}";
    } // DEVUELVE ELMEJOR TIEMPO FORMATEADO
  } // METODO PARA OBTENER EL MEJOR TIEMPO DE UNA SESION


  Future<String> getWorstTimeBySession(List<TimeTraining> timesList) async {
    var worstTime = 0.0; // INICIALIZAR EL PEOR TIEMPO
    int minutes = 0;
    for (var times in timesList) {
      if (times.timeInSeconds > worstTime) {
        worstTime = times.timeInSeconds;
      } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
    } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL PEOR TIEMPO DE LA SESION

    while (worstTime >= 60) {
      minutes++;
      worstTime -= 60; // RESTANIS 60 SEGUNDO CUANDO PASE UN MINUTO
    } // RECORREMOS EL TIEMPO MIENTRAS TENGA MINUTOS

    if (worstTime < 10) {
      return "$minutes:0${worstTime.toStringAsFixed(2)}";
    } else {
      return "$minutes:${worstTime.toStringAsFixed(2)}";
    } // DEVUELVE EL PEOR TIEMPO FORMATEADO
  } // METODO PARA OBTENER EL PEOR TIEMPO DE UNA SESION


  Future<int> getCountBySession(List<TimeTraining> timesList) async {
    return timesList.length; // DEVUELVE EL TAMAÑO DE LA LISTA DE TIEMPOS
  } // METODO PARA OBTENER LA CANTIDAD DE TIEMPOS QUE HAY EN UNA SESION


  /*Future<String> getAoX(List<TimeTraining> timesList, int numAvg) async {
    if (timesList.length < numAvg) {
      return "--:--.--";
    } // SI NO HAY LOS x TIEMPOS PARA HACER ESA MEDIA, DEVUELVE EL STRING POR DEFECTO

    double avgTimeInSeconds = 0.0;

    int minutes = 0;
    double seconds = 0.0;

    // ORDENAMOS POR FECHA MAS RECIENTE
    timesList.sort((a, b) {
      // CONVERTIMOS LAS FECHAS A DATETIME PARA HACER LA COMPARACION
      DateTime dateA = DateTime.parse(a.registrationDate);
      DateTime dateB = DateTime.parse(b.registrationDate);

      // CompareTo PARA QUE EL MAS RECIENTE ESTE PRIMERO
      return dateB.compareTo(dateA); // SE ORDENA DE MAS RECIENTE
    });

    for (int i = 0; i <= numAvg; i++) {
      avgTimeInSeconds += timesList[i].timeInSeconds; // SUMAMOS EL TIEMPO
    } // RECORRE LOS TIEMPOS HASTA EL NUMERO PROPORCIONADO

    double aux = avgTimeInSeconds;
    while (aux % 60 > 9) {
      minutes++;
      aux % 10;
    }

    return "$minutes:$seconds";
  } // METODO PARA HACER LA MEDIA DE x TIEMPOS (5,12,50,100,total)*/
}
