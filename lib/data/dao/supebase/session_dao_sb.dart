import 'package:esteladevega_tfg_cubex/data/dao/supebase/cubetype_dao_sb.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../model/session.dart';
import '../../../viewmodel/current_cube_type.dart';
import '../../../viewmodel/current_session.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre las **sesiones**
/// desde Supabase.
///
/// Esta clase permite interactuar con la base de datos para obtener, insertar,
/// eliminar o verificar la existencia de sesiones.
class SessionDaoSb {
  final supabase = Supabase.instance.client;

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
  Future<bool> insertSession(SessionClass session) async {
    try {
      await supabase.from('sessiontime').insert({
        'iduser': session.idUser,
        'sessionname': session.sessionName,
        'idcubetype': session.idCubeType,
        'creationdate': session.creationDate,
      });

      return true;
    } catch (e) {
      DatabaseHelper.logger.e("Error al insertar la session: $e");
      return false;
    }
  } // METODO PARA INSERTAR UNA SESSION

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
    try {
      // SE ELIMINA LA SESION CON EL ID PROPORCIONADO
      final response = await supabase
          .from('sessiontime')
          .delete()
          .eq('idsession', idSession).select();

      return response.isNotEmpty;
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
    try {
      // BUSCA LA SESION CON EL NOMBRE Y EL ID PROPORCIONADO
      final result = await supabase
          .from('sessiontime')
          .select()
          .eq('iduser', idUser)
          .eq('sessionname', sessionName);

      if (result.isNotEmpty) {
        return result.first['idsession'] as int;
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
  Future<SessionClass?> getSessionByUserAndName(
      int idUser, String sessionName) async {
    try {
      // CONSULTA PARA OBTENER LA SESION BASADA EN EL ID DEL USUARIO Y EL NOMBRE DE LA SESION
      final result = await supabase
          .from('sessiontime')
          .select()
          .eq('iduser', idUser)
          .eq('sessionname', sessionName);

      if (result.isNotEmpty) {
        // SI SE ENCUENTRA LA SESION, SE MAPEA LOS DATOS Y SE DEVOLVE LA SESION
        final session = result.first;
        return SessionClass(
          idSession: session['idsession'] as int,
          idUser: session['iduser'] as int,
          sessionName: session['sessionname'] as String,
          idCubeType: session['idcubetype'] as int,
          creationDate: session['creationdate'] as String,
        );
      } else {
        // SI NO SE ENCONTRO NINGUNA SESION, RETORNAMOS NULL
        DatabaseHelper.logger.w(
            "No se encontro la sesion para el usuario con id $idUser y nombre de sesion $sessionName");
        return null;
      } // VERIFICAMOS SI EL RESULTADO ES NULO O NO
    } catch (e) {
      // SI DA ERROR, DEVOLVEMOS NULL
      DatabaseHelper.logger
          .e("Error al obtener la sesion del usuario con id $idUser: $e");
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
  Future<List<SessionClass>> searchSessionByCubeAndUser(
      int idUser, int idCubeType) async {
    try {
      // BUSCA LA SESION CON EL TIPO DE CUBO Y EL ID PROPORCIONADO
      final result = await supabase
          .from('sessiontime')
          .select()
          .eq('iduser', idUser)
          .eq('idcubetype', idCubeType);

      if (result.isNotEmpty) {
        // DEVUELVE LA LISTA DE SESIONES CON ESE TIPO DE CUBO Y ESE USUARIO
        return result.map((session) {
          return SessionClass(
            idSession: session['idsession'] as int,
            idUser: session['iduser'] as int,
            sessionName: session['sessionname'] as String,
            creationDate: session['creationdate'] as String,
            idCubeType: session['idcubetype'] as int,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      DatabaseHelper.logger
          .e("Error listar las sesiones por un tipo de cubo de un usuario: $e");
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
  Future<SessionClass?> getSessionByUserCubeName(
      int idUser, String sessionName, int? idCubeType) async {
    try {
      // CONSULTA PARA OBTENER LA SESION BASADA EN EL ID DEL USUARIO, EL NOMBRE DE LA SESION
      // Y TIPO DE CUBO
      final result = await supabase
          .from('sessiontime')
          .select()
          .eq('iduser', idUser)
          .eq('sessionname', sessionName)
          .eq('idcubetype', idCubeType!);

      if (result.isNotEmpty) {
        // SI SE ENCUENTRA LA SESION, SE MAPEA LOS DATOS Y SE DEVOLVE LA SESION
        final session = result.first;
        return SessionClass(
          idSession: session['idsession'] as int?,
          idUser: session['iduser'] as int,
          sessionName: session['sessionname'] as String,
          idCubeType: session['idcubetype'] as int,
          creationDate: session['creationdate'] as String,
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
  Future<SessionClass?> getSessionData(BuildContext context, int idUser) async {
    final sessionDaoSb = SessionDaoSb();
    final cubeTypeDaoSb = CubeTypeDaoSb();

    final currentSession = context.read<CurrentSession>().session;
    final currentCubeType = context.read<CurrentCubeType>().cubeType;

    if (currentSession == null || currentCubeType == null) {
      DatabaseHelper.logger.e("Sesión o tipo de cubo no encontrados.");
      return null;
    }

    final cubeType = await cubeTypeDaoSb.getCubeTypeByNameAndIdUser(
        currentCubeType.cubeName, idUser);
    return await sessionDaoSb.getSessionByUserCubeName(
        idUser, currentSession.sessionName, cubeType.idCube);
  }
}
