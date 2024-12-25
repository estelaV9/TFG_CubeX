import 'package:esteladevega_tfg_cubex/utilities/alert.dart';
import 'package:flutter/cupertino.dart';

import '../database/database_helper.dart';

class UserDao {
  Future<bool> validateLogin(String field, String value, String password, BuildContext context) async {
    final db = await DatabaseHelper.database;
    final result;
    try {
      // VERIFICAR SI EL USUARIO/MAIL Y LA CONTRASEA COINCIDAN
      result = await db.query(
        'user',
        where: '$field = ? AND passwordHash = ?',
        whereArgs: [value, password],
      );
    } catch (e) {
      //AlertUtil.showAlert("Database error", "$e", context);
      return false;
    }

    return result.isNotEmpty;
  } // METODO PARA VALIDAR EL LOGIN DEL USUARIO CON EL NOMBRE O MAIL DE USUARIO
}
