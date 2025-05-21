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

  /// Lista estática que contiene las caras del cubo Skewb.
  /// Las caras que se pueden mover en este cubo son:
  /// "U" (Up), "R" (Right), "B" (Back), "L" (Left).
  static List<String> movesSkewb = [
    "U",
    "R",
    "B",
    "L",
  ];

  /// Lista estática que contiene las caras del cubo Megaminx.
  /// Las caras disponibles para este tipo de cubo son:
  /// "U" (Up), "R" (Right), "D" (Down).
  static List<String> movesMegaminx = [
    "U",
    "R",
    "D",
  ];

  /// Lista estática que contiene las caras del cubo Rubik 4x4.
  /// Incluye movimientos de caras simples y dobles:
  /// "U", "D", "L", "R", "F", "B" (caras externas),
  /// "Uw", "Dw", "Lw", "Rw", "Fw", "Bw" (capas dobles o "wide moves").
  static List<String> moves4x4 = [
    "U",
    "D",
    "L",
    "R",
    "F",
    "B",
    "Uw",
    "Dw",
    "Lw",
    "Rw",
    "Fw",
    "Bw"
  ];

  /// Genera una secuencia aleatoria de movimientos para el cubo Rubik.
  ///
  /// Este método genera una secuencia de movimientos aleatorios (sobretodo para la categoría de 3x3),
  /// donde cada movimiento está compuesto por una de las caras del cubo (de la lista `moves`), y se le añade
  /// aleatoriamente un giro adicional como `'` o `2` (con probabilidades de 30% y 30% respectivamente).
  /// El parámetro `random` define cuántos movimientos se generarán en la secuencia.
  ///
  /// Se asegura de que no haya movimientos consecutivos repetidos.
  ///
  /// Parámetros:
  /// - [random] El número de movimientos a generar.
  /// - [isSkewb]: Atributo para saber si se esta generando el scramble del skewb.
  ///
  /// Retorna la secuencia de movimientos generada como un String, donde los movimientos
  /// están separados por un espacio.
  String generateScramble32Skewb(int random, [bool isSkewb = false]) {
    String lastMove = "";
    List<String> scrambleList = [];

    for (int i = 0; i < random; i++) {
      // SE COGE UNA CAPA ALEATORIAMENTE
      String move = isSkewb
          ? movesSkewb[Random().nextInt(movesSkewb.length)]
          : moves[Random().nextInt(moves.length)];

      // SE ASEGURA QUE EL MOVIMIENTO ACTUAL NO SEA IGUAL AL ANTERIOR,
      // ASI SE EVITA LAS REPETICIONES CONSECUTIVAS DEL MISMO MOVIMIENTO
      if (lastMove != "") {
        while (move.contains(lastMove)) {
          move = moves[
              Random().nextInt(isSkewb ? movesSkewb.length : moves.length)];
        } // CUANDO LA CAPA SEA IGUAL A LA ANTERIOR CAPA, SE COGE OTRA CAPA ALEATORIAMENTE

        //AGRGAMOS UN GIRO ADICIONAL OPCIONAL (como U', F2,.. )
        int randomMove = Random().nextInt(100);
        if (isSkewb ? randomMove <= 50 : randomMove <= 30) {
          // SI ES MENOR O IGUAL A 30 SE LE COLOCA '
          scrambleList.add("$move'");
          // EN LASTMOVE SOLO SE GUARDA LA CAPA, SIN EL GIRO ADICIONAL
          lastMove = move;
        } else if (isSkewb == false) {
          // SI NO ES EL SCRAMBLE DEL SKEBW ENTONCES SE LE AÑADE EL MOVIMIENTO ADICIONAL '2'
          if (randomMove <= 60) {
            // SI NO ES MENOR O IGUAL A 30 Y ES MENOR O IGUAL A 60 SE LE COLOCA UN 2
            scrambleList.add("${move}2");
            lastMove = move;
          }
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

  /// Genera un scramble aleatorio para el puzzle Square-1.
  ///
  /// Este método crea una secuencia de movimientos del Square-1, donde cada
  /// movimiento consiste en una rotación superior e inferior seguida de un giro
  /// de eje (`/`). Los valores de rotación se generan aleatoriamente entre -6 y 5.
  ///
  /// Parámetros:
  /// - [num]: Número de pares de movimientos (rotaciones + giro de eje) que se generarán.
  ///
  /// Retorna:
  /// - Un `String` con los movimientos del scramble separados por espacios.
  String generateScrambleSquare1(int num) {
    List<String> scramble = [];
    Random random = Random();

    for (int i = 0; i < num; i++) {
      // GENERA UN NUMERO ALEATORIO ENTRE -6 Y 5 PARA LA ROTACION DE LA PARTE SUPERIOR
      int top = random.nextInt(12) - 6;

      // GENERA UN NUMERO ALEATORIO ENTRE -6 Y 5 PARA LA ROTACION DE LA PARTE INFERIOR
      int bottom = random.nextInt(12) - 6;

      // AÑADE EL MOVIMIENTO EN FORMATO (top,bottom)
      scramble.add("($top,$bottom)");

      // AÑADE UN GIRO DE EJE "/"
      scramble.add("/");
    }
    return scramble.join(" ");
  }

  /// Genera un scramble aleatorio para el cubo Megaminx.
  ///
  /// Este método crea una secuencia de movimientos basada en una distribución
  /// de las capas "R", "D" y "U", dando mayor probabilidad a "R" y "D",
  /// y menor a "U". Los movimientos generados incluyen variaciones como
  /// `++`, `--`, y `'`.
  ///
  /// Parámetros:
  /// - [random]: Número total de movimientos que debe tener el scramble generado.
  ///
  /// Retorna:
  /// - Un `String` con los movimientos del scramble separados por espacios.
  ///
  /// Características:
  /// - "R" y "D" tienen el doble de probabilidad de aparecer.
  /// - "U" aparece con probabilidad normal.
  /// - Cada movimiento puede tener una variación aleatoria:
  ///   - 50% de probabilidad de que sea `++` (doble giro horario).
  ///   - 50% de probabilidad de que sea `--` (doble giro antihorario).
  ///   - Si el movimiento es "U", se convierte en un `'`.
  String generateScrambleMegaminx(int random) {
    List<String> scramble = [];
    List<String> ponderadaMov = [];

    for (var move in movesMegaminx) {
      if (move == "R" || move == "D") {
        // R Y D TIENEN UN 10-20% MAS DE PROBABILIDADES DE SALIR
        // APARECEN DOS VECES
        ponderadaMov.add(move);
        ponderadaMov.add(move);
      } else if (move == "U") {
        // U TIENE UN 10-20% MENOS DE PROBABILIDADES, NO SE DUPLICA
        ponderadaMov.add(move);
      }
    }

    for (int i = 0; i < random; i++) {
      // SE COGE UNA CAPA ALEATORIAMENTE
      String move = ponderadaMov[Random().nextInt(ponderadaMov.length)];

      //AGRGAMOS UN GIRO ADICIONAL OPCIONAL (como U', R++, D--...)
      int randomMove = Random().nextInt(100);
      if (randomMove <= 50) {
        // SI ES MENOR O IGUAL A 50 SE LE COLOCA ++
        // SI EL MOVIMIENTO ES U ENTONCES SE LE PONE UN '
        move == "U" ? scramble.add("$move'") : scramble.add("$move++");
      } else {
        scramble.add("$move--");
      }
    }
    return scramble.join(" ");
  }

  /// Genera un scramble aleatorio en función del tipo de cubo proporcionado.
  ///
  /// Este método selecciona un algoritmo de scramble específico dependiendo del tipo
  /// de cubo ingresado como parámetro. Cada tipo tiene su propia lógica y número
  /// de movimientos para generar un scramble realista.
  ///
  /// Parámetros:
  /// - [type]: El tipo de cubo para el cual se desea generar el scramble.
  ///
  /// Retorna:
  /// - Un `String` que representa la secuencia de movimientos (scramble) generada.
  String generateScramble(String type) {
    switch (type.toLowerCase()) {
      case "2x2x2":
        // USA LAS MISMAS CAPAS QUE EL 3X3 PERO CON 11 MOVIMIENTOS
        return generateScramble32Skewb(11);
      case "3x3x3":
        // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
        int random = (Random().nextInt(25 - 20 + 1) + 20);
        return generateScramble32Skewb(random);
      // case "4x4x4":
        // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
        // int random = (Random().nextInt(25 - 20 + 1) + 20);
        // return generateScramble4x4(random);
       // return "";
      case "skewb":
        // EL SCRAMBLE DEL SKEWB USA SOLO LAS CAPAS U, R, B, L Y SON 11 MOVIMIENTOS
        return generateScramble32Skewb(11, true);
      case "pyraminx":
        // EL SCRAMBLE ES EL MISMO QUE EL SKEWB SOLO QUE CON 9 MOVIMIENTOS
        return generateScramble32Skewb(9, true);
      case "square-1":
        return generateScrambleSquare1(11);
      case "megaminx":
        // EL MEGAMINX SE COMPONE DE 6 MOVIMIENTOS (R++. R--. D++, D--, U Y U')
        // LOS SIMBOLOS DE ++ O -- ES PORQUE EL MEGAMINX SIEMPRE SE MUEVE DOBLE

        // RANGO ENTRE 20 A 30 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
        int random = (Random().nextInt(30 - 20 + 1) + 20);
        return generateScrambleMegaminx(random);

      default:
        // RANGO ENTRE 20 A 25 MOVIMIENTOS DE CAPA PARA GENERAR EL SCRAMBLE
        int random = (Random().nextInt(25 - 20 + 1) + 20);
        return generateScramble32Skewb(random);
    }
  }
}