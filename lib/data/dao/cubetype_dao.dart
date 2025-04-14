import '../database/database_helper.dart';
import '../../model/cubetype.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre los **tipos de cubos**.
///
/// Esta clase permite interactuar con la base de datos para obtener, insertar,
/// eliminar o verificar la existencia de tipos de cubos. Utiliza la clase `DatabaseHelper`
/// para realizar las consultas y operaciones necesarias sobre la base de datos.
class CubeTypeDao {
  /// Método que obtiene todos los tipos de cubos desde la base de datos según el ID de usuario.
  ///
  /// Parámetros:
  /// - `idUser`: ID del usuario.
  ///
  /// Realiza una consulta para obtener todos los registros
  /// de la tabla 'cubeType'. Devuelve una lista de objetos `CubeType`.
  ///
  /// Retorna:
  /// - `List<CubeType>`: Lista de todos los tipos de cubos encontrados.
  Future<List<CubeType>> getCubeTypes(int idUser) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIPOS DE CUBOS
      final result = await db.query('cubeType', where: 'idUser = ?', whereArgs: [idUser]);
      // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS CubeType
      return result
          .map((map) => CubeType(
              idCube: map['idCubeType'] as int,
              cubeName: map['cubeName'] as String,
              idUser: map['idUser'] as int))
          .toList();
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener los tipos de cubos: $e");
      return []; // RETORNA UNA LISTA VACÍA EN CASO DE ERROR
    }
  } // METODO QUE DEVUELVE LOS TIPOS DE CUBO QUE HAY

  /// Método que obtiene un tipo de cubo por su nombre.
  ///
  /// Realiza una consulta a la base de datos para obtener un tipo de cubo específico
  /// según su nombre. Si no encuentra el cubo, devuelve un tipo de cubo con
  /// valores por defecto que indican un error.
  ///
  /// Parámetros:
  /// - `name`: Nombre del tipo de cubo a buscar.
  /// - `idUser`: ID del usuario.
  ///
  /// Retorna:
  /// - `CubeType`: El tipo de cubo encontrado o un cubo con valores de error.
  Future<CubeType> getCubeTypeByNameAndIdUser(String name, int? idUser) async {
    final db = await DatabaseHelper.database;
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final result = await db.query(
        'cubeType',
        where: 'cubeName = ? AND idUser = ?',
        whereArgs: [name, idUser],
      );

      if (result.isNotEmpty) {
        // CONVIERTE EL PRIMER RESULTADO EN UN OBJETO
        return CubeType(
            idCube: result.first['idCubeType'] as int,
            cubeName: result.first['cubeName'] as String,
            idUser: result.first['idUser'] as int);
      } else {
        // SI NO ENCUENTRA EL CUBO, DEVUELVE UN TIPO DE CUBO DE EROOR
        DatabaseHelper.logger.w("No se encontró ningún cubo con nombre: $name");
        return CubeType(idCube: -1, cubeName: "ErrorCube");
      } // SI LA CONSULTA NO ES NULA Y DEVUELVE UN RESULTADO
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al obtener el tipo de cubo por defecto: $e");
      // RETORNA UN ERROR TIPO DE CUBO EN CASO DE ERROR
      return CubeType(idCube: -1, cubeName: "ErrorCube");
    }
  } // METODO PARA BUSCAR UN TIPO DE CUBO POR SU NOMBER

  /// Método que verifica si un tipo de cubo con el nombre proporcionado ya
  /// existe en la base de datos.
  ///
  /// Realiza una consulta en la base de datos buscando un tipo de cubo por su nombre.
  /// Devuelve `true` si el cubo ya existe, o `false` si no se encuentra.
  ///
  /// Parámetros:
  /// - `name`: Nombre del tipo de cubo a verificar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el cubo ya existe, `false` si no existe.
  Future<bool> isExistsCubeTypeName(String name) async {
    final db = await DatabaseHelper.database;
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final result = await db.query(
        'cubeType',
        where: 'cubeName = ?',
        whereArgs: [name],
      );

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      } // SI EL RESULTADO ESTA O NO VACIO, DEVOLVERA TRUE/FALSE
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al obtener el tipo de cubo por defecto: $e");
      // RETORNA FALSE EN CASO DE ERROR
      return false;
    }
  } // METODO PARA SABER SI EL NOMBRE DE UN TIPO DE CUBO YA EXISTE

  /// Método para insertar un nuevo tipo de cubo en la base de datos.
  ///
  /// Inserta un nuevo tipo de cubo con el nombre proporcionado y el id de usuario asociado.
  ///
  /// Parámetros:
  /// - `name`: Nombre del nuevo tipo de cubo.
  /// - `idUser`: ID del usuario que está creando el tipo de cubo.
  ///
  /// Retorna:
  /// - `bool`: `true` si el tipo de cubo se insertó correctamente, `false` si ocurrió un error.
  Future<bool> insertNewType(String name, int idUser) async {
    final db = await DatabaseHelper.database;
    try {
      final result =
          await db.insert('cubeType', {'cubeName': name, 'idUser': idUser});

      if (result > 0) {
        return true; // SE INSERTO CORRECTAMENTE
      } else {
        return false; // NO SE INSERTO CORRECTAMENTE
      } // VERIFICAMOS SI SE HA INSERTADO CORRECTAMENTE
    } catch (e) {
      DatabaseHelper.logger.e("Error al insertar un nuevo tipo de cubo: $e");
      return false; // DEVUELVE FALSE EN CASO DE ERROR
    }
  } // METODO PARA INSERTAR UN NUEVO TIPO DE CUBO

  /// Método para eliminar un tipo de cubo por su nombre.
  ///
  /// Elimina un tipo de cubo existente en la base de datos utilizando el nombre proporcionado.
  ///
  /// Parámetros:
  /// - `cubeName`: Nombre del tipo de cubo que se quiere eliminar.
  /// - `idUser`: ID del usuario.
  ///
  /// Retorna:
  /// - `bool`: `true` si el tipo de cubo se eliminó correctamente, `false` si ocurrió un error.
  Future<bool> deleteCubeType(String cubeName, int? idUser) async {
    final db = await DatabaseHelper.database;
    try {
      // SE ELIMINA EL TIPO DE CUBO CON EL NOMBRE PROPORCIONADO
      final deleteCube = await db
          .delete('cubeType', where: 'cubeName = ? AND idUser = ?', whereArgs: [cubeName, idUser]);

      // DEVUELVE TRUE/FALSE SI SE ELIMINO CORRECTAMENTE O NO
      return deleteCube > 0;
    } catch (e) {
      DatabaseHelper.logger.e("Error al eliminar la tipo de cubo: $e");
      return false;
    }
  } // METODO PARA ELIMINAR UN TIPO DE CUBO POR SU NOMBRE

  /// Método que obtiene un tipo de cubo por su ID.
  ///
  /// Realiza una consulta a la base de datos para obtener un tipo de cubo específico
  /// basándose en su ID. Si no encuentra el cubo, devuelve un tipo de cubo con
  /// valores por defecto que indican un error.
  ///
  /// Parámetros:
  /// - `id`: ID del tipo de cubo a buscar.
  ///
  /// Retorna:
  /// - `CubeType`: El tipo de cubo encontrado o un cubo con valores de error.
  Future<CubeType> getCubeById(int id) async {
    final db = await DatabaseHelper.database;
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final result = await db.query(
        'cubeType',
        where: 'idCubeType = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        // CONVIERTE EL PRIMER RESULTADO EN UN OBJETO
        return CubeType(
            idCube: result.first['idCubeType'] as int,
            cubeName: result.first['cubeName'] as String,
            idUser: result.first['idUser'] as int);
      } else {
        // SI NO ENCUENTRA EL ID, DEVUELVE UN TIPO DE CUBO DE EROOR
        DatabaseHelper.logger.w("No se encontró ningún cubo con ese id: $id");
        return CubeType(idCube: -1, cubeName: "ErrorCube");
      } // SI LA CONSULTA NO ES NULA Y DEVUELVE UN RESULTADO
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al obtener el tipo de cubo por su id: $e");
      // RETORNA UN ERROR TIPO DE CUBO EN CASO DE ERROR
      return CubeType(idCube: -1, cubeName: "ErrorCube");
    }
  } // METODO PARA BUSCAR UN TIPO DE CUBO POR SU ID
}
