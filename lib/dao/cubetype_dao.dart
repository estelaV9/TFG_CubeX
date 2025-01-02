import '../database/database_helper.dart';
import '../model/cubetype.dart';

class CubeTypeDao {
  Future<List<CubeType>> getCubeTypes() async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIPOS DE CUBOS
      final result = await db.query('cubeType');
      // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS CubeType
      return result.map((map) => CubeType(map['cubeName'] as String)).toList();
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

      return CubeType(result.first['cubeName'] as String);
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al obtener el tipo de cubo por defecto: $e");
      return CubeType(
          "ErrorCube"); // RETORNA UN ERROR TIPO DE CUBO EN CASO DE ERROR
    }
  } // METODO PARA BUSCAR UN TIPO DE CUBO POR SU NOMBER
}
