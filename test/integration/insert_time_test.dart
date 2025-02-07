import 'package:test/test.dart';
import 'package:esteladevega_tfg_cubex/data/dao/time_training_dao.dart';
import 'package:esteladevega_tfg_cubex/model/time_training.dart';
// TERMINAL: flutter test test/integration/insert_time_test.dart

void main() {
  group('TimeTrainingDao Tests', () {
    test('Deberia insertar un tiempo correctamente', () async {
      TimeTraining time = TimeTraining(
        idSession: 1,
        scramble: "R U R' U' R U2 R'",
        timeInSeconds: 3.2,
      ); // SE CREA UNA INSTANCIA DE TimeTraining

      // SE REALIZA LA INSERCION EN LA BASE DE DATOS
      TimeTrainingDao timeTrainingDao = TimeTrainingDao();
      bool result = await timeTrainingDao.insertNewTime(time);

      // SE VERIFICA QUE SE HAYA INSERTADO CORRECTAMENTE
      expect(result, equals(true));
    });
  });
}