import 'package:esteladevega_tfg_cubex/color/app_color.dart';
import 'package:flutter/material.dart';

class FieldForm extends StatelessWidget {
  final Icon icon; // EL ICONO QUE SE VA A USAR
  final String labelText; // TEXTO DEL FORMULARIO
  final String hintText; // TEXTO QUE VA A APARECER CUANDO SE PULSA

  final _formKey = GlobalKey<FormState>(); // CLAVE GLOBAL PARA EL FORM
  final _nameController = TextEditingController();

  FieldForm({super.key,
      required this.icon,
      required this.labelText,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          height: 50,
          // A LOS LADOS TIENE UN MARGEN DE 20
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.lightVioletColor,
            borderRadius: BorderRadius.circular(100),

            // AÑADIMOS EL EFECTO DE "drop shadow"
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // COLOR DE LA SOMBRA
                spreadRadius: 2, // LARGURA DE LA SOMBRA
                blurRadius: 5, // EFECTO BLUR DE LA SOMBRA
                offset: const Offset(2, 4), // DONDE SE VA A COLOCAR HORIZONTAL Y VERTICALMENTE
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                icon,

                // ESPACIO ENTRE EL ICONO Y EL FORMULARIO
                const SizedBox(width: 20),

                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: labelText,
                        hintText: hintText,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill in this field.';
                        } // VALIDAR SI EL CAMPO NO ESTA VACIO
                        return null;
                      },
                    ),
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
