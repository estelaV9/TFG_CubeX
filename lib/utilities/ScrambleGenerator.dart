import 'dart:math';

class Scramble {
  static List<String> moves = [
    "U",
    "R",
    "B",
    "L",
    "D",
    "F"
  ]; // ARRAY CON LAS CAPAS QUE TIEN EL CUBO

  String generateScramble(int random) {
    String lastMove = "";
    List<String> scrambleList = [];

    for (int i = 0; i < random; i++) {
      // SE COGE UNA CAPA ALEATORIAMENTE
      String move = moves[Random().nextInt(moves.length)];

      // SE ASEGURA QUE EL MOVIMIENTO ACTUAL NO SEA IGUAL AL ANTERIOR,
      // ASI SE EVITA LAS REPETICIONES CONSECUTIVAS DEL MISMO MOVIMIENTO
      if (lastMove != "") {
        while (move.contains(lastMove)) {
          move = moves[Random().nextInt(moves.length)];
        } // CUANDO LA CAPA SEA IGUAL A LA ANTERIOR CAPA, SE COGE OTRA CAPA ALEATORIAMENTE

        //AGRGAMOS UN GIRO ADICIONAL OPCIONAL (como U', F2,.. )
        int randomMove = Random().nextInt(100);
        if (randomMove <= 30) {
          // SI ES MENOR O IGUAL A 30 SE LE COLOCA '
          scrambleList.add("$move'");
          // EN LASTMOVE SOLO SE GUARDA LA CAPA, SIN EL GIRO ADICIONAL
          lastMove = move;
        } else if (randomMove <= 60) {
          // SI NO ES MENOR O IGUAL A 30 Y ES MENOR O IGUAL A 60 SE LE COLOCA UN 2
          scrambleList.add("${move}2");
          lastMove = move;
        } else {
          // Y SI NO, SE AGREGA SOLO LA CAPA
          scrambleList.add(move);
          lastMove = move;
        }
      } else {
        // PARA EL PRIMER MOVIMIENTO SOLO SE AGREGA LA CAPA Y SE ESTABLECE LA ULTIMA CAPA
        scrambleList.add(move);
        lastMove = move;
      }
    }
    // SE CONVIERTE LA LISTA EN UNA CADENA CON ESPACIOS
    String scramble = scrambleList.join(" ");
    return scramble;
  }
}