/// Clase que representa el contenido de un paso de un metodo.
/// Permite almacenar texto, imágenes, grids u otros componentes dinámicos.
class StepContent {
  /// Identificador único del contenido del paso
  int? idStepContent;

  /// Contenido del paso.
  String content;

  /// Tipo de contenido de widget (por si es un text, iamge, grid...).
  String type;

  /// Parámetros del componente en formato JSON (por ejemplo posiciones, colores, etc).
  Map<String, dynamic> data;

  /// Orden de aparición dentro del mismo paso.
  int? orderIndex;

  /// Identificador del paso asociado al metodo (opcional).
  int? idStep;

  /// Constructor para inicializar un contenido de paso.
  StepContent(
      {this.idStepContent,
      required this.content,
      required this.type,
      required this.data,
      this.orderIndex,
      this.idStep});

  @override
  String toString() {
    return 'StepContent{idStepContent: $idStepContent, content: $content, type: $type, data: $data, orderIndex: $orderIndex, idStep: $idStep}';
  }
}