import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

class PasswordFieldForm extends StatefulWidget {
  final Icon icon; // EL ICONO QUE SE VA A USAR
  final String labelText; // TEXTO DEL FORMULARIO
  final String hintText; // TEXTO QUE VA A APARECER CUANDO SE PULSA
  final TextEditingController controller; // PASAMOS TAMBIEN EL CONTROLADOR
  final FormFieldValidator<String> validator; // PASAMOS LA VALIDACION
  final FormFieldValidator<String> passwordOnSaved;

  const PasswordFieldForm({super.key,
    required this.icon,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.passwordOnSaved});

  @override
  _PasswordFieldFormState createState() => _PasswordFieldFormState();
}

class _PasswordFieldFormState extends State<PasswordFieldForm> {
  // ATRIBUTO PARA CONTROLAR SI SE MUESTRA O NO LA CONTRASEÑA
  var _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.lightVioletColor,
                borderRadius: BorderRadius.circular(100),

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
                        icon: const Icon(Icons.remove_red_eye))
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
