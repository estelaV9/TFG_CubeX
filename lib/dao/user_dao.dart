import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:flutter/cupertino.dart';

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
}
