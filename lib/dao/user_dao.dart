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
}
