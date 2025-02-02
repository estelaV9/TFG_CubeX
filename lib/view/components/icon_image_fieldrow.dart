import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

class FieldForm extends StatefulWidget {
  final Tooltip icon; // EL ICONO QUE SE VA A USAR
  final String labelText; // TEXTO DEL FORMULARIO
  final String hintText; // TEXTO QUE VA A APARECER CUANDO SE PULSA
  final TextEditingController controller; // PASAMOS TAMBIEN EL CONTROLADOR
  final FormFieldValidator<String> validator; // PASAMOS LA VALIDACION
  final String labelSemantics; // TEXTO QUE TENDRA EL SEMANTIC
  final String hintSemantics; // TEXTO DEL HINT QUE TENDRA EL SEMANTIC


  final double? borderSize;
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
