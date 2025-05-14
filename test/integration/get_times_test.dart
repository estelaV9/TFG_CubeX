import 'package:esteladevega_tfg_cubex/data/dao/supebase/time_training_dao_sb.dart';
import 'package:test/test.dart';
import 'package:esteladevega_tfg_cubex/model/time_training.dart';
// TERMINAL: flutter test test/integration/get_times_test.dart

void main() {
  group('TimeTrainingDao Tests', () {
    test('Deberia obtener todos los tiempos de la sesion correctamente', () async {
      // SIMULA LA OBTENCION DE TIEMPOS DE UNA SESION
      int sessionId = 1; // ID DE SESION DE PRUEBA
      TimeTrainingDaoSb timeTrainingDaoSb = TimeTrainingDaoSb();

      // LISTA LOS TIEMPOS DE ESA SESION
      List<TimeTraining> times = await timeTrainingDaoSb.getTimesOfSession(sessionId);

      // VERIFICAMOS QUE SE OBTENGAN LOS TIEMPOS CORRECTAMENTE
      expect(times.isNotEmpty, equals(true));
    });
  });
}
