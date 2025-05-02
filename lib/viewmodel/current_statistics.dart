import 'package:flutter/cupertino.dart';
import '../data/dao/time_training_dao.dart';
import '../model/time_training.dart';

/// Provider para gestionar las **estadísticas de tiempos** en la aplicación.
///
/// Permite actualizar la lista de tiempos y obtener estadísticas como:
/// - El mejor tiempo (PB).
/// - El peor tiempo.
/// - El total de tiempos registrados en una sesión.
/// - La media de x tiempos de una sesión.
class CurrentStatistics extends ChangeNotifier {
  List<TimeTraining> _timesList = [];

  /// Obtiene la lista de tiempos de la sesión.
  List<TimeTraining> get timesList => _timesList;

  /// Actualiza la lista de tiempos y notifica a los listeners.
  void updateStatistics({required List<TimeTraining> timesListUpdate}) {
    _timesList = timesListUpdate;
    notifyListeners();
  } // ACTUALIZA LA LISTA DE TIEMPOS

  /// Obtiene el **mejor tiempo (PB)** de la sesión actual.
  ///
  /// Llama al método DAO de tiempos `getPbTimeBySession(timesList)`
  /// y retorna el mejor tiempo.
  ///
  /// Parámetros:
  /// - `isDnf` (opcional): Atributo para saber si ha puesto un DNF al tiempo actual.
  Future<String> getPbValue([bool isDnf = false]) async {
    return await TimeTrainingDao().getPbTimeBySession(_timesList, isDnf);
  } // OBTIENE EL PB DE TODOS LOS TIEMPOS DE LA SESION

  /// Obtiene el **peor tiempo** de la sesión actual.
  ///
  /// Llama al método DAO de tiempos `getWorstTimeBySession(timesList)`
  /// y retorna el peor tiempo.
  ///
  /// Parámetros:
  /// - `isDnf` (opcional): Atributo para saber si ha puesto un DNF al tiempo actual.
  Future<String> getWorstValue([bool isDnf = false]) async {
    return await TimeTrainingDao().getWorstTimeBySession(_timesList, isDnf);
  } // OBTIENE EL PEOR TIEMPO DE TODOS LOS TIEMPOS DE LA SESION

  /// Obtiene la **cantidad total de tiempos registrados** en la sesión actual.
  ///
  /// Llama al método DAO de tiempos `getCountBySession(timesList)`
  /// y retorna el número de tiempos que hay en una sesión.
  Future<String> getCountValue() async {
    int count = await TimeTrainingDao().getCountBySession(_timesList);
    return count.toString();
  } // METODO PARA OBTENER EL TOTAL DE TIEMPOS EN LA SESION


  /// Obtiene la **media de X tiempos (AoX)** de la sesión actual.
  ///
  /// Este método utiliza la función `getAoX()` del DAO para calcular la media
  /// de los **X tiempos más recientes**, eliminando el mejor y peor tiempo.
  ///
  /// Parámetros:
  /// - `numAvg`: Número de tiempos para calcular la media.
  ///
  /// Retorna:
  /// - Media de tiempos en formato `"mm:ss.ss"` si hay suficientes tiempos.
  /// - `"--:--.--"` si no hay suficientes tiempos para calcular la media.
  Future<String> getAoXValue(int numAvg) async {
    return await TimeTrainingDao().getAoX(_timesList, numAvg);
  } // METODO AUXILIAR OBTENER LA MEDIA DE LOS X TIEMPOS DE LA SESION

  /// Obtiene la **peor media** de X tiempos de la sesión actual.
  ///
  /// Este método utiliza la función `getWorstAvg()` del DAO para calcular la **peor media**
  /// de los **X tiempos más recientes**, eliminando el mejor y el peor tiempo,
  /// y calculando la media de los tiempos restantes.
  ///
  /// Parámetros:
  /// - `numAvg`: Número de tiempos para calcular la media (peor media).
  ///
  /// Retorna:
  /// - **String**: La peor media en formato `"mm:ss.ss"` si hay suficientes tiempos.
  ///   - `"--:--.--"` si no hay suficientes tiempos para calcular la media.
  Future<String> getWorstAvgValue(int numAvg) async {
    return await TimeTrainingDao().getWorstAvg(_timesList, numAvg);
  } // METODO AUXILIAR OBTENER LA PEOR MEDIA DE LOS X TIEMPOS DE LA SESION

  /// Obtiene la **mejor media** de X tiempos de la sesión actual.
  ///
  /// Este método utiliza la función `getBestAvg()` del DAO para calcular la **mejor media**
  /// de los **X tiempos más recientes**, eliminando el mejor y el peor tiempo,
  /// y calculando la media de los tiempos restantes.
  ///
  /// Parámetros:
  /// - `numAvg`: Número de tiempos para calcular la media (mejor media).
  ///
  /// Retorna:
  /// - **String**: La mejor media en formato `"mm:ss.ss"` si hay suficientes tiempos.
  ///   - `"--:--.--"` si no hay suficientes tiempos para calcular la media.
  Future<String> getBestAvgValue(int numAvg) async {
    return await TimeTrainingDao().getBestAvg(_timesList, numAvg);
  } // METODO AUXILIAR OBTENER LA MEJOR MEDIA DE LOS X TIEMPOS DE LA SESION

  /// Obtiene la **Average of 5 (Ao5)** de los tiempos más recientes.
  ///
  /// Calcula la media de los últimos **5 tiempos registrados**, eliminando
  /// el mejor y peor tiempo.
  ///
  /// Retorna:
  /// - `"mm:ss.ss"` si hay al menos 5 tiempos.
  /// - `"--:--.--"` si hay menos de 5 tiempos.
  Future<String> getAo5Value() async {
    return await getAoXValue(5);
  } // OBTIENE LA MEDIA DE LOS 5 TIEMPOS MAS RECIENTES

  /// Obtiene la **Average of 12 (Ao12)** de los tiempos más recientes.
  ///
  /// Calcula la media de los últimos **12 tiempos registrados**, eliminando
  /// el mejor y peor tiempo.
  ///
  /// Retorna:
  /// - `"mm:ss.ss"` si hay al menos 12 tiempos.
  /// - `"--:--.--"` si hay menos de 12 tiempos.
  Future<String> getAo12Value() async {
    return await getAoXValue(12);
  } // OBTENER LA MEDIA DE LOS 12 TIEMPOS MAS RECIENTES

  /// Obtiene la **Average of 50 (Ao50)** de los tiempos más recientes.
  ///
  /// Calcula la media de los últimos **50 tiempos registrados**, eliminando
  /// el mejor y peor tiempo.
  ///
  /// Retorna:
  /// - `"mm:ss.ss"` si hay al menos 50 tiempos.
  /// - `"--:--.--"` si hay menos de 50 tiempos.
  Future<String> getAo50Value() async {
    return await getAoXValue(50);
  } // METODO PARA OBTENER LA MEDIA DE LOS 50 TIEMPOS MAS RECIENTES

  /// Obtiene la **Average of 100 (Ao100)** de los tiempos más recientes.
  ///
  /// Calcula la media de los últimos **100 tiempos registrados**, eliminando
  /// el mejor y peor tiempo.
  ///
  /// Retorna:
  /// - `"mm:ss.ss"` si hay al menos 100 tiempos.
  /// - `"--:--.--"` si hay menos de 100 tiempos.
  Future<String> getAo100Value() async {
    return await getAoXValue(100);
  } // METODO PARA OBTENER LA MEDIA DE LOS 100 TIEMPOS MAS RECIENTES
}