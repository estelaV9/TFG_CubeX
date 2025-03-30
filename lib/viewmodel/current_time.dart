import 'package:esteladevega_tfg_cubex/model/time_training.dart';
import 'package:flutter/material.dart';

import '../data/dao/time_training_dao.dart';
import '../data/database/database_helper.dart';
import '../view/utilities/alert.dart';

/// Provider para gestionar el **tiempo de resolución actual** en la aplicación.
///
/// Esta clase se encarga de manejar el tiempo actual de resolución, gestionar las penalizaciones
/// como "+2" y "DNF", y proporcionar métodos para actualizar y eliminar el tiempo en la base de datos.
/// Notifica a los listeners cada vez que el estado cambia.
class CurrentTime extends ChangeNotifier {
  // VARIABLE PARA ALMACENAR EL TIEMPO ACTUAL
  /// El tiempo de resolución actual.
  TimeTraining? _timeTraining;

  /// Indica si se ha seleccionado la penalización "DNF".
  bool isDnfChoose = false;

  /// Indica si se ha seleccionado la penalización "+2".
  bool isPlusTwoChoose = false;

  /// Indica si el usuario ha introducido un comentario.
  bool isComment = false;

  /// GUARDAR EL TIEMPO ORIGINAL ANTES DE APLICAR LAS PENALIZACIONES
  double? _originalTime;

  final TimeTrainingDao _timeTrainingDao = TimeTrainingDao();

  /// Obtiene el tiempo de resolución actual.
  TimeTraining? get timeTraining => _timeTraining;

  /// Establece el tiempo actual y notifica a los listeners.
  void setTimeTraining(TimeTraining timeTraining) {
    _timeTraining = timeTraining;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL TIEMPO ACTUAL

  /// Establece el tiempo actual null y notifica a los listeners.
  void setResetTimeTraining() {
    _timeTraining = null;
    isDnfChoose = false;
    isPlusTwoChoose = false;
    isComment = false;
    // NOTIFICA A LOS LISTENERS QUE EL ESTADO HA CAMBIADO
    notifyListeners();
  } // ESTABLECER EL TIEMPO ACTUAL EN NULO

  /// Actualiza el tiempo actual si se ha aplicado una penalización.
  ///
  /// Este método se ejecuta cuando comienza un nuevo tiempo y se ha seleccionado
  /// alguna penalización (`+2` o `DNF`). Si es así, busca el tiempo en la base de datos
  /// y lo actualiza con la penalización correspondiente.
  ///
  /// **Características**:
  /// - Verifica si el usuario ha seleccionado alguna penalización.
  /// - Crea una nueva instancia de `TimeTraining` con la penalización aplicada.
  /// - Actualiza el tiempo en la base de datos.
  ///
  /// **Parámetros**:
  /// - `context` (`BuildContext`): Contexto actual de la aplicación, necesario para mostrar alertas.
  void updateCurrentTime(BuildContext context) async {
    // CUANDO EMPIECE UN TIEMPO NUEVO, SI HA PULSADO ALGUNA PENALIZACION, SE ACTUALIZA EL TIEMPO
    if (isPlusTwoChoose || isDnfChoose) {
      int idTime = await _timeTrainingDao.getIdByTime(
          _timeTraining!.scramble, _timeTraining!.idSession);

      if (idTime == -1) {
        AlertUtil.showSnackBarError(context, "time_saved_error");
        return;
      } // VALIDAR QUE EL IDTIME NO DE ERROR

      //              ACTUALIZAR ESTADO GLOBAL
      // TIEMPO A ACTUALIZAR
      TimeTraining updateTime = TimeTraining(
        idSession: _timeTraining!.idSession,
        scramble: _timeTraining!.scramble,
        comments: _timeTraining!.comments,
        timeInSeconds: isPlusTwoChoose
            ? (_timeTraining!.timeInSeconds + 2)
            : _timeTraining!.timeInSeconds,
        penalty: isDnfChoose ? "DNF" : (isPlusTwoChoose ? "+2" : ""),
      );

      _timeTraining! == updateTime;

      // ACTUALIZAR EL TIEMPO
      if (await _timeTrainingDao.updateTime(idTime, _timeTraining!) == false) {
        AlertUtil.showSnackBarError(context, "time_saved_error");
      } // SI FALLA, SE MUESTRA UN ERROR

      notifyListeners();
    }
  }

  /// Establece una penalización sobre el tiempo actual.
  ///
  /// Este método actualiza el tiempo actual que haya realizado el usuario
  /// en función de la penalización seleccionada.
  /// Si el usuario marca o desmarca una penalización, el tiempo se actualiza.
  ///
  /// **Características**:
  /// - Obtiene el tiempo actual de `currentTime` y se verifica si el tiempo no es nulo.
  /// - Si la penalización es "+2" y está habilitada, agrega 2 segundos al tiempo actual.
  /// - Si la penalización es "DNF" y está habilitada, establece el tiempo como "DNF".
  /// - Si la penalizacion es "none", dehabilita las otras penalizaciones.
  /// - Si la penalización es desmarcada o es de tipo "none", el tiempo vuelve a su valor original.
  /// - Finalmente, actualiza el estado con el nuevo tiempo.
  ///
  /// **Parámetros**:
  /// - `penalty` (`String`): Tipo de penalización, puede ser "+2" o "DNF".
  /// - `isEnabled` (`bool`): Indica si la penalización ha sido activada o desactivada.
  Future<void> setPenalty(String penalty, bool isEnabled) async {
    if (_timeTraining == null) return;

    if (penalty == "+2") {
      if (isEnabled) {
        // SE GUARDA EL TIEMPO ORIGINAL SOLO LA PRIMERA VEZ
        _originalTime ??= _timeTraining!.timeInSeconds;

        isPlusTwoChoose = true;
        // SI ELIGE +2, SE QUITA EL DNF
        isDnfChoose = false;
      } else {
        isPlusTwoChoose = false;
        if (_originalTime != null) {
          _timeTraining = TimeTraining(
            idSession: _timeTraining!.idSession,
            scramble: _timeTraining!.scramble,
            comments: _timeTraining!.comments,
            timeInSeconds: _originalTime!,
            // RESTAURA EL TIEMPO ORIGINAL
            penalty: isDnfChoose ? "DNF" : "",
          );
        }
        // SE RESETEA EL TIEMPO ORIGINAL SOLO DESPUES DE RESTAURARLO
        _originalTime = null;
      }
    } else if (penalty == "DNF") {
      isDnfChoose = isEnabled;
      if (isEnabled) {
        // SI ELIGE DNF, SE QUITA EL +2
        isPlusTwoChoose = false;
      }
    } // SEGUN LA PENALIZACION

    if (penalty == "none") {
      isDnfChoose = false;
      isPlusTwoChoose = false;
    } // SI LA PENALIZACION ES 'none', SE DESACTIVAN LAS OTRAS PENALIZACIONES

    // ACTUALIZAR EL TIEMPO EN EL ESTADO FLOBAL
    _timeTraining = TimeTraining(
      idSession: _timeTraining!.idSession,
      scramble: _timeTraining!.scramble,
      comments: _timeTraining!.comments,
      // SI SE HA SELECCIONADO "+2", SE SUMAN 2 SEGUNDOS AL TIEMPO ORIGINAL.
      // SI NO, SE USA EL TIEMPO ALMACENADO EN `_timeTraining`.
      timeInSeconds: penalty == "none"
          ? _originalTime!
          : (isPlusTwoChoose
              ? (_originalTime! + 2)
              : (_timeTraining!.timeInSeconds)),
      penalty: isDnfChoose ? "DNF" : (isPlusTwoChoose ? "+2" : "none"),
    );

    notifyListeners();
  }

  /// Elimina el tiempo actual de la base de datos.
  ///
  /// Este método elimina un tiempo almacenado en la base de datos a partir de su `scramble` y `idSession`.
  /// Después de la eliminación, actualiza el estado global y se muestra un mensaje de éxito o error.
  ///
  /// **Características**:
  /// - Se obtiene el tiempo actual de `currentTime`.
  /// - Busca el `idDeleteTime` a partir del `scramble` y `idSession` del tiempo actual.
  /// - Si se encuentra el `idDeleteTime`, intenta eliminar el tiempo de la base de datos.
  /// - Si la eliminación es exitosa, se actualiza el estado global y se pone en 0.0 el tiempo.
  /// - Si ocurre un error, se muestra un mensaje de error.
  Future<void> deleteTime(BuildContext context) async {
    if (_timeTraining == null) return;

    // OBTENER EL ID DEL TIEMPO A ELIMINAR
    int idDeleteTime = await _timeTrainingDao.getIdByTime(
        timeTraining!.scramble, timeTraining!.idSession!);

    if (idDeleteTime == -1) {
      // SI OCURRIO UN ERROR, MUESTRA UN SNACKBAR
      AlertUtil.showSnackBarInformation(context, "delete_time_error");
      DatabaseHelper.logger
          .e("No se obtuvo el tiempo por scramble e idSession: $idDeleteTime");
      return;
    } // VERIFICAR SI SE HA OBTENIDO EL ID DEL TIEMPO

    try {
      // ELIMINAR EL TIEMPO
      final isDeleted = await _timeTrainingDao.deleteTime(idDeleteTime);

      if (isDeleted) {
        // SI SE ELIMINO CORRECTAMENTE SE MUESTRA UN SNACKBAR
        AlertUtil.showSnackBarInformation(context, "delete_time_correct");
        // ACTUALIZAR EL TIEMPO ACTUAL EN NULO EN EL ESTADO GLOBAL
        setResetTimeTraining();
      } else {
        // SI OCURRIO UN ERROR MUESTRA UN SNACKBAR
        AlertUtil.showSnackBarInformation(context, "delete_time_error");
        DatabaseHelper.logger.e("No se pudo eliminar: $isDeleted");
      } // VERIFICAR SI SE HA ELIMINADO CORRECTAMENTE
    } catch (e) {
      // CAPTURAR CUALQUIER ERROR DURANTE LA ELIMINACION
      AlertUtil.showSnackBarInformation(context, "delete_time_error");
      DatabaseHelper.logger.e("Error al eliminar el tiempo: $e");
    }
    notifyListeners();
  } // METODO PARA ELIMINAR EL TIEMPO ACTUAL

  /// Devuelve el tiempo formateado.
  ///
  /// Este método devuelve el tiempo actual formateado en función de las siguientes condiciones:
  /// - Si `_timeTraining` es nulo, devuelve `"0.00"`.
  /// - Si se ha seleccionado la penalización "DNF", devuelve `"DNF"`.
  /// - Si el tiempo está disponible y no hay penalización o esta la penalizacion +2,
  ///   devuelve el tiempo en segundos.
  String getFormattedTime() {
    if (_timeTraining == null) return "0.00";
    if (isDnfChoose) return "DNF";
    return "${_timeTraining!.timeInSeconds}";
  }

  @override
  String toString() {
    return 'CurrentTime{_timeTraining: $_timeTraining}';
  } // toString() PARA HACER PRUEBAS
}