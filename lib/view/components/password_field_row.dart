import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

/// Widget para un campo de formulario de contraseña.
///
/// Este widget permite mostrar u ocultar la contraseña mediante un icono de visibilidad
/// y también incluye validaciones y controladores para gestionar el texto de la contraseña.
///
/// La contraseña puede ser validada y guardada utilizando los métodos proporcionados por
/// los parámetros del formulario. Este widget también permite personalizar el diseño,
/// incluyendo el color del borde y el tamaño del borde.
class PasswordFieldForm extends StatefulWidget {
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

  /// Función que guarda la contraseña cuando el formulario es enviado y validado correctamente.
  final FormFieldValidator<String> passwordOnSaved;

  const PasswordFieldForm(
      {super.key,
      required this.icon,
      required this.labelText,
      required this.hintText,
      required this.controller,
      required this.validator,
      required this.passwordOnSaved,
      required this.labelSemantics,
      required this.hintSemantics, this.borderSize, this.colorBox});

  @override
  _PasswordFieldFormState createState() => _PasswordFieldFormState();
}

class _PasswordFieldFormState extends State<PasswordFieldForm> {
  // ATRIBUTO PARA CONTROLAR SI SE MUESTRA O NO LA CONTRASEÑA
  var _isObscure = true;

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
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: widget.labelText,
                          hintText: widget.hintText,
                        ),
                        validator: widget.validator,
                        onSaved: widget.passwordOnSaved),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    // CUANDO PRESIONE EL BOTON DE VER SE CAMBIARA EL ESTADO DEL ATRIBUTO "isObscure"
                    // DE ESTA FORMA CUANDO PULSE SE MOSTRARA/OCULTARA LA CONTRASEÑA
                    setState(() {
                      if (_isObscure) {
                        _isObscure = true; // SE CAMBIA A TRUE
                      } else {
                        _isObscure = false; // SE CAMBIA A FALSE
                      }
                      _isObscure = !_isObscure; // SE CAMBIA EL ESTADO
                    });
                  },
                  icon: _isObscure
                      ? IconClass.iconMaker(context,
                          Icons.visibility_off, "show_password")
                      : IconClass.iconMaker(context,
                          Icons.remove_red_eye, "hide_password"),
                  tooltip: _isObscure ? "Show password" : "Hide password",
                )
              ],
            ),
          ),
        ))
      ],
    );
  }
}
