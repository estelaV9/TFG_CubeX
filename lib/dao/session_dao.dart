import 'package:esteladevega_tfg_cubex/database/database_helper.dart';

import '../model/session.dart';

class SessionDao {
  Future<bool> insertSession(Session session) async {
    final db = await DatabaseHelper.database;
    try {
      final result = await db.insert('sessionTime', {
        'idUser': session.idUser,
        'sessionName': session.sessionName,
        'idCubeType': session.idCubeType,
        'creationDate': session.creationDate,
      });

      if (result > 0) {
        return true; // SE INSERTO CORRECTAMENTE
      } else {
        return false; // NO SE INSERTO CORRECTAMENTE
      } // VERIFICAMOS SI SE HA INSERTADO COMPROBANDO EL ID RETORNADO
    } catch (e) {
      DatabaseHelper.logger.e("Error al insertar la session: $e");
      return false;
    }
  } // METODO PARA INSERTAR UNA SESSION

  Future<List<Session>> sessionList() async {
    final db = await DatabaseHelper.database;
    try {
      final sessions = await db.rawQuery('SELECT * FROM sessionTime');

      if (sessions.isNotEmpty) {
        // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS Session
        return sessions
            .map((map) => Session(
                sessionName: map['sessionName'] as String,
                idCubeType: map['idCubeType'] as int,
                idUser: map['idUser'] as int))
            .toList();
      } else {
        DatabaseHelper.logger.w('No se encontraron sesiones.');
        return []; // RETORNA UNA LISTA VACIA SI NO HYA SESIONES
      } // SI NO ESTA VACIO, RETORNA LOS RESULTADO MAPEADOS
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener las sesiones: $e");
      return []; // RETORNA UNA LISTA VACÍA EN CASO DE ERROR
    }
  } // METODO QUE DEVUELVE LAS SESIONES QUE HAY

  Future<bool> isExistsSessionName(String name) async {
    final db = await DatabaseHelper.database;
    try {
      final List<Map<String, Object?>> result = await db
          .query('sessionTime', where: 'sessionName = ?', whereArgs: [name]);

      if (result.isNotEmpty) {
        // SI DEVUELVE UN RESULTADO, DEVUELVE TRUE
        return true;
      } else {
        // SI NO DEVUELVE FALSE
        return false;
      } // DEPENDIENDO SI ESTA VACIO O NO, DEVUELVE TRUE/FALSE;
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al verificar si existe el nombre de la sesion $e");
      return false; // EN CASO DE ERROR, RETORNA FALSE
    }
  } // METODO PARA BUSCAR SI EL NOMBRE DE LA SESION YA EXISTE
}
