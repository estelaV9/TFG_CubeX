import 'package:esteladevega_tfg_cubex/model/time_training.dart';

import '../database/database_helper.dart';

class TimeTrainingDao {
  Future<List<TimeTraining>> getTimesOfSession(int idSession) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIEMPOS DE UNA SESION
      final result = await db.query(
        'timeTraining',
        where: 'idSession = ?',
        whereArgs: [idSession]
      );

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
        DatabaseHelper.logger.w(
            "No se encontraron tiempos para la sesion con ID: $idSession.");
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
      final result =
          await db.insert('timeTraining', {
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
}
