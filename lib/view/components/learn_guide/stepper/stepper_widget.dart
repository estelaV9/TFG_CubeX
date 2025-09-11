import 'package:flutter/material.dart';
import '../../../utilities/app_color.dart';
import '../../solid_line_painter.dart';

/// Widget personalizado del Stepper
///
/// Representa un "paso a paso" visual que se asemeja a un `Stepper` de Flutter, pero
/// con un diseño un poco más personalizado
///
/// Este widget:
/// - Muestra los pasos como círculos con iconos.
/// - Conecta los pasos mediante líneas.
/// - Permite al usuario navegar entre pasos al pulsar sobre los círculos.
/// - Expone callbacks para notificar al padre cuando se cambia de paso.
/// - Muestra un título y una descripción textual del paso actual.
///
/// NOTA: Actualmente los títulos y descripciones están predefinidos,
/// pero en un futuro se cargaran desde una base de datos
class StepperWidget extends StatefulWidget {
  /// Indice del paso actualmente seleccionado en el Stepper
  final int currentIndex;

  /// Callback que se ejecuta cuando se selecciona un paso diferente
  ///
  /// Recibe como parametro el indice del nuevo paso seleccionado, el cual
  /// permite al padre actualizar el estado del Stepper
  final Function(int) onStepChanged;

  /// Callback opcional que se ejecuta al intentar ir al paso anterior.
  ///
  /// Se puede dejar null si no se necesita la funcionalidad de retroceder.
  final VoidCallback? onPrevious;

  /// Callback opcional que se ejecuta al intentar avanzar al siguiente paso
  final VoidCallback? onNext;

  const StepperWidget({
    super.key,
    required this.currentIndex,
    required this.onStepChanged,
    this.onPrevious,
    this.onNext,
  });

  @override
  State<StepperWidget> createState() => StepperWidgetState();
}

class StepperWidgetState extends State<StepperWidget> {
  // CONTROLADOR DE LAS PAGINAS DEL STEPPER
  final PageController controller = PageController();

  /// Metodo que se ejecuta cuando el widget padre se actualiza
  ///
  /// Este método del ciclo de vida de Flutter se llama automáticamente
  /// cuando el `StepperWidget` recibe nuevas propiedades desde su padre
  /// y necesita comparar el estado anterior (`oldWidget`) con el actual.
  ///
  /// Funcionalidad principal:
  /// - Comprueba si el índice del paso (`currentIndex`) cambió en el padre.
  /// - Si cambió, utiliza el `PageController` para pasar al nuevo paso
  ///   correspondiente
  ///
  /// Parametros:
  /// - [oldWidget]: La versión anterior del `StepperWidget` antes de ser
  ///   actualizado por el framework
  ///
  /// Retorna:
  /// - `void`: No devuelve valor, solo actualiza la vista si es necesario
  @override
  void didUpdateWidget(StepperWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      if (controller.hasClients) {
        // ANIMACION DE LA TRANSICION DEL PageView HASTA EL NUEVO INDICE
        controller.animateToPage(
          widget.currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } // SOLO EJECUTAR SI EL PageController ESTA ASOCIADO A ALGUNA VISTA
    } // COMPROBAMOS SI EL INDICE ACTUAL DEL WIDGET PADRE CAMBIO
  }

  /// Metodo para liberar la memoria del controlador cuando el widget se elimina
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          // SECCION SUPERIOR DEL STEPPER: CIRCULOS + LINEAS CONECTORAS
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: _buildCustomStepper(),
          ),

          // SECCION INFERIOR DEL STEPPER: TITULO + DESCRIPCION DEL PASO ACTUAL
          Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITULO DEL PASO ACTUAL
                Text(
                  _getStepTitleOfStep(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // DESCRIPCION DEL PASO ACTUAL
                Text(
                  _getStepDescription(),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el stepper visual
  ///
  /// Cada paso tiene:
  /// - Un círculo con un icono representativo.
  /// - Un título que aparece debajo.
  /// - Una línea conectora si no es el último paso.
  ///
  /// Los colores cambian dependiendo del estado del paso:
  /// - COMPLETADO: pasos anteriores al actual.
  /// - ACTUAL: el paso en curso.
  /// - INACTIVO: pasos aún no alcanzados.
  Widget _buildCustomStepper() {
    // LISTA DE PASOS CON ICONO Y TITULO (PROVISIONAL)
    List<Map<String, dynamic>> steps = [
      {"icon": Icons.close, "title": "Cross"},
      {"icon": Icons.layers, "title": "1 Layer"},
      {"icon": Icons.layers_clear, "title": "2 Layer"},
      {"icon": Icons.rotate_right, "title": "Orient Last Layer"},
      {"icon": Icons.done_all, "title": "Permute Last Layer"},
    ];

    return Column(
      children: [
        // FILA SUPERIOR: CIRCULOS + LINEAS
        Row(
          children: [
            // RECORREMOS LOS PASOS QUE TENGA EL METODO
            for (int i = 0; i < steps.length; i++) ...[
              // CIRCULO DE PASO
              GestureDetector(
                onTap: () {
                  // NOTIFICAR AL PADRE EL NUEVO INDICE
                  widget.onStepChanged(i);
                },
                child: Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    // COLOR DEL CIRCULO SEGUN ESTADO
                    color:
                        // SI EL PASO YA SE COMPLETO
                        i < widget.currentIndex
                            ? AppColors.stepCompletedBackground
                            : // SI ES EL PASO ACTUAL
                            i == widget.currentIndex
                                ? AppColors.topColor
                                : // SI ESTA INACTIVO
                                AppColors.darkPurpleOpacity,

                    // BORDE DEL CIRCULO SEGUN ESTADO
                    border: Border.all(
                      color: // BORDE PARA EL ACTUAL
                          i == widget.currentIndex
                              ? AppColors.topColor
                              : // BORDE PARA COMPLETADOS
                              i < widget.currentIndex
                                  ? AppColors.stepBorderCompleted
                                  : // BORDE PARA INACTIVOS
                                  AppColors.stepBorderIncomplete,
                      width: 2,
                    ),
                  ),

                  // ICONO CENTRAL DENTRO DEL CIRCULO
                  child: Icon(
                    steps[i]["icon"],
                    color: // BLANCO SI ESTA COMPLETADO O ES EL ACTUAL
                        i <= widget.currentIndex
                            ? Colors.white
                            : // COLOR APAGADO SI INACTIVO
                            AppColors.stepBorderIncomplete,
                    size: 24,
                  ),
                ),
              ),

              // LINEA CONECTORA ENTRE PASOS (MENOS EL ULTIMO)
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 6),

                    // COLOR DE LA LINEA SEGUN ESTADO
                    decoration: BoxDecoration(
                      color: // COLOR SI YA SE PASO ESTE PASO
                          i < widget.currentIndex
                              ? AppColors.popoverBackground
                              : // COLOR APAGADO SI NO SE HA LLEGADO
                              AppColors.darkPurpleOpacity,
                    ),

                    // LINEA PINTADA PERSONALIZADA
                    child: CustomPaint(
                      painter: SolidLinePainter(
                        color: i < widget.currentIndex
                            ? AppColors.popoverBackground
                            : AppColors.darkPurpleOpacity,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        // FILA INFERIOR: TITULOS DE LOS PASOS
        Row(
          children: [
            for (int i = 0; i < steps.length; i++) ...[
              SizedBox(
                width: 50,
                child: Text(
                  steps[i]["title"],
                  style: TextStyle(
                    fontSize: 10,
                    // EL TITULO DEL PASO ACTUAL SE MUESTRA EN NEGRITA
                    fontWeight: i == widget.currentIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                    // COLOR CAMBIA SI EL PASO YA SE COMPLETO O ES EL ACTUAL
                    color: i <= widget.currentIndex
                        ? AppColors.topColor
                        : AppColors.stepTextColorIncomplete,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  // SI EL TEXTO ES LARGO, SE CORTA CON PUNTOS SUSPENSIVOS
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ESPACIO FLEXIBLE ENTRE TITULOS
              if (i < steps.length - 1) const Expanded(child: SizedBox()),
            ],
          ],
        ),
      ],
    );
  }

  /// Metodo que obtiene el titulo  del paso actual segun el indice
  ///
  /// nota: este metodo es provisional, en un futuro se extraera la informacion
  /// desde una base de datos
  String _getStepTitleOfStep() {
    switch (widget.currentIndex) {
      case 0:
        return "Configura la cruz inicial";
      case 1:
        return "Resuelve la primera capa";
      case 2:
        return "Resuelve la segunda capa";
      case 3:
        return "Orienta la última capa";
      case 4:
        return "Permuta la última capa";
      default:
        return "";
    }
  }

  /// Metodo que obtiene la descripcion del paso actual segun el indice
  ///
  /// nota: este metodo tambien es provisional
  String _getStepDescription() {
    switch (widget.currentIndex) {
      case 0:
        return "El primer objetivo es formar una cruz en la cara blanca del cubo. "
            "Para ello, debes colocar las cuatro aristas blancas en su posición correcta, de forma que coincidan tanto con el centro blanco como con los colores de los centros laterales. "
            "Es importante no solo fijarse en que la cara blanca forme una cruz, sino también que cada arista esté alineada con el color central de la cara adyacente. "
            "Por ejemplo, si colocas la arista blanco-azul, asegúrate de que el lado azul quede junto al centro azul. "
            "Cuando completes este paso, tendrás una cruz blanca perfectamente alineada con los centros de cada cara.";
      case 1:
        return "Resuelve la primera capa";
      case 2:
        return "Resuelve la segunda capa";
      case 3:
        return "Orienta la última capa";
      case 4:
        return "Permuta la última capa";
      default:
        return "";
    }
  }
}