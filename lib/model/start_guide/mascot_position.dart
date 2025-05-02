/// Clase que representa la posición de la imagen de la mascota en la pantalla.
///
/// Se utiliza para colocar la imagen de la mascota en una posicion especifica
/// durante un paso del tutorial.
class MascotPosition {
  ///Distancia desde la parte superior del contenedor.
  final double top;

  /// Distancia desde el borde derecho del contenedor.
  final double right;

  const MascotPosition({
    required this.top,
    required this.right,
  });
} // CLASE PARA POSICIONAR LA MASCOTA EN LA PANTALLA