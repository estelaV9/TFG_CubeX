import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../model/session.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import 'cubetype_dao.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre las **sesiones**.
///
/// Esta clase permite interactuar con la base de datos para obtener, insertar,
/// eliminar o verificar la existencia de sesiones. Utiliza la clase `DatabaseHelper`
/// para realizar las consultas y operaciones necesarias sobre la base de datos.
class SessionDao {
  /// Método para insertar una nueva sesión en la base de datos.
  ///
  /// Este método recibe un objeto [Session] que contiene los detalles de la sesión a insertar,
  /// como el [idUser], [sessionName], [idCubeType], y [creationDate].
  ///
  /// Parámetros:
  /// - `session`: Objeto de tipo [Session] que contiene los datos de la sesión a insertar.
  ///
  /// Retorna:
  /// - `bool`: `true` si la inserción fue exitosa, `false` si ocurrió un error.
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

  /// Método que obtiene todas las sesiones de la base de datos.
  ///
  /// Realiza una consulta a la tabla `sessionTime` y mapea los resultados a una lista de objetos [Session].
  ///
  /// Retorna:
  /// - `List<Session>`: Lista de todas las sesiones encontradas en la base de datos.
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

  /// Método para verificar si existe una sesión con un nombre específico.
  ///
  /// Este método realiza una consulta en la base de datos para verificar si ya existe una sesión
  /// con el nombre proporcionado en la tabla `sessionTime`.
  ///
  /// Parámetros:
  /// - `name`: Nombre de la sesión a verificar.
  ///
  /// Retorna:
  /// - `bool`: `true` si la sesión ya existe, `false` si no existe.
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

  /// Método que obtiene todas las sesiones de un usuario específico.
  ///
  /// Este método recibe un [idUser] (ID del usuario) y devuelve todas las sesiones asociadas
  /// a ese usuario desde la base de datos.
  ///
  /// Parámetros:
  /// - `idUser`: ID del usuario cuyo sesiones se desean obtener.
  ///
  /// Retorna:
  /// - `List<Session>`: Lista de sesiones asociadas al usuario.
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

  /// Método para eliminar una sesión por su ID.
  ///
  /// Este método elimina una sesión específica de la base de datos utilizando el [idSession].
  ///
  /// Parámetros:
  /// - `idSession`: ID de la sesión a eliminar.
  ///
  /// Retorna:
  /// - `bool`: `true` si la sesión fue eliminada correctamente, `false` si ocurrió un error.
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

  /// Método para buscar el ID de una sesión a partir del nombre y ID del usuario.
  ///
  /// Este método busca el [idSession] utilizando el [idUser] y [sessionName].
  ///
  /// Parámetros:
  /// - `idUser`: ID del usuario.
  /// - `sessionName`: Nombre de la sesión.
  ///
  /// Retorna:
  /// - `int`: El [idSession] encontrado, o `-1` si no se encuentra la sesión.
  Future<int> searchIdSessionByNameAndUser(
      int idUser, String sessionName) async {
    final db = await DatabaseHelper.database;
    try {
      // BUSCA LA SESION CON EL NOMBRE Y EL ID PROPORCIONADO
      final result = await db.query('sessionTime',
          where: 'idUser = ? AND sessionName = ?',
          whereArgs: [idUser, sessionName]);

      if (result.isNotEmpty) {
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

  /// Método para obtener una sesión específica por el ID de usuario y el nombre de la sesión.
  ///
  /// Este método obtiene una sesión asociada a un usuario específico utilizando el [idUser]
  /// y el [sessionName].
  ///
  /// Parámetros:
  /// - `idUser`: ID del usuario.
  /// - `sessionName`: Nombre de la sesión.
  ///
  /// Retorna:
  /// - `Session?`: Objeto [Session] encontrado, o `null` si no se encuentra la sesión.
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

  /// Método para buscar las sesiones asociadas a un tipo de cubo y un usuario específico.
  ///
  /// Este método recibe el [idUser] y [idCubeType], y retorna todas las sesiones
  /// correspondientes a esos parámetros.
  ///
  /// Parámetros:
  /// - `idUser`: ID del usuario.
  /// - `idCubeType`: ID del tipo de cubo.
  ///
  /// Retorna:
  /// - `List<Session>`: Lista de sesiones asociadas al usuario y tipo de cubo.
  Future<List<Session>> searchSessionByCubeAndUser(
      int idUser, int idCubeType) async {
    final db = await DatabaseHelper.database;
    try {
      // BUSCA LA SESION CON EL TIPO DE CUBO Y EL ID PROPORCIONADO
      final result = await db.query('sessionTime',
          where: 'idUser = ? AND idCubeType = ?',
          whereArgs: [idUser, idCubeType]);

      if (result.isNotEmpty) {
        // DEVUELVE LA LISTA DE SESIONES CON ESE TIPO DE CUBO Y ESE USUARIO
        return result.map((session) {
          return Session(
            idSession: session['idSession'] as int,
            idUser: session['idUser'] as int,
            sessionName: session['sessionName'] as String,
            creationDate: session['creationDate'] as String,
            idCubeType: session['idCubeType'] as int,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      DatabaseHelper.logger.e("Error listar las sesiones por un tipo de cubo de un usuario: $e");
      return [];
    }
  } // METODO PARA BUSCAR EL ID DE LA SESION POR EL NOMBRE DE LA SESION Y ID USUARIO

  /// Método para obtener una sesión específica utilizando el ID de usuario, el nombre de la sesión y el tipo de cubo.
  ///
  /// Este método devuelve una sesión asociada a un usuario y un tipo de cubo específico, buscando
  /// por el [idUser], [sessionName] y [idCubeType].
  ///
  /// Parámetros:
  /// - `idUser`: ID del usuario.
  /// - `sessionName`: Nombre de la sesión.
  /// - `idCubeType`: ID del tipo de cubo.
  ///
  /// Retorna:
  /// - `Session?`: Objeto [Session] encontrado, o `null` si no se encuentra la sesión.
  Future<Session?> getSessionByUserCubeName(
      int idUser, String sessionName, int? idCubeType) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER LA SESION BASADA EN EL ID DEL USUARIO, EL NOMBRE DE LA SESION
      // Y TIPO DE CUBO
      final result = await db.query(
        'sessionTime',
        where: 'idUser = ? AND sessionName = ? AND idCubeType = ?',
        whereArgs: [idUser, sessionName, idCubeType],
      );

      if (result.isNotEmpty) {
        // SI SE ENCUENTRA LA SESION, SE MAPEA LOS DATOS Y SE DEVOLVE LA SESION
        final session = result.first;
        return Session(
          idSession: session['idSession'] as int?,
          idUser: session['idUser'] as int,
          sessionName: session['sessionName'] as String,
          idCubeType: session['idCubeType'] as int,
          creationDate: session['creationDate'] as String,
        );
      } else {
        // SI NO SE ENCONTRO NINGUNA SESION, RETORNAMOS NULL
        DatabaseHelper.logger.w(
            "No se encontro la sesion para el usuario con id $idUser, nombre de sesion $sessionName y id de tipo de cubo $idCubeType");
        return null;
      } // VERIFICAMOS SI EL RESULTADO ES NULO O NO
    } catch (e) {
      // SI DA ERROR, DEVOLVEMOS NULL
      DatabaseHelper.logger.e(
          "Error para encontrar la sesion para el usuario con id $idUser, nombre de sesion $sessionName y id de tipo de cubo $idCubeType");
      return null;
    }
  } // METODO QUE DEVUELVE UNA SESION POR ID DE USUARIO, NOMBRE DE LA SESION Y TIPO DE CUBO

  /// Método para obtener la sesión actual del usuario según el nombre de la sesión y el tipo de cubo actual.
  ///
  /// Parámetros:
  /// - [idUser]: ID del usuario para el cual se quiere obtener la sesión.
  ///
  /// Este método recupera la sesión correspondiente al usuario y cubo actual.
  /// Si no se encuentra la sesión o el tipo de cubo, se retorna `null` y se muestra un error en consola.
  ///
  /// Retorna un [Future<Session?>] con la sesión o `null`.
  Future<Session?> getSessionData(BuildContext context, int idUser) async {
    final sessionDao = SessionDao();
    final cubeDao = CubeTypeDao();

    final currentSession = context.read<CurrentSession>().session;
    final currentCubeType = context.read<CurrentCubeType>().cubeType;

    if (currentSession == null || currentCubeType == null) {
      DatabaseHelper.logger.e("Sesión o tipo de cubo no encontrados.");
      return null;
    }

    final cubeType = await cubeDao.cubeTypeDefault(currentCubeType.cubeName);
    return await sessionDao.getSessionByUserCubeName(
        idUser, currentSession.sessionName, cubeType.idCube);
  }

}
