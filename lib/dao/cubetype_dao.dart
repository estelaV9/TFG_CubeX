import '../database/database_helper.dart';
import '../model/cubetype.dart';

class CubeTypeDao {
  Future<List<CubeType>> getCubeTypes() async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIPOS DE CUBOS
      final result = await db.query('cubeType');
      // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS CubeType
      return result
          .map((map) =>
              CubeType(map['idCubeType'] as int, map['cubeName'] as String))
          .toList();
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener los tipos de cubos: $e");
      return []; // RETORNA UNA LISTA VACÍA EN CASO DE ERROR
    }
  } // METODO QUE DEVUELVE LOS TIPOS DE CUBO QUE HAY

  Future<CubeType> cubeTypeDefault(String name) async {
    final db = await DatabaseHelper.database;
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final result = await db.query(
        'cubeType',
        where: 'cubeName = ?',
        whereArgs: [name],
      );

      if (result.isNotEmpty) {
        // CONVIERTE EL PRIMER RESULTADO EN UN OBJETO
        return CubeType(result.first['idCubeType'] as int,
            result.first['cubeName'] as String);
      } else {
        // SI NO ENCUENTRA EL CUBO, DEVUELVE UN TIPO DE CUBO DE EROOR
        return CubeType(-1, "ErrorCube");
      } // SI LA CONSULTA NO ES NULA Y DEVUELVE UN RESULTADO
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al obtener el tipo de cubo por defecto: $e");
      // RETORNA UN ERROR TIPO DE CUBO EN CASO DE ERROR
      return CubeType(-1, "ErrorCube");
    }
  } // METODO PARA BUSCAR UN TIPO DE CUBO POR SU NOMBER

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

  Future<bool> insertNewType(String name) async {
    final db = await DatabaseHelper.database;
    try {
      final result = await db.insert('cubeType', {'cubeName': name});

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
}
