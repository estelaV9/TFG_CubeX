import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class UserDao {
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
}
