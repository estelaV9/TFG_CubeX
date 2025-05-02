import 'package:esteladevega_tfg_cubex/model/time_training.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

/// Clase encargada de gestionar las operaciones CRUD y estadísticas sobre los **tiempos de entrenamiento**.
///
/// Esta clase interactúa con la base de datos para insertar, eliminar, obtener y
/// calcular estadísticas relacionadas con los tiempos en las sesiones.
class TimeTrainingDao {
  /// Método para obtener los tiempos de una sesión específica con opción de búsqueda por comentario o tiempo.
  ///
  /// Este método consulta la base de datos y devuelve una lista de todos los tiempos
  /// registrados para una sesión específica. Se puede filtrar la búsqueda por comentarios o por tiempo.
  /// También se puede ordenar los resultados por fecha o tiempo según los parámetros proporcionados.
  ///
  /// Parámetros:
  /// - `idSession`: ID de la sesión de la que se desean obtener los tiempos.
  /// - `comment` (String?, opcional): Si se proporciona, la búsqueda filtrará los resultados
  ///   que contengan este comentario en el campo `comments`.
  /// - `time` (String?, opcional): Si se proporciona, la búsqueda filtrará los resultados
  ///   cuyos valores en `timeInSeconds` comiencen con este valor.
  /// - `dateAsc` (bool?, opcional): Si se proporciona, determina el orden de los resultados por fecha:
  ///   `true` para ascendente, `false` para descendente.
  /// - `timeAsc` (bool?, opcional): Si se proporciona, determina el orden de los resultados por tiempo:
  ///   `true` para ascendente, `false` para descendente.
  ///
  /// Retorna:
  /// - `Future<List<TimeTraining>>`: Lista de objetos [TimeTraining] con los tiempos registrados
  ///   que cumplen los criterios de búsqueda. Si no se encuentran resultados, devuelve una lista vacía.
  Future<List<TimeTraining>> getTimesOfSession(int? idSession,
      [String? comment, String? time, bool? dateAsc, bool? timeAsc]) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA OBTENER TODOS LOS TIEMPOS DE UNA SESION
      final List<Map<String, dynamic>> result;
      String orderBy = ""; // VARIABLE PARA ALMACENAR ORDEN

      // DETERMINAR ORDENACION
      if (dateAsc != null) {
        orderBy = "registrationDate ${dateAsc ? 'ASC' : 'DESC'}";
      } else if (timeAsc != null) {
        orderBy = timeAsc ? "timeInSeconds ASC" : "timeInSeconds DESC";
      }

