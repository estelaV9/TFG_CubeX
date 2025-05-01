/// Clase que define las coordenadas y dimensiones del perimetro de resaltado.
///
/// Esta clase se utiliza para especificar una seccion destacada de la interfaz
/// durante el turorial.
class HighlightPosition {
  /// Distancia desde la parte superior del contenedor.
  final double? top;

  /// Distancia desde el borde derecho del contenedor.
  final double? right;

  /// Distancia desde la parte inferior del contenedor.
  final double? bottom;

  /// Distancia desde el borde izquierdo del contenedor.
  final double? left;

  /// Ancho de la caja de resaltado.
  final double? width;

  /// Altura de la caja de resaltado.
  final double? height;

  const HighlightPosition({
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.width,
    this.height,
  });
} // CLASE QUE DEFINE EL PERIMETRO DE LA CAJA DE RESALTADO