import 'package:esteladevega_tfg_cubex/model/time_training.dart';

import '../database/database_helper.dart';

/// Clase encargada de gestionar las operaciones CRUD y estadísticas sobre los **tiempos de entrenamiento**.
///
/// Esta clase interactúa con la base de datos para insertar, eliminar, obtener y
/// calcular estadísticas relacionadas con los tiempos en las sesiones.
class TimeTrainingDao {
  /// Método para obtener los tiempos de una sesión específica.
  ///
  /// Este método consulta la base de datos y devuelve una lista de todos los tiempos
  /// registrados para una sesión específica.
  ///
  /// Parámetros:
  /// - `idSession`: ID de la sesión de la que se desean obtener los tiempos.
  ///
  /// Retorna:
  /// - `List<TimeTraining>`: Lista de objetos [TimeTraining] que contiene los tiempos registrados para esa sesión.
  Future<List<TimeTraining>> getTimesOfSession(int? idSession) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIEMPOS DE UNA SESION
      final result = await db.query('timeTraining',
          where: 'idSession = ?', whereArgs: [idSession]);

      if (result.isNotEmpty) {
        // MAPEAR LOS RESULTADOS A UNA LISTA DE OBJETOS TimeTraining
        return result.map((map) {
          return TimeTraining(
            idTimeTraining: map['idTimeTraining'] as int,
            idSession: map['idSession'] as int,
            scramble: map['scramble'] as String,
            timeInSeconds: map['timeInSeconds'] as double,
            comments: map['comments'] as String?,
            penalty: map['penalty'] as String,
            registrationDate: map['registrationDate'] as String,
          );
        }).toList();
      } else {
        DatabaseHelper.logger
            .w("No se encontraron tiempos para la sesion con ID: $idSession.");
        return []; // DEVOLVER UNA LISTA VACIA SI NO HAY RESULTADOS
      } // VERIFICAR SI HAY RESULTADOS
    } catch (e) {
      // SI HAY UN ERROR, MMUESTRA UN MENSAJE
      DatabaseHelper.logger.e("Error al obtener los tiempos de la sesion: $e");
      return []; // DEVOLVER UNA LISTA VACIA EN CASO DE ERROR
    }
  } // METODO QUE DEVUELVE LOS TIEMPOS QUE HAY EN UNA SESION

  /// Método para insertar un nuevo tiempo de entrenamiento.
  ///
  /// Este método inserta un nuevo tiempo de entrenamiento en la base de datos.
  ///
  /// Parámetros:
  /// - `timeTraining`: Objeto de tipo [TimeTraining] que contiene los datos del
  /// nuevo tiempo de entrenamiento.
  ///
  /// Retorna:
  /// - `bool`: `true` si la inserción fue exitosa, `false` si ocurrió un error.
  Future<bool> insertNewTime(TimeTraining timeTraining) async {
    final db = await DatabaseHelper.database;
    try {
      final result = await db.insert('timeTraining', {
        'idSession': timeTraining.idSession,
        'scramble': timeTraining.scramble,
        'timeInSeconds': timeTraining.timeInSeconds,
        'comments': timeTraining.comments,
        'penalty': timeTraining.penalty,
        'registrationDate': timeTraining.registrationDate
      });

      if (result > 0) {
        return true; // SE INSERTO CORRECTAMENTE
      } else {
        return false; // NO SE INSERTO CORRECTAMENTE
      } // VERIFICAMOS SI SE HA INSERTADO CORRECTAMENTE
    } catch (e) {
      DatabaseHelper.logger.e("Error al insertar un nuevo registro: $e");
      return false; // DEVUELVE FALSE EN CASO DE ERROR
    }
  } // METODO PARA INSERTAR UN NUEVO REGISTRO DE TIEMPO DE UNA SESION

  /** CALCULAR LAS ESTADISTICAS **/
  // pbValue, worstValue, countValue,
  // averageValue, ao5Value, ao12Value,
  // ao50Value, ao100Value

  /// Método para obtener el mejor tiempo registrado en una sesión.
  ///
  /// Este método recorre la lista de tiempos de la sesión y devuelve el mejor tiempo
  /// en formato "minutos:segundos.decimal".
  ///
  /// Parámetros:
  /// - `timesList`: Lista de tiempos [TimeTraining] para los cuales se calcula el mejor tiempo.
  ///
  /// Retorna:
  /// - `String`: El mejor tiempo en formato "minutos:segundos.decimal".
  Future<String> getPbTimeBySession(List<TimeTraining> timesList) async {
    var pbTime = 0.0; // INICIALIZAR EL MEJOR TIEMPO
    var worstTime = 0.0; // INICIALIZAR EL PEOR TIEMPO
    int minutes = 0;

    for (var times in timesList) {
      if (times.timeInSeconds > worstTime) {
        worstTime = times.timeInSeconds;
      } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
    } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL PEOR TIEMPO DE LA SESION

    pbTime = worstTime; // EL MEJOR TIEMPO ES EL PEOR (para darle un valor)

    for (var times in timesList) {
      if (times.timeInSeconds < pbTime) {
        pbTime = times.timeInSeconds;
      } // SI EL TIEMPO ES MAYOR AL MEJOR TIEMPO SE ESTABLECE
    } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL MEJOR TIEMPO DE LA SESION

    while (pbTime >= 60) {
      minutes++;
      pbTime -= 60; // RESTANIS 60 SEGUNDO CUANDO PASE UN MINUTO
    } // RECORREMOS EL TIEMPO MIENTRAS TENGA MINUTOS

    if (pbTime < 10) {
      return "$minutes:0${pbTime.toStringAsFixed(2)}";
    } else {
      return "$minutes:${pbTime.toStringAsFixed(2)}";
    } // DEVUELVE ELMEJOR TIEMPO FORMATEADO
  } // METODO PARA OBTENER EL MEJOR TIEMPO DE UNA SESION

  /// Método para obtener el peor tiempo registrado en una sesión.
  ///
  /// Este método recorre la lista de tiempos de la sesión y devuelve el peor
  /// tiempo en formato "minutos:segundos.decimal".
  ///
  /// Parámetros:
  /// - `timesList`: Lista de tiempos [TimeTraining] para los cuales se calcula
  /// el peor tiempo.
  ///
  /// Retorna:
  /// - `String`: El peor tiempo en formato "minutos:segundos.decimal".
  Future<String> getWorstTimeBySession(List<TimeTraining> timesList) async {
    var worstTime = 0.0; // INICIALIZAR EL PEOR TIEMPO
    int minutes = 0;
    for (var times in timesList) {
      if (times.timeInSeconds > worstTime) {
        worstTime = times.timeInSeconds;
      } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
    } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL PEOR TIEMPO DE LA SESION

    while (worstTime >= 60) {
      minutes++;
      worstTime -= 60; // RESTANIS 60 SEGUNDO CUANDO PASE UN MINUTO
    } // RECORREMOS EL TIEMPO MIENTRAS TENGA MINUTOS

    if (worstTime < 10) {
      return "$minutes:0${worstTime.toStringAsFixed(2)}";
    } else {
      return "$minutes:${worstTime.toStringAsFixed(2)}";
    } // DEVUELVE EL PEOR TIEMPO FORMATEADO
  } // METODO PARA OBTENER EL PEOR TIEMPO DE UNA SESION

  /// Método para obtener el número de tiempos registrados en una sesión.
  ///
  /// Este método devuelve la cantidad de tiempos registrados en la lista de
  /// tiempos de la sesión.
  ///
  /// Parámetros:
  /// - `timesList`: Lista de tiempos [TimeTraining].
  ///
  /// Retorna:
  /// - `int`: El número de tiempos registrados en la lista.
  Future<int> getCountBySession(List<TimeTraining> timesList) async {
    return timesList.length; // DEVUELVE EL TAMAÑO DE LA LISTA DE TIEMPOS
  } // METODO PARA OBTENER LA CANTIDAD DE TIEMPOS QUE HAY EN UNA SESION

  /// Metodo para calcular la **media de X tiempos (AoX)** de una sesión.
  ///
  /// Este metodo calcula la media de los **X tiempos más recientes** registrados en la sesión,
  /// eliminando el mejor y el peor tiempo.
  ///
  /// Parametros:
  /// - `timesList`: Lista de tiempos [TimeTraining] registrados.
  /// - `numAvg`: Número de tiempos que se usan para calcular la media.
  ///
  /// Retorna:
  /// - **String**: Tiempo medio en formato `"mm:ss.ss"` si hay suficientes tiempos.
  /// - `"--:--.--"` si hay menos tiempos de los necesarios para calcular la media.
  Future<String> getAoX(List<TimeTraining> timesList, int numAvg) async {
    if (timesList.length < numAvg) {
      return "--:--.--";
    } // SI NO HAY LOS x TIEMPOS PARA HACER ESA MEDIA, DEVUELVE EL STRING POR DEFECTO

    double avgTimeInSeconds = 0.0;

    // ORDENAMOS LA LISTA POR FECHA MAS RECIENTE
    timesList.sort((a, b) {
      // CONVERTIMOS LAS FECHAS A DATETIME PARA HACER LA COMPARACION
      DateTime dateA = DateTime.parse(a.registrationDate);
      DateTime dateB = DateTime.parse(b.registrationDate);

      // CompareTo PARA QUE EL MAS RECIENTE ESTE PRIMERO
      return dateB.compareTo(dateA); // SE ORDENA DE MAS RECIENTE
    });

    // COGEMOS SOLO LOS x TIEMPOS MAS RECIENTES QUE QUEREMOS USAR EN LA MEDIA
    // (.take devuelve los primeros numAvg elementos de la lista)
    List<TimeTraining> recentTimes = timesList.take(numAvg).toList();

    // ORDENAMOS POR TIEMPO PARA SACAR EL MEJOR Y EL PEOR
    recentTimes.sort((a, b) => a.timeInSeconds.compareTo(b.timeInSeconds));

    // QUITAMOS EL MEJOR TIEMPO (PRIMERO) Y EL PEOR TIEMPO (ULTIMO)
    recentTimes.removeAt(0); // MEJOR
    recentTimes.removeLast(); // PEOR


    for (var time in recentTimes) {
      avgTimeInSeconds += time.timeInSeconds;
    } // SUMAMOS LOS TIEMPOS RESTANTES

    // HACEMOS LA MEDIA DIVIDIENDO POR LOS TIEMPOS QUE QUEDAN
    avgTimeInSeconds = avgTimeInSeconds / recentTimes.length;

    // SACAMOS MINUTOS Y SEGUNDOS
    int minutes = avgTimeInSeconds ~/ 60; // MINUTOS
    double seconds = avgTimeInSeconds % 60; // SEGUNDOS

    // DEVOLVEMOS EL RESULTADO FORMATEADO mm:ss.ss
    // (se usa padLeft para asegura que el string tenga siempre 5 caracteres
    // rellenando con ceros a la izquierda si hace falta. Y se redondea a 2
    // decimales)
    return "$minutes:${seconds.toStringAsFixed(2).padLeft(5, '0')}";
  } // METODO PARA HACER LA MEDIA DE x TIEMPOS (5,12,50,100,total)

  /// Método para eliminar un tiempo por su ID.
  ///
  /// Este método elimina un tiempo registrado en la base de datos
  /// utilizando el ID del tiempo.
  ///
  /// Parámetros:
  /// - `idTimeTraining`: ID del tiempo de entrenamiento que se desea eliminar.
  ///
  /// Retorna:
  /// - `bool`: `true` si el tiempo fue eliminado correctamente, `false` si ocurrió un error.
  Future<bool> deleteTime(int idTimeTraining) async {
    final db = await DatabaseHelper.database;
    try {
      // SE ELIMINA EL TIEMPO CON EL ID PROPORCIONADO
      final deleteTime = await db.delete('timeTraining',
          where: 'idTimeTraining = ?', whereArgs: [idTimeTraining]);

      // DEVUELVE TRUE/FALSE SI SE ELIMINO CORRECTAMENTE O NO
      return deleteTime > 0;
    } catch (e) {
      // RETORNA FALSE Y UN MENSAJE SI OCURRE UN ERROR
      DatabaseHelper.logger.e("Error al eliminar el tiempo: $e");
      return false;
    }
  } // METODO PARA ELIMINAR UN TIEMPO POR EL ID DEL TIEMPO

  /// Método para eliminar todos los tiempos de una sesión.
  ///
  /// Este método elimina todos los tiempos registrados en la base de datos
  /// utilizando el ID de la sesión.
  ///
  /// Parámetros:
  /// - `idSession`: ID de la sesión a la que se quieren eliminar todos los tiempos.
  ///
  /// Retorna:
  /// - `bool`: `true` si todos los tiempos fueron eliminados correctamente, `false` si ocurrió un error.
  Future<bool> deleteAllTimeBySession(int? idSession) async {
    final db = await DatabaseHelper.database;
    try{
      // SE ELIMINAN TODOS LOS TIEMPOS DE LA SESION
      final deleteAllTime = await db.delete('timeTraining', where: 'idSession = ?', whereArgs: [idSession]);

      // DEVUELVE TRUE/FALSE SI SE ELIMINARON CORRECTAMENTE O NO
      return deleteAllTime > 0;
    } catch (e){
      // RETORNA FALSE Y UN MENSAJE SI OCURRE UN ERROR
      DatabaseHelper.logger.e("Error al eliminar todos los tiempos de la sesión $idSession: $e");
      return false;
    }
  } // METODO PARA ELIMINAR TODOS LOS TIEMPOS DE UNA SESION

  /// Método para obtener el ID de un tiempo a partir del scramble y el ID de la sesión.
  ///
  /// Este método busca un tiempo en la base de datos utilizando el scramble
  /// y el ID de la sesión.
  ///
  /// Parámetros:
  /// - `scramble`: El scramble utilizado en la sesión.
  /// - `idSession`: El ID de la sesión en la que se realizó el tiempo.
  ///
  /// Retorna:
  /// - `int`: El ID del tiempo encontrado o `-1` si no se encuentra.
  Future<int> getIdByTime(String scramble, int idSession) async {
    final db = await DatabaseHelper.database;
    int idTime = -1; // ID DEL TIEMPO RETORNADO
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final result = await db.query(
        'timeTraining',
        where: 'scramble = ? AND idSession = ?',
        whereArgs: [scramble, idSession],
      );

      if (result.isNotEmpty) {
        // RETORNA EL ID DEL TIEMPO OBTENIDO
        idTime = result.first['idTimeTraining'] as int;
      } else {
        // SI NO ENCUENTRA EL TIEMPO, DEVUELVE UN -1
        DatabaseHelper.logger.w(
            "No se encontró ningún tiempo con ese scramble: $scramble y el id de sesión: $idSession");
      } // SI LA CONSULTA NO ES NULA Y DEVUELVE -1

      return idTime; // RETORNA EL IDTIME
    } catch (e) {
      // SI OCURRE UN ERROR MUESTRA UN MENSAJE DE ERROR
      DatabaseHelper.logger.e(
          "Error al obtener el tiempo por su scramble: $scramble y el id de sesión: $idSession");
      // RETORNA -1 EN CASO DE ERROR
      return idTime;
    }
  } // METODO PARA BUSCAR UN TIEMPO POR SU SCRAMBLE Y EL ID DE LA SESION
// (como el scramble suele ser unico se busca por eso y para ser mas exactos se busca por la sesion en concreto)
}