      if (comment != null) {
        // SI EL USUARIO HA INTRODUCIDO UN COMENTARIO, SE REALIZA LA BUSQUEDA POR COMENTARIOS
        // SE USA LIKE CON '%' PARA ENCONTRAR CUALQUIER COINCIDENCIA QUE CONTENGA LA PALABRA
        result = await db.query('timeTraining',
            where: 'idSession = ? AND comments LIKE ?',
            whereArgs: [idSession, '%$comment%'],
            orderBy: orderBy.isNotEmpty ? orderBy : null);
      } else if (time != null) {
        // SI EL USUARIO HA INTRODUCIDO UN TIEMPO, SE BUSCA POR EL TIEMPO
        // SE USA LIKE CON '%' AL FINAL PARA ENCONTRAR LOS REGISTROS CUYO TIEMPO
        // COMIENCE CON EL VALOR INTRODUCIDO
        result = await db.query(
          'timeTraining',
          where: "idSession = ? AND timeInSeconds LIKE ?",
          whereArgs: [idSession, '$time%'],
          orderBy: orderBy.isNotEmpty ? orderBy : null,
        );
      } else {
        // SI NO SE HA INTRODUCIDO NI TIEMPO NI COMENTARIO, SE FILTRA POR LA SESION
        result = await db.query('timeTraining',
            where: 'idSession = ?',
            whereArgs: [idSession],
            orderBy: orderBy.isNotEmpty ? orderBy : null);
      }

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
        //DatabaseHelper.logger
        //    .w("No se encontraron tiempos para la sesion con ID: $idSession.");
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
  /// Se valida que el mejor tiempo no contenga una penalización DNF.
  ///
  /// Parámetros:
  /// - `timesList`: Lista de tiempos [TimeTraining] para los cuales se calcula el mejor tiempo.
  /// - `isDnf`: Booleano para saber si el tiempo actual al que se le esta aplicando este método
  ///   ha sido establecido como DNF.
  ///
  /// Retorna:
  /// - `String`: El mejor tiempo en formato "minutos:segundos.decimal" que no contenga un DNF.
  /// - "0:00.00": Si no hay tiempos antes o si los anteriores tiempos tienen una penalizacion
  /// de DNF entonces retornará el tiempo en formato "0:00.00".
  Future<String> getPbTimeBySession(
      List<TimeTraining> timesList, bool isDnf) async {
    var pbTime = 0.0; // INICIALIZAR EL MEJOR TIEMPO
    var worstTime = 0.0; // INICIALIZAR EL PEOR TIEMPO
    int minutes = 0;
    // ATRIBUTO PARA SABER SSI TODOS LOS TIEMPOS SON DNF
    bool isDnfAll = false;
    // CONTADOR PARA SABER CUANDOS TIEMPOS SON DNF
    int cont = 0;

    for (var tim in timesList) {
      // SI EL TIEMPO TIENE UNA PENALIZACION DE 'DNF' SUBE EL CONTADOR
      if (tim.penalty == "DNF") cont++;
    } // SE RECORRE LA LSITA

    // CUENTA EL ULTIMO TIEMPO SI LE PONE UN DNF
    if (isDnf == true) cont++;

    // SI EL CONTADOR Y EL NUMERO TOTAL DE TIEMPOS ES EL MISMO SIGNIFICA QUE
    // TODOS LOS TIEMPOS TIENEN DNF
    if (cont == timesList.length) isDnfAll = true;

    // SI HA PUESTO DNF Y TODA LA LISTA TIENE DNF
    if (isDnfAll == true) return "0:00.00";

    if (isDnf) {
      // SI EL TIEMPO ACTUAL SE LE AÑADE UN DNF, ENTONCES SE RECORRE TODOS LOS TIEMPOS
      // MENOS EL ACTUAL, PARA SABER QUE TIEMPO ES EL PEOR Y SIN DNF
      for (int index = 0; index <= (timesList.length - 2); index++) {
        if (timesList[index].timeInSeconds > worstTime &&
            timesList[index].penalty != "DNF") {
          worstTime = timesList[index].timeInSeconds;
        } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
      }

      pbTime = worstTime; // EL MEJOR TIEMPO ES EL PEOR (para darle un valor)

      for (int index = 0; index <= (timesList.length - 2); index++) {
        if (timesList[index].timeInSeconds < pbTime &&
            timesList[index].penalty != "DNF") {
          pbTime = timesList[index].timeInSeconds;
        } // SI EL TIEMPO ES MAYOR AL MEJOR TIEMPO SE ESTABLECE
      }

    } else {
      for (var times in timesList) {
        if (times.timeInSeconds > worstTime && times.penalty != "DNF") {
          worstTime = times.timeInSeconds;
        } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
      } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL PEOR TIEMPO DE LA SESION

      pbTime = worstTime; // EL MEJOR TIEMPO ES EL PEOR (para darle un valor)

      for (var times in timesList) {
        // SI EL TIEMPO NO TIENE DNF Y ES MENOR QUE EL MEJOR TIEMPO, SE ACTUALIZA EL PB
        if (times.timeInSeconds < pbTime &&
            times.penalty != "DNF") {
          pbTime = times.timeInSeconds;
        } // SI EL TIEMPO ES MAYOR AL MEJOR TIEMPO SE ESTABLECE
      } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL MEJOR TIEMPO DE LA SESION
    }

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
  /// Se valida que el mejor tiempo no contenga una penalización DNF.
  ///
  /// Parámetros:
  /// - `timesList`: Lista de tiempos [TimeTraining] para los cuales se calcula
  /// el peor tiempo.
  ///
  /// Retorna:
  /// - `String`: El peor tiempo en formato "minutos:segundos.decimal".
  /// - "0:00.00": Si no hay tiempos antes o si los anteriores tiempos tienen una penalizacion
  /// de DNF entonces retornará el tiempo en formato "0:00.00".
  Future<String> getWorstTimeBySession(
      List<TimeTraining> timesList, bool isDnf) async {
    var worstTime = 0.0; // INICIALIZAR EL PEOR TIEMPO
    int minutes = 0;
    // ATRIBUTO PARA SABER SSI TODOS LOS TIEMPOS SON DNF
    bool isDnfAll = false;
    // CONTADOR PARA SABER CUANDOS TIEMPOS SON DNF
    int cont = 0;

    for (var tim in timesList) {
      // SI EL TIEMPO TIENE UNA PENALIZACION DE 'DNF' SUBE EL CONTADOR
      if (tim.penalty == "DNF") cont++;
    } // SE RECORRE LA LSITA

    // CUENTA EL ULTIMO TIEMPO SI LE PONE UN DNF
    if (isDnf == true) cont++;

    // SI EL CONTADOR Y EL NUMERO TOTAL DE TIEMPOS ES EL MISMO SIGNIFICA QUE
    // TODOS LOS TIEMPOS TIENEN DNF
    if (cont == timesList.length) isDnfAll = true;

    // SI HA PUESTO DNF Y TODA LA LISTA TIENE DNF
    if (isDnfAll == true) return "0:00.00";

    if (isDnf) {
      // SI EL TIEMPO ACTUAL SE LE AÑADE UN DNF, ENTONCES SE RECORRE TODOS LOS TIEMPOS
      // MENOS EL ACTUAL, PARA SABER QUE TIEMPO ES EL PEOR Y SIN DNF
      for (int index = 0; index <= (timesList.length - 2); index++) {
        if (timesList[index].timeInSeconds > worstTime &&
            timesList[index].penalty != "DNF") {
          worstTime = timesList[index].timeInSeconds;
        } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
      }
    } else {
      for (var times in timesList) {
        if (times.timeInSeconds > worstTime && times.penalty != "DNF") {
          worstTime = times.timeInSeconds;
        } // SI EL TIEMPO ES MENOR AL PEOR TIEMPO SE ESTABLECE
      } // SE RECORRE TODOS LOS TIEMPOS BUSCANDO EL PEOR TIEMPO DE LA SESION
    }
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
  /// Se filtra los **DNF** ya que si contiene uno la media se establecerá como
  /// peor tiempo, pero si tiene más entonces la media se establece como **DNF**.
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

    // FILTRAMOS LOS DNF (EL DNF SE CONSIDERA EL PEOR TIEMPO)
    recentTimes.removeWhere((time) => time.penalty == "DNF");

    // SI ELIMINA MAS DE UN TIEMPO POR DNF, LA MEDIA SE QUEDA EN DNF
    if (recentTimes.length < numAvg - 1) {
      return "DNF";
    }

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

  /// Método para calcular la **mejor media** de X tiempos en una sesión.
  ///
  /// Este método calcula la **mejor media** (más baja) de un bloque de `numAvg`
  /// tiempos, ordenados por fecha de más reciente a más antigua. Para cada bloque,
  /// se eliminan el mejor y el peor tiempo, y se calcula la media con los
  /// tiempos restantes (regla WCA).
  ///
  /// Parámetros:
  /// - `timesList`: Lista de objetos [TimeTraining] registrados en la sesión.
  /// - `numAvg`: Número de tiempos consecutivos que se usan para calcular la media.
  ///
  /// Retorna:
  /// - **String**: La mejor media en formato `"mm:ss.ss"`.
  ///   - `"--:--.--"` si no hay suficientes tiempos para calcular la media.
  Future<String> getBestAvg(List<TimeTraining> timesList, int numAvg) async {
    if (timesList.length < numAvg) {
      // SI NO HAY SUFICIENTES TIEMPOS PARA HACER LA MEDIA, DEVUELVE EL VALOR POR
      // DEFECTO
      return "--:--.--";
    }

    // MEJOR MEDIA (VALOR MAS BAJO)
    double bestAvgTimeInSeconds = double.infinity;

    // ORDENAMOS LA LISTA POR FECHA MAS RECIENTE
    timesList.sort((a, b) {
      DateTime dateA = DateTime.parse(a.registrationDate);
      DateTime dateB = DateTime.parse(b.registrationDate);
      // ORDENAMOS DE MAS RECIENTE A MAS ANTIGUO
      return dateB.compareTo(dateA);
    });

    // RECORREMOS LA LISTA TOMBANDO BLOQUES DE numAvg TIEMPOS
    for (int i = 0; i <= timesList.length - numAvg; i++) {
      // TOMAMOS UN BLOQUE DE numAvg TIEMPOS
      List<TimeTraining> block = timesList.sublist(i, i + numAvg);

      // ORDENAMOS EL BLOQUE POR TIEMPO (DE MENOR A MAYOR)
      block.sort((a, b) => a.timeInSeconds.compareTo(b.timeInSeconds));

      // ELIMINAMOS EL MEJOR Y EL PEOR TIEMPO
      List<TimeTraining> trimmedBlock = block.sublist(1, block.length - 1);

      // CALCULAMOS LA MEDIA DEL BLOQUE QUEDANDO CON LOS TIEMPOS RESTANTES
      double sum = 0.0;
      for (var time in trimmedBlock) {
        sum += time.timeInSeconds;
      }
      double avgTimeInSeconds = sum / trimmedBlock.length;

      // COMPARAMOS CON LAS OTRAS MEDIAS Y ACTUALIZAMOS LA MEJOR MEDIA
      if (avgTimeInSeconds < bestAvgTimeInSeconds) {
        bestAvgTimeInSeconds = avgTimeInSeconds;
      }
    }

    // CONVERTIMOS EL TIEMPO EN SEGUNDOS EN FORMATO "mm:ss.ss"
    String formatTime(double timeInSeconds) {
      int minutes = timeInSeconds ~/ 60;
      double seconds = timeInSeconds % 60;
      // AÑADE UN CARACTER '0' A LA IZQUIERDA SI TIENE MENOS DE 5 CARACTERES
      // (si es 9.45 -> 09.45, pero si es 11.45 se queda igual)
      return "${minutes}:${seconds.toStringAsFixed(2).padLeft(5, '0')}";
    }
    return formatTime(bestAvgTimeInSeconds);
  }

  /// Método para calcular la **peor media** de X tiempos en una sesión.
  ///
  /// Este método calcula la **peor media** (más alta) DE UN bloques de `numAvg`
  /// tiempos, ordenados por fecha de más reciente a más antigua. Para cada bloque,
  /// se eliminan el mejor y el peor tiempo, y se calcula la media con los
  /// tiempos restantes (regla WCA).
  ///
  /// Parámetros:
  /// - `timesList`: Lista de tiempos [TimeTraining] registrados en la sesión.
  /// - `numAvg`: Número de tiempos consecutivos a considerar por bloque.
  ///
  /// Retorna:
  /// - **String**: La peor media en formato `"mm:ss.ss"`.
  ///   - `"--:--.--"` si no hay suficientes tiempos para calcularla.
  Future<String> getWorstAvg(List<TimeTraining> timesList, int numAvg) async {
    if (timesList.length < numAvg) {
      // SI NO HAY SUFICIENTES TIEMPOS PARA HACER LA MEDIA, DEVUELVE EL VALOR POR
      // DEFECTO
      return "--:--.--";
    }

    // MEJOR MEDIA (VALOR MAS ALTO)
    double worstAvgTimeInSeconds = -double.infinity;

    // ORDENAMOS LA LISTA POR FECHA MAS RECIENTE
    timesList.sort((a, b) {
      DateTime dateA = DateTime.parse(a.registrationDate);
      DateTime dateB = DateTime.parse(b.registrationDate);
      // ORDENAMOS DE MAS RECIENTE A MAS ANTIGUO
      return dateB.compareTo(dateA);
    });

    // RECORREMOS LA LISTA TOMBANDO BLOQUES DE numAvg TIEMPOS
    for (int i = 0; i <= timesList.length - numAvg; i++) {
      // TOMAMOS UN BLOQUE DE numAvg TIEMPOS
      List<TimeTraining> block = timesList.sublist(i, i + numAvg);

      // ORDENAMOS EL BLOQUE POR TIEMPO (DE MENOR A MAYOR)
      block.sort((a, b) => a.timeInSeconds.compareTo(b.timeInSeconds));

      // ELIMINAMOS EL MEJOR Y EL PEOR TIEMPO
      List<TimeTraining> trimmedBlock = block.sublist(1, block.length - 1);

      // CALCULAMOS LA MEDIA DEL BLOQUE QUEDANDO CON LOS TIEMPOS RESTANTES
      double sum = 0.0;
      for (var time in trimmedBlock) {
        sum += time.timeInSeconds;
      }
      double avg = sum / trimmedBlock.length;

      // ACTUALIZAMOS SI ESTA MEDIA ES LA PEOR (LA MAS ALTA)
      if (avg > worstAvgTimeInSeconds) {
        worstAvgTimeInSeconds = avg;
      }
    }

    // CONVERTIMOS EL TIEMPO EN SEGUNDOS A FORMATO "mm:ss.ss"
    String formatTime(double timeInSeconds) {
      int minutes = timeInSeconds ~/ 60;
      double seconds = timeInSeconds % 60;
      // AÑADE UN CARACTER '0' A LA IZQUIERDA SI TIENE MENOS DE 5 CARACTERES
      // (si es 9.45 -> 09.45, pero si es 11.45 se queda igual)
      return "${minutes}:${seconds.toStringAsFixed(2).padLeft(5, '0')}";
    }
    return formatTime(worstAvgTimeInSeconds);
  }

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
    try {
      // SE ELIMINAN TODOS LOS TIEMPOS DE LA SESION
      final deleteAllTime = await db.delete('timeTraining',
          where: 'idSession = ?', whereArgs: [idSession]);

      // DEVUELVE TRUE/FALSE SI SE ELIMINARON CORRECTAMENTE O NO
      return deleteAllTime > 0;
    } catch (e) {
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
  Future<int> getIdByTime(String scramble, int? idSession) async {
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

  /// Método para actualizar un tiempo en la base de datos.
  ///
  /// Este método actualiza los datos de un tiempo en la tabla `timeTraining`
  /// utilizando su ID y un objeto `TimeTraining` con los nuevos valores.
  /// Sobretodo para actualizar penalizaciones o comentarios.
  ///
  /// Parámetros:
  /// - `idTime`: El ID del tiempo que se actualizará.
  /// - `time`: Un objeto `TimeTraining` que contiene los nuevos valores para actualizar.
  ///
  /// Retorna:
  /// - `bool`: `true` si la actualización fue exitosa (al menos una fila afectada),
  ///   `false` si ocurrió un error o no se actualizó ninguna fila.
  Future<bool> updateTime(int idTime, TimeTraining? time) async {
    final db = await DatabaseHelper.database;
    // MAPA CON LOS VALORES A ACTUALIZAR
    try {
      // REALIZAR EL UPDATE
      final Map<String, dynamic> timeData = {
        'idTimeTraining': idTime,
        'idSession': time?.idSession,
        'scramble': time?.scramble,
        'timeInSeconds': time?.timeInSeconds,
        'comments': time?.comments,
        'penalty': time?.penalty,
      };

      final result = await db.update('timeTraining', timeData,
          where: 'idTimeTraining = ?', whereArgs: [idTime]);

      // DEVUELVE TRUE SI SE ACTUALIZO AL MENOS UNA FILA
      return result > 0;
    } catch (e) {
      // RETORNA FALSE Y MUESTRA UN MENSAJE DE ERROR SI FALLA
      DatabaseHelper.logger.e(
          "Error al actualizar la información del time ${time.toString()}: $e");
      return false;
    }
  } // METODO PARA ACTUALIZAR UN TIEMPO

  /// Método para obtener un tiempo por su ID en la base de datos.
  ///
  /// Este método recupera un tiempo especifico en la tabla `timeTraining`
  /// utilizando su ID. Si encuentra un resultado, mapea los datos y devuelve un
  /// objeto `TimeTraining`.
  ///
  /// Parámetros:
  /// - `idTime`: El ID del tiempo que se recuperará.
  ///
  /// Retorna:
  /// - Un objeto `TimeTraining` si el tiempo es encontrado en la base de datos.
  /// - `null` si no existe un tiempo con el `idTime` proporcionado o si ocurre un error.
  Future<TimeTraining?> getTimeById(int idTime) async {
    final db = await DatabaseHelper.database;
    try {
      // REALIZA LA CONSULTA A LA BASE DE DATOS
      final result = await db.query(
        'timeTraining',
        where: 'idTimeTraining = ?',
        whereArgs: [idTime],
      );

      if (result.isNotEmpty) {
        // SI SE ENCUENTRA EL TIEMPO, SE MAPEA LOS DATOS Y LO DEVOLVE
        final timeTraining = result.first;
        return TimeTraining(
          idTimeTraining: timeTraining['idTimeTraining'] as int?,
          idSession: timeTraining['idSession'] as int,
          scramble: timeTraining['scramble'] as String,
          timeInSeconds: timeTraining['timeInSeconds'] as double,
          comments: timeTraining['comments'] as String,
          penalty: timeTraining['penalty'] as String,
          registrationDate: timeTraining['registrationDate'] as String,
        );
      } else {
        // SI NO ENCUENTRA EL TIEMPO, DEVUELVE UN -1
        DatabaseHelper.logger.w(
            "No se encontró ningún tiempo con ese id: $idTime");
      } // SI LA CONSULTA NO ES NULA Y DEVUELVE -1

      return null; // RETORNA NULL
    } catch (e) {
      // SI OCURRE UN ERROR MUESTRA UN MENSAJE DE ERROR
      DatabaseHelper.logger.e("Error al obtener el tiempo por id: $idTime");
      // RETORNA NULL EN CASO DE ERROR
      return null;
    }
  } // METODO PARA BUSCAR UN TIEMPO POR SU ID

  /// Método para contar cuántos tiempos tienen una penalización específica en una sesión.
  ///
  /// Este método cuenta cuántos registros están asociados a una sesión (`idSession`)
  /// y tienen una penalización específica (`penalty`).
  ///
  /// Parámetros:
  /// - `idSession`: El ID de la sesión sobre la cual se realizará la consulta.
  /// - `penalty`: La penalización que se desea contar ("+2", "DNF").
  ///
  /// Retorna:
  /// - Un `int` representando la cantidad de veces que se encuentra la penalización
  ///   en la sesión indicada.
  /// - `-1` si no se encontró ningún resultado o si ocurrió un error durante la consulta.
  Future<int> countPenalty(int? idSession, String penalty) async {
    final db = await DatabaseHelper.database;
    try {
      // CONSULTA PARA CONTAR LOS TIEMPOS DE LA SESION QUE TIENEN ESA PENALIZACION
      final result = await db.rawQuery(
        'SELECT COUNT(*) AS count FROM timeTraining WHERE idSession = ? AND penalty = ?',
        [idSession, penalty],
      );

      // RETORNA EL PRIMER VALOR Y SI ES NULL, RETORNA -1
      return Sqflite.firstIntValue(result) ?? -1;
    } catch (e) {
      // SI OCURRE ALGUN ERROR, MANDA UN MENSAJE Y RETORNA -1
      DatabaseHelper.logger.e(
          "Error al obtener la cuenta de la penalizacion $penalty de la sesion $idSession");
      return -1;
    }
  }
}
