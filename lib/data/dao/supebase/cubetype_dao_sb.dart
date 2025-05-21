import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../model/cubetype.dart';
import '../../database/database_helper.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre los **tipos de cubos**
/// en Supabase.
///
/// Esta clase permite interactuar con la base de datos para obtener, insertar,
/// eliminar o verificar la existencia de tipos de cubos.
class CubeTypeDaoSb {
  final SupabaseClient _client = Supabase.instance.client;

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
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIPOS DE CUBOS
      final response =
          await _client.from('cubetype').select().eq('iduser', idUser);

      // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS CubeType
      return response
          .map((map) => CubeType(
                idCube: map['idcubetype'] as int,
                cubeName: map['cubename'] as String,
                idUser: map['iduser'] as int,
              ))
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
  Future<CubeType> getCubeTypeByNameAndIdUser(String name, int idUser) async {
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final response = await _client
          .from('cubetype')
          .select()
          .eq('cubename', name)
          .eq('iduser', idUser)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        // CONVIERTE EL PRIMER RESULTADO EN UN OBJETO
        return CubeType(
          idCube: response['idcubetype'] as int,
          cubeName: response['cubename'] as String,
          idUser: response['iduser'] as int,
        );
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
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final response = await _client
          .from('cubetype')
          .select('idcubetype')
          .eq('cubename', name)
          .limit(1)
          .maybeSingle();

      // DEVUELVE TRUE O FALSE DEPENDIENDO SI ESTA VACIO O NO
      return response != null;
    } catch (e) {
      DatabaseHelper.logger
          .e("Error al verificar si existe el nombre del tipo de cubo: $e");
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
    try {
      await _client
          .from('cubetype')
          .insert({'cubename': name, 'iduser': idUser});

      // DEVUELVE TRUE SI NO OCURRIO NINGUN ERROR
      return true;
    } catch (e) {
      DatabaseHelper.logger.e('Error al insertar nuevo tipo: $e');
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
  Future<bool> deleteCubeType(String cubeName, int idUser) async {
    try {
      // SE ELIMINA EL TIPO DE CUBO CON EL NOMBRE PROPORCIONADO
      final response = await _client
          .from('cubetype')
          .delete()
          .eq('cubename', cubeName)
          .eq('iduser', idUser)
          .select();

      // DEVUELVE TRUE/FALSE SI SE ELIMINO CORRECTAMENTE O NO
      return response.isNotEmpty;
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
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final response = await _client
          .from('cubetype')
          .select()
          .eq('idcubetype', id)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        // CONVIERTE EL PRIMER RESULTADO EN UN OBJETO
        return CubeType(
          idCube: response['idcubetype'] as int,
          cubeName: response['cubename'] as String,
          idUser: response['iduser'] as int,
        );
      } else {
        // SI NO ENCUENTRA EL ID, DEVUELVE UN TIPO DE CUBO DE EROOR
        DatabaseHelper.logger.w("No se encontró ningún cubo con ese id: $id");
        return CubeType(idCube: -1, cubeName: "ErrorCube");
      } // SI LA CONSULTA NO ES NULA Y DEVUELVE UN RESULTADO
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener el tipo de cubo por su id: $e");
      // RETORNA UN ERROR TIPO DE CUBO EN CASO DE ERROR
      return CubeType(idCube: -1, cubeName: "ErrorCube");
    }
  } // METODO PARA BUSCAR UN TIPO DE CUBO POR SU ID
}
