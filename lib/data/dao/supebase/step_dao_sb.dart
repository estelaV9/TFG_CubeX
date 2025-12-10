import 'package:esteladevega_tfg_cubex/model/learn_guide/step.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../database/database_helper.dart';

/// Clase encargada de gestionar las operaciones CRUD sobre los **pasos**
/// de un metodo de cubo en Supabase.
///
/// Esta clase por ahora permite obtener una lista de pasos del metodo seleccionado.
class StepDaoSb {
  final SupabaseClient _client = Supabase.instance.client;

  /// Obtiene la lista de **pasos** asociados al metodo indicado por su ID.
  ///
  /// Parametros:
  /// - [idMethod]: ID del metodo del cual se quieren obtener los pasos.
  ///
  /// Retorna:
  /// - Una lista de objetos [Step] con los datos obtenidos desde la tabla `step`.
  /// - Una lista vacia en caso de error o si no se encuentran pasos para el metodo.
  Future<List<Step>> getStepsOfMethod(int idMethod) async {
    try {
      // CONSULTA PARA OBTENER TODOS LOS PASOS DEL METODO SELECCIONADO
      final response =
          await _client.from('step').select().eq('idmethod', idMethod);

      // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS Step
      return response
          .map((map) => Step(
                idStep: map['idstep'] as int,
                stepTitle: map['steptitle'] as String,
                stepNumber: map['stepnumber'] as int,
                idMethod: map['idmethod'] as int,
              ))
          .toList();
    } catch (e) {
      DatabaseHelper.logger.e("Error al obtener la lista de pasos: $e");
      return []; // RETORNA UNA LISTA VACÍA EN CASO DE ERROR
    }
  } // METODO QUE DEVUELVE LOS PASOS DEL METODO QUE HAY
}
