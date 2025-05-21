import 'dart:io';

import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:esteladevega_tfg_cubex/model/user.dart';

import '../../../viewmodel/current_user.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre los **usuarios**.
///
/// Esta clase permite validar, insertar, eliminar
/// y verificar la existencia de usuarios. Utiliza supabase para realizar
/// las consultas y operaciones necesarias sobre la base de datos.
class UserDaoSb {
  final supabase = Supabase.instance.client;

  /// Método para insertar un nuevo usuario en la base de datos.
  ///
  /// Inserta un nuevo usuario con la información proporcionada en la tabla 'user'.
  ///
  /// Parámetros:
  /// - `user`: El objeto [User] que contiene la información del nuevo usuario.
  ///
  /// Retorna:
  /// - `bool`: `true` si el usuario fue insertado correctamente, `false` si ocurrió un error.
  Future<bool> insertUser(UserClass user) async {
    try {
      await supabase.from('user').insert({
        'username': user.username,
        'mail': user.mail,
        'passwordhash': user.password,
        'creationdate': user.creationDate,
        'imageurl': user.imageUrl,
        'useruuid': user.userUUID,
      });

      DatabaseHelper.logger.i("Usuario insertado correctamente");
      return true;
    } catch (e) {
      DatabaseHelper.logger.e("Error al insertar usuario: $e");
      return false;
    }
  }

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
    try {
      final result = await supabase
          .from('user')
          .select()
          .or('username.eq.$value')
          .eq('passwordhash', password)
          .maybeSingle();

      DatabaseHelper.logger.i(result.toString());

      return result != null;
    } catch (e) {
      DatabaseHelper.logger.e("Error al validar login: $e");
      return false;
    }
  }

  /// Método que verifica si un usuario con el nombre de usuario proporcionado
  /// ya existe en la base de datos.
  ///
  /// Parámetros:
  /// - `username`: El nombre de usuario que se desea verificar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el nombre de usuario ya existe, `false` si no existe.
  Future<bool> isExistsUsername(String username) async {
    try {
      final response = await Supabase.instance.client
          .from('user')
          .select()
          .eq('username', username)
          .maybeSingle(); // USAR maybeSingle PARA MANEJAR CERO O MAS RESULTADOS

      if (response != null) {
        // SI ENCUENTRA, RETORNA TRUE
        DatabaseHelper.logger.i('Usuario encontrado: ${response['username']}');
        return true;
      } else {
        // SI ES NULO, RETORNA FALSE
        return false;
      }
    } catch (e) {
      DatabaseHelper.logger.e("Error al verificar username: $e");
      return false;
    }
  }

  /// Método que verifica si un usuario con el correo electrónico proporcionado
  /// ya existe en la base de datos.
  ///
  /// Parámetros:
  /// - `mail`: El correo electrónico que se desea verificar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el correo ya existe, `false` si no existe.
  Future<bool> isExistsEmail(String email) async {
    try {
      final result = await supabase
          .from('user')
          .select('iduser')
          .eq('mail', email)
          .maybeSingle();

      return result != null;
    } catch (e) {
      DatabaseHelper.logger.e("Error al verificar mail: $e");
      return false;
    }
  }

  /// Método que obtiene el ID de un usuario basado en su nombre de usuario.
  ///
  /// Parámetros:
  /// - `name`: El nombre de usuario cuyo ID se desea obtener.
  ///
  /// Retorna:
  /// - `int`: El ID del usuario si se encuentra, `-1` si no se encuentra el usuario.
  Future<int> getIdUserFromName(String name) async {
    try {
      final result = await supabase
          .from('user')
          .select('iduser')
          .eq('username', name)
          .maybeSingle();

      if (result != null) {
        return result['iduser'];
      }
      return -1;
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener id del usuario: $e");
      return -1;
    }
  }

  /// Método que obtiene el correo electrónico de un usuario basado en su nombre de usuario.
  ///
  /// Parámetros:
  /// - `name`: El nombre de usuario cuyo correo se desea obtener.
  ///
  /// Retorna:
  /// - `String`: El correo electrónico del usuario si se encuentra, o una cadena
  /// vacía si no se encuentra.
  Future<String?> getMailUserFromName(String name) async {
    try {
      final result = await supabase
          .from('user')
          .select('mail')
          .eq('username', name)
          .maybeSingle();

      return result?['mail'];
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener mail: $e");
      return null;
    }
  }

  /// Método que elimina un usuario de la base de datos basado en su ID.
  ///
  /// Parámetros:
  /// - `idUser`: El ID del usuario que se desea eliminar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el usuario fue eliminado correctamente, `false`
  /// si ocurrió un error.
  Future<bool> deleteUser(int idUser) async {
    try {
      final result =
          await supabase.from('user').delete().eq('iduser', idUser).select();

      return result.isNotEmpty;
    } catch (e) {
      DatabaseHelper.logger.e("Error al eliminar usuario: $e");
      return false;
    }
  }

  /// Método que actualizar la información de un usuario de la base de datos basado en su ID.
  ///
  /// Parámetros:
  /// - `user`: El usuario con los datos nuevos a actualizar.
  /// - `idUser`: El ID del usuario al que se desea actualiza la información.
  ///
  /// Retorna:
  /// - `bool`: `true` si se actualizó al menos una fila, `false`
  /// si ocurrió un error.
  Future<bool> updateUserInfo(UserClass user, int idUser) async {
    try {
      // SE VERIFICA SI EL USUARIO EXISTE
      final existingUser =
          await supabase.from('user').select().eq('iduser', idUser);

      if (existingUser.isEmpty) {
        DatabaseHelper.logger.e("No se encontró usuario con ID: $idUser");
        return false;
      }

      // SE ACTUALIZA
      final response = await supabase
          .from('user')
          .update({
            'username': user.username,
            'passwordhash': user.password,
            'imageurl': user.imageUrl,
          })
          .eq('iduser', idUser)
          .select();

      DatabaseHelper.logger.i("Respuesta de actualización: $response");

      return response.isNotEmpty;
    } catch (e) {
      DatabaseHelper.logger.e("Error al actualizar usuario: $e");
      return false;
    }
  }

  /// Método que conseguir la imagen de un usuario de la base de datos basado en su ID.
  ///
  /// Parámetros:
  /// - `idUser`: El ID del usuario que se desea conseguir su foto.
  ///
  /// Retorna:
  /// - `String?`: `url` si los datos han sido correctos y, `null`
  /// si ocurrió un error o no se encontró en la query.
  Future<String?> getImageUser(int idUser) async {
    try {
      final result = await supabase
          .from('user')
          .select('imageurl')
          .eq('iduser', idUser)
          .maybeSingle();

      return result?['imageurl'];
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener imagen: $e");
      return null;
    }
  }

  /// Método para obtener el ID del usuario actual a partir del nombre de usuario guardado en el estado global.
  ///
  /// Devuelve el ID del usuario si se encuentra correctamente.
  /// Si ocurre un error o no hay usuario activo, devuelve `null` y registra el error en consola.
  ///
  /// Retorna un [Future<int?>] con el ID o `null`.
  Future<int?> getUserId(BuildContext context) async {
    final currentUser = context.read<CurrentUser>().user;

    if (currentUser == null || currentUser.username.isEmpty) {
      DatabaseHelper.logger.e("Usuario no encontrado.");
      return null;
    }

    try {
      final response = await supabase
          .from('user')
          .select()
          .eq('username', currentUser.username);

      if (response.isEmpty) {
        DatabaseHelper.logger.e("No se encontró usuario con ese username.");
        return -1;
      }

      return response.first['iduser'] as int;
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al obtener el ID del usuario desde Supabase: $e");
      return null;
    }
  }

  /// Método que obtiene los datos de un usuario a partir de su nombre de usuario.
  ///
  /// Este método consulta la base de datos Supabase buscando un usuario
  /// cuyo nombre de usuario coincida con el proporcionado.
  ///
  /// Parámetros:
  /// - `name`: Nombre de usuario (`username`) a buscar.
  ///
  /// Retorna:
  /// - `UserClass?`: Una instancia de `UserClass` si se encuentra el usuario,
  /// o `null` si no se encuentra o si ocurre un error durante la consulta.
  Future<UserClass?> getUserFromName(String name) async {
    try {
      final result = await supabase
          .from('user')
          .select()
          .eq('username', name)
          .maybeSingle();

      if (result != null) {
        final user = result;
        UserClass nsjakf = UserClass(
          idUser: user['iduser'] as int?,
          username: user['username'] as String,
          mail: user['mail'] as String,
          password: user['passwordhash'] as String,
          creationDate: user['creationdate'].toString(),
          imageUrl: user['imageurl'] as String?,
          userUUID: result['useruuid'] as String?,
        );

        DatabaseHelper.logger.i(nsjakf.toString());
        return nsjakf;
      }
      return null;
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener mail: $e");
      return null;
    }
  }

  /// Método que sube una imagen al bucket de almacenamiento de Supabase.
  ///
  /// Utiliza el bucket `avatars` y guarda el archivo en la carpeta `users/` con el nombre especificado.
  ///
  /// Parámetros:
  /// - `file`: Archivo de imagen a subir.
  /// - `fileName`: Nombre con el que se guardará el archivo en el bucket.
  ///
  /// Retorna:
  /// - `String?`: URL pública del archivo si la subida fue exitosa,
  /// o `null` si ocurrió algún error durante la operación.
  Future<String?> uploadImage(File file, String fileName) async {
    try {
      final fileBytes = await file.readAsBytes();
      final mimeType = lookupMimeType(file.path);

      final response = await supabase.storage.from('avatars').uploadBinary(
            'users/$fileName',
            fileBytes,
            fileOptions: FileOptions(contentType: mimeType),
          );

      if (response.isEmpty) return null;

      return supabase.storage.from('avatars').getPublicUrl('users/$fileName');
    } catch (e) {
      DatabaseHelper.logger.e("Error al subir imagen: $e");
      return null;
    }
  }
}
