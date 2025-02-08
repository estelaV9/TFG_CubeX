import 'dart:math';

/// Clase que genera secuencias aleatorias de movimientos de un cubo Rubik.
///
/// El **scramble** se utiliza para generar una secuencia aleatoria de movimientos
/// que sirven para deshacer el cubo Rubik. Esta secuencia sirve para cronometrar
/// el tiempo que un usuario tarda en resolver el cubo, ya que ofrece una manera
/// de "mezclar" el cubo de manera impredecible y controlada.
class Scramble {
  /// Lista estática que contiene las caras del cubo Rubik.
  /// Las caras son representadas por las letras:
  /// "U" (Up), "R" (Right), "B" (Back), "L" (Left), "D" (Down), "F" (Front).
  static List<String> moves = [
    "U",
    "R",
    "B",
    "L",
    "D",
    "F"
  ]; // ARRAY CON LAS CAPAS QUE TIEN EL CUBO

  /// Genera una secuencia aleatoria de movimientos para el cubo Rubik.
  ///
  /// Este método genera una secuencia de movimientos aleatorios (sobretodo para la categoría de 3x3),
  /// donde cada movimiento está compuesto por una de las caras del cubo (de la lista `moves`), y se le añade
  /// aleatoriamente un giro adicional como `'` o `2` (con probabilidades de 30% y 30% respectivamente).
  /// El parámetro `random` define cuántos movimientos se generarán en la secuencia.
  ///
  /// Se asegura de que no haya movimientos consecutivos repetidos.
  ///
  /// [random] El número de movimientos a generar.
  ///
  /// Retorna la secuencia de movimientos generada como un String, donde los movimientos
  /// están separados por un espacio.
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