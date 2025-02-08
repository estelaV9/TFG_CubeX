import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';
import 'package:flutter/material.dart';

/// Componente de formulario con un **campo de texto**.
///
/// Este componente crea un formulario con un campo de texto, que incluye un
/// icono, un texto de etiqueta y un texto de sugerencia (hint).
/// Permite la validación del campo, la personalización de bordes y colores, y
/// también utiliza la accesibilidad del `Semantics` para mejorar la experiencia
/// de usuarios con discapacidades.
class FieldForm extends StatefulWidget {
  /// El icono que se mostrará junto al campo de texto.
  ///
  /// Este ícono se puede personalizar según la personalización del formulario.
  final Tooltip icon;

  /// El texto que se mostrará en el campo de formulario.
  ///
  /// Este texto aparece como la descripción del campo cuando está vacío.
  final String labelText;

  /// El texto de sugerencia (hint) que aparece cuando el campo está vacío.
  ///
  /// Este texto es opcional y puede dar pistas al usuario sobre el tipo de información
  /// que se debe ingresar en el campo.
  final String hintText;

  /// Controlador que gestiona el texto ingresado en el campo.
  final TextEditingController controller;

  /// Validador para verificar si el valor ingresado es válido.
  final FormFieldValidator<String> validator;

  /// Texto que se utiliza para la accesibilidad, proporcionando una descripción del campo.
  ///
  /// Se usa en la propiedad `label` de `Semantics` para ayudar a los usuarios con discapacidad visual.
  final String labelSemantics;

  /// Texto que se utiliza para la accesibilidad, proporcionando una pista sobre el contenido del campo.
  ///
  /// Se usa en la propiedad `hint` de `Semantics` para ayudar a los usuarios con discapacidad visual.
  final String hintSemantics;

  /// Tamaño de los bordes del campo de texto (opcional).
  ///
  /// Si no se proporciona, el tamaño del borde será el predeterminado de 100.
  final double? borderSize;

  /// Color de fondo del campo de texto (opcional).
  ///
  /// Si no se proporciona, el color de fondo será el predeterminado (violeta claro).
  final Color? colorBox;

  const FieldForm(
      {super.key,
      required this.icon,
      required this.labelText,
      required this.hintText,
      required this.controller,
      required this.validator,
      required this.labelSemantics,
      required this.hintSemantics, this.borderSize, this.colorBox});

  @override
  _FieldFormState createState() => _FieldFormState();
}

class _FieldFormState extends State<FieldForm> {
  @override
  Widget build(BuildContext context) {
    //ESTABLECEMOS EL BORDE Y EL COLOR SEGUN SI SE HA PASADO EL PARAMETRO O NO
    final borderSize = widget.borderSize ?? 100;
    final colorBox = widget.colorBox ?? AppColors.lightVioletColor;

    return Row(
      children: [
        Expanded(
            child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: colorBox,
            borderRadius: BorderRadius.circular(borderSize),

            // AÑADIMOS EL EFECTO DE "drop shadow"
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // COLOR DE LA SOMBRA
                spreadRadius: 2, // LARGURA DE LA SOMBRA
                blurRadius: 5, // EFECTO BLUR DE LA SOMBRA
                // DONDE SE VA A COLOCAR HORIZONTAL Y VERTICALMENTE
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                widget.icon,

                // ESPACIO ENTRE EL ICONO Y EL FORMULARIO
                const SizedBox(width: 20),

                Expanded(
                  child: Semantics(
                    label: widget.labelSemantics,
                    hint: widget.hintSemantics,
                    child: TextFormField(
                        key: widget.key,
                        controller: widget.controller,
                        decoration: InputDecoration(
                          labelText: widget.labelText,
                          hintText: widget.hintText,
                        ),
                        validator: widget.validator),
                  ),
                )
              ],
            ),
          ),
        ))
      ],
    );
  }
}
