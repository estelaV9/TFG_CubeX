import 'package:esteladevega_tfg_cubex/model/user.dart';
import 'package:test/test.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_statistics.dart';
import 'package:esteladevega_tfg_cubex/model/time_training.dart';
import 'package:esteladevega_tfg_cubex/model/session.dart';
// TERMINAL: flutter test test/unit/current_statistics_test.dart

void main() {
  group('CurrentStatistics Tests', () {
    test('Debería calcular el mejor tiempo correctamente', () async {
      // CREAMOS UN USUARIO DE EJEMPLO
      User user = User(
          idUser: 1111,
          username: "username",
          mail: "mail@mail.com",
          password: "12345678(");

      Session session = Session(
        idSession: 1111,
        sessionName: "3x3 Session",
        idUser: user.idUser!,
        idCubeType: 2,
      ); // SESION PRUEBA

      // SE CREA UNA LISTA DE TIEMPOS PARA SIMULAR UNA SESION
      List<TimeTraining> timesList = [
        TimeTraining(
            timeInSeconds: 3.0,
            idSession: session.idSession,
            scramble: "L F2 L2 B R B' U F2 L U2 R2 D' B2 R2 B2 U F2 R2 D2 B2"),
        TimeTraining(
            timeInSeconds: 2.5,
            idSession: session.idSession,
            scramble:
                "B R D2 F2 L' F2 R' D2 U2 R' U2 R' D2 U L D' B' D B2 D F2"),
        TimeTraining(
            timeInSeconds: 4.0,
            idSession: session.idSession,
            scramble:
                "L2 D2 L' B2 L2 D2 U2 L B2 R F2 L F L U' B' F2 D R F' L'"),
      ];

      // SE INICIALIZA EL OBJETO CurrentStatistics Y MIRA A VER EL MEJOR TIEMPO
      CurrentStatistics currentStatistics = CurrentStatistics();
      // LE PASAMOS LA LSITA DE TIEMPOS
      currentStatistics.updateStatistics(timesListUpdate: timesList);
      // BUSCAMOS EL MEJOR TIEMPO
      String pbTime = await currentStatistics.getPbValue();

      // VERIFICAMOS QUE EL MEJOR TIEMPO SEA EL CORRECTO
      // (el mejor tiempo es 2.5 segundos asi que corresponde a 0 minutos y 2.5 segundos)
      expect(pbTime, equals("0:02.50"));
    });
  });
}
