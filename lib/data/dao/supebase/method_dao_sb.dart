import 'package:esteladevega_tfg_cubex/model/learn_guide/method.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../database/database_helper.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre los **metodos**
/// de un tipo de cubo en Supabase.
///
/// Esta clase por ahora permite obtener los metodos guardados en la base de datos.
class MethodDaoSb {
  final SupabaseClient _client = Supabase.instance.client;

  /// Método que obtiene todos los metodos de un cubo segun el nombre del cubo.
  ///
  /// Parámetros:
  /// - `cubeTypeName`: Nombre del cubo.
  ///
  /// Realiza una consulta para obtener todos los registros
  /// de la tabla 'method'. Devuelve una lista de objetos `Method`.
  ///
  /// Retorna:
  /// - `List<Method>`: Lista de todos los metodos encontrados.
  Future<List<Method>> getMethods(String cubeTypeName) async {
    try {
      // CONSULTA PARA OBTENER TODOS LOS METODOS DEL CUBO
      final response = await _client
          .from('method')
          .select()
          .eq('cubetypename', cubeTypeName);

      // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS Method
      return response
          .map((map) => Method(
                idMethod: map['idmethod'] as int,
                methodName: map['methodname'] as String,
                cubeTypeName: map['cubetypename'] as String,
              ))
          .toList();
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener los metodos: $e");
      return []; // RETORNA UNA LISTA VACÍA EN CASO DE ERROR
    }
  } // METODO QUE DEVUELVE LOS METODOS QUE HAY EN UN TIPO DE CUBO

  /// Método para insertar un nuevo método asociado a un tipo de cubo.
  ///
  /// Parámetros:
  /// - `name`: Nombre del nuevo metodo.
  /// - `cubeTypeName`: Nombre del cubo que está asociado al metodo.
  ///
  /// Retorna:
  /// - `bool`: `true` si el metodo se insertó correctamente, `false` si ocurrió un error.
  Future<bool> insertNewMethod(String name, String cubeTypeName) async {
    try {
      final response = await _client.from('method').insert({
        'methodname': name,
        'cubetypename': cubeTypeName,
      }).select();

      if (response.isEmpty) {
        // DEVUELVE FALSE SI NO SE INSERTO NADA
        return false;
      }

      // DEVUELVE TRUE SI SE INSERTO CORRECTAMENTE
      return true;
    } catch (e) {
      DatabaseHelper.logger.e('Error al insertar nuevo metodo: $e');
      return false; // DEVUELVE FALSE EN CASO DE ERROR
    }
  } // METODO PARA INSERTAR UN NUEVO METODO

  /// Obtiene el **ID del metodo** segun su nombre y el tipo de cubo.
  ///
  /// Parametros:
  /// - [methodName]: nombre del metodo (sin traducir)
  /// - [cubeName]: nombre del cubo al que pertenece el metodo
  ///
  /// Retorna:
  /// - El ID del metodo si existe.
  /// - `-1` si no se encontro ningun registro o si ocurre un error.
  Future<int> getIdByNameAndCube(String methodName, String cubeName) async {
    try {
      // CONSULTA PARA OBTENER EL ID DEL METODO DEL CUBO
      final response = await _client
          .from('method')
          .select('idmethod')
          .eq('methodname', methodName)
          .eq('cubetypename', cubeName)
          .maybeSingle();

      if (response != null) {
        return response['idmethod'];
      } // SI NO ES NULO, RETORNA EL ID

      // DEVUELVE -1 SI NO SE ENCONTRO NADA
      return -1;
    } catch (e) {
      DatabaseHelper.logger.e('Error al buscar ID por nombre del metodo: $e');
      return -1; // DEVUELVE -1 EN CASO DE ERROR
    }
  }
}