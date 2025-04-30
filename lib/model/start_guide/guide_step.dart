import 'highlight_position.dart';
import 'mascot_position.dart';

/// Clase que representa un paso individual dentro del tutorial inicial interactivo.
///
/// Esta clase se utiliza para definir los elementos visuales y funcionales
/// de cada paso del tutorial.
class GuideStep {
  /// Lista de claves que hacen referencia a los textos que se mostrarán en ese paso.
  final List<String> textKeys;

  /// Ruta de la imagen de la mascota que se mostrará.
  final String mascotAsset;

  /// Posición opcional que define el área que se debe resaltar en la interfaz.
  final HighlightPosition? highlightPosition;

  /// Indice de navegación opcional que permite cambiar la pantalla.
  final int? navigationIndex;

  /// Indica si este paso es el último de la guía.
  final bool isFinalStep;

  /// Posición opcional que determina dónde se ubica la mascota en la pantalla.
  final MascotPosition? mascotPosition;

  const GuideStep({
    required this.textKeys,
    required this.mascotAsset,
    this.highlightPosition,
    this.navigationIndex,
    required this.isFinalStep,
    this.mascotPosition,
  });
} // CLASE PARA DEFINIR LOS DATOS DE CADA PASO DE LA GUIA
