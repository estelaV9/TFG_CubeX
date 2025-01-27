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


  Future<List<Session>> getSessionOfUser(int idName) async {
    final db = await DatabaseHelper.database;
    List<Session> sessionError = [];
    try {
      final sessions = await db.query(
          'sessionTime',
          where: 'idUser = ?',
          whereArgs: [idName]
      );

      if (sessions.isNotEmpty) {
        return sessions.map((session) {
          return Session(
            idUser: session['idUser'] as int,
            sessionName: session['sessionName'] as String,
            idCubeType: session['idCubeType'] as int,
          );
        }).toList();
      } else {
        return sessionError;
      } // SI NO ESTA VACIO, RETORNA LA SESSION, SI NO DEVUELVE NULL

    } catch (e) {
      DatabaseHelper.logger.e("Error al listar sessiones del usuario: $e");
      return sessionError;
    }
  } // METODO PARA OBTENER LAS SESSIONES DE UN USUARIO

  Future<bool> deleteSession(int idSession) async {
    final db = await DatabaseHelper.database;
    try {
      // SE ELIMINA LA SESION CON EL ID PROPORCIONADO
      final deleteSession = await db.delete('sessionTime',
          where: 'idSession = ?', whereArgs: [idSession]);

      // DEVUELVE TRUE/FALSE SI SE ELIMINO CORRECTAMENTE O NO
      return deleteSession > 0;
    } catch (e) {
      DatabaseHelper.logger.e("Error al eliminar la sesion: $e");
      return false;
    }
  } // METODO PARA ELIMINAR UNA SESION

  Future<int> searchIdSessionByNameAndUser(
      int idUser, String sessionName) async {
    final db = await DatabaseHelper.database;
    try {
      // BUSCA LA SESION CON EL NOMBRE Y EL ID PROPORCIONADO
      final result = await db.query('sessionTime',
          where: 'idUser = ? AND sessionName = ?',
          whereArgs: [idUser, sessionName]);

      if(result.isNotEmpty){
        return result.first['idSession'] as int;
      } else {
        DatabaseHelper.logger.e("No hay resultados de esa sesion");
        return -1;
      } // SI NO ESTA VACIO, RETORNA EL ID, SI NO DEVUELVE -1
    } catch (e) {
      DatabaseHelper.logger.e("Error al buscar el id de la sesion: $e");
      return -1;
    }
  } // METODO PARA BUSCAR EL ID DE LA SESION POR EL NOMBRE DE LA SESION Y ID USUARIO


  Future<Session?> getSessionByUserAndName(int idUser, String sessionName) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER LA SESION BASADA EN EL ID DEL USUARIO Y EL NOMBRE DE LA SESION
      final result = await db.query(
        'sessionTime',
        where: 'idUser = ? AND sessionName = ?',
        whereArgs: [idUser, sessionName],
      );

      if (result.isNotEmpty) {
        // SI SE ENCUENTRA LA SESION, SE MAPEA LOS DATOS Y SE DEVOLVE LA SESION
        final session = result.first;
        return Session(
          idSession: session['idSession'] as int,
          idUser: session['idUser'] as int,
          sessionName: session['sessionName'] as String,
          idCubeType: session['idCubeType'] as int,
          creationDate: session['creationDate'] as String,
        );
      } else {
        // SI NO SE ENCONTRO NINGUNA SESION, RETORNAMOS NULL
        DatabaseHelper.logger.w(
            "No se encontro la sesion para el usuario con id $idUser y nombre de sesion $sessionName");
        return null;
      } // VERIFICAMOS SI EL RESULTADO ES NULO O NO
    } catch (e) {
      // SI DA ERROR, DEVOLVEMOS NULL
      DatabaseHelper.logger.e(
          "Error al obtener la sesion del usuario con id $idUser: $e");
      return null;
    }
  } // METODO QUE DEVUELVE UNA SESION POR ID DE USUARIO Y NOMBRE DE LA SESION

}
