import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:flutter/cupertino.dart';

import '../database/database_helper.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre los **usuarios**.
///
/// Esta clase permite validar, insertar, eliminar
/// y verificar la existencia de usuarios. Utiliza la clase `DatabaseHelper` para realizar
/// las consultas y operaciones necesarias sobre la base de datos.
class UserDao {
  /// Método que valida el login de un usuario utilizando su nombre de usuario
  /// o correo y contraseña.
  ///
  /// Realiza una consulta en la base de datos para verificar si existe un usuario
  /// con el nombre de usuario o correo proporcionado y si la contraseña coincide
  /// con la almacenada.
  ///
  /// Parámetros:
  /// - `value`: Puede ser el nombre de usuario o el correo del usuario.
  /// - `password`: La contraseña que se desea verificar.
  ///
  /// Retorna:
  /// - `bool`: `true` si las credenciales son correctas, `false` si no.
  Future<bool> validateLogin(String value, String password) async {
    final db = await DatabaseHelper.database;
    try {
      final List<Map<String, Object?>> result = await db.query(
        'user',
        where: '(username = ? OR mail = ?) AND passwordHash = ?',
        whereArgs: [value, value, password],
      ); // VERIFICAR SI EL USUARIO/MAIL Y LA CONTRASEA COINCIDAN
      return result.isNotEmpty;
    } catch (e) {
      debugPrint("error al validar el login: $e");
      //AlertUtil.showAlert("Database error", "$e", context);
      return false;
    }
  } // METODO PARA VALIDAR EL LOGIN DEL USUARIO CON EL NOMBRE O MAIL DE USUARIO

  /// Método para insertar un nuevo usuario en la base de datos.
  ///
  /// Inserta un nuevo usuario con la información proporcionada en la tabla 'user'.
  ///
  /// Parámetros:
  /// - `user`: El objeto [User] que contiene la información del nuevo usuario.
  ///
  /// Retorna:
  /// - `bool`: `true` si el usuario fue insertado correctamente, `false` si ocurrió un error.
  Future<bool> insertUser(User user) async {
    final db = await DatabaseHelper.database;
    try {
      await db.insert('user', {
        'username': user.username,
        'mail': user.mail,
        'passwordHash': user.password,
        'creationDate': user.creationDate,
        'imageUrl': user.imageUrl,
      }); // SE INSERTA EL USUARIO

      DatabaseHelper.logger.i(user.toString());
      return true;
    } catch (e) {
      DatabaseHelper.logger.w("Error al crear usuario: $e");
      return false;
    } // try-catch
  } // METODO PARA INSERTAR UN USUARIO

  /// Método que verifica si un usuario con el nombre de usuario proporcionado
  /// ya existe en la base de datos.
  ///
  /// Parámetros:
  /// - `username`: El nombre de usuario que se desea verificar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el nombre de usuario ya existe, `false` si no existe.
  Future<bool> isExistsUsername(String username) async {
    final db = await DatabaseHelper.database;
    try {
      final List<Map<String, Object?>> result = await db.query(
        'user',
        where: 'username = ?',
        whereArgs: [username],
      ); // VERIFICAR SI EL USUARIO EXISTE

      // SI DEVUELVE UN RESULT ES QUE EXISTE UN USUARIO CON ESE NOMBRE
      return result.isNotEmpty;
    } catch (e) {
      DatabaseHelper.logger.w("Error al buscar nombre de usuario: $e");
      return false;
    }
  } // METODO PARA COMPRABAR SI EXISTE UN USUARIO CON ESE NOMBRE (ya que es un campo unico)

  /// Método que verifica si un usuario con el correo electrónico proporcionado
  /// ya existe en la base de datos.
  ///
  /// Parámetros:
  /// - `mail`: El correo electrónico que se desea verificar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el correo ya existe, `false` si no existe.
  Future<bool> isExistsEmail(String mail) async {
    final db = await DatabaseHelper.database;
    try {
      final List<Map<String, Object?>> result = await db.query(
        'user',
        where: 'mail = ?',
        whereArgs: [mail],
      ); // VERIFICAR SI EL MAIL EXISTE

      // SI DEVUELVE UN RESULT ES QUE EXISTE UN USUARIO CON ESE MAIL
      return result.isNotEmpty;
    } catch (e) {
      DatabaseHelper.logger.w("Error al buscar mail de usuario: $e");
      return false;
    }
  } // METODO PARA COMPRABAR SI EXISTE UN USUARIO CON ESE MAIL (ya que es un campo unico)

  /// Método que obtiene el ID de un usuario basado en su nombre de usuario.
  ///
  /// Parámetros:
  /// - `name`: El nombre de usuario cuyo ID se desea obtener.
  ///
  /// Retorna:
  /// - `int`: El ID del usuario si se encuentra, `-1` si no se encuentra el usuario.
  Future<int> getIdUserFromName (String name) async {
    final db = await DatabaseHelper.database;
    try {
      final idUser = await db.query(
        'user',
        where: 'username = ?',
        whereArgs: [name]
      );

      if(idUser.isNotEmpty){
        return idUser.first['idUser'] as int;
      } else {
        return -1;
      } // SI NO ESTA VACIO, RETORNA EL ID, SI NO DEVUELVE -1

    } catch(e){
      DatabaseHelper.logger.e("Error al buscar el id de usuario por nombre: $e");
      return -1;
    }
  } // METODO PARA DEVOLVER EL ID POR NOMBRE DE USUARIO

  /// Método que obtiene el correo electrónico de un usuario basado en su nombre de usuario.
  ///
  /// Parámetros:
  /// - `name`: El nombre de usuario cuyo correo se desea obtener.
  ///
  /// Retorna:
  /// - `String`: El correo electrónico del usuario si se encuentra, o una cadena
  /// vacía si no se encuentra.
  Future<String> getMailUserFromName (String name) async {
    final db = await DatabaseHelper.database;
    try {
      final idUser = await db.query(
          'user',
          where: 'username = ?',
          whereArgs: [name]
      );

      if(idUser.isNotEmpty){
        return idUser.first['mail'] as String;
      } else {
        return "";
      } // SI NO ESTA VACIO, RETORNA EL MAIL, SI NO DEVUELVE ""

    } catch(e){
      DatabaseHelper.logger.e("Error al buscar el mail de usuario por nombre: $e");
      return "";
    }
  } // METODO PARA DEVOLVER EL MAIL POR NOMBRE DE USUARIO

  /// Método que elimina un usuario de la base de datos basado en su ID.
  ///
  /// Parámetros:
  /// - `idUser`: El ID del usuario que se desea eliminar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el usuario fue eliminado correctamente, `false`
  /// si ocurrió un error.
  Future<bool> deleteUser(int idUser) async {
    final db = await DatabaseHelper.database;
    try {
      // SE ELIMINA EL USUARIO CON EL ID PROPORCIONADO
      final deleteTime = await db.delete('user',
          where: 'idUser = ?', whereArgs: [idUser]);

      // DEVUELVE TRUE/FALSE SI SE ELIMINO CORRECTAMENTE O NO
      return deleteTime > 0;
    } catch (e) {
      // RETORNA FALSE Y UN MENSAJE SI OCURRE UN ERROR
      DatabaseHelper.logger.e("Error al eliminar el usuario: $e");
      return false;
    }
  } // METODO PARA ELIMINAR UN USUARIO POR EL ID DEL TIEMPO
}
