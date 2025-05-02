import 'package:flutter/material.dart';
import '../../utilities/internationalization.dart';

/// Componente reutilizable de `ListTile` con `Switch`.
///
/// Este widget muestra un `ListTile` compuesto por un título, una descripción y
/// un `Switch` para activar o desactivar la opción correspondiente.
///
/// Parámetros:
/// - [titleKey]: Clave de localizacion para obtener los textos internacionalizados.
/// - [value]: Valor booleano actual del `Switch`.
/// - [onChanged]: Función que se ejecuta cuando el usuario cambia el valor del `Switch`.
///
/// Este componente se utiliza sobretodo en las opciones de configuración de la pantalla
/// de ajustes.
class OptionSwitchTile extends StatelessWidget {
  final String titleKey;
  final bool value;
  final void Function(bool)? onChanged;

  const OptionSwitchTile({
    super.key,
    required this.titleKey,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Internationalization.internationalization.localizedTextOnlyKey(
        context,
        "${titleKey}_title",
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      ),
      subtitle: Internationalization.internationalization.localizedTextOnlyKey(
        context,
        "${titleKey}_description",
        style: TextStyle(
            fontSize: 15, color: Colors.white.withOpacity(0.85), height: 1.4),
      ),
      trailing: Semantics(
        label: Internationalization.internationalization
            .getLocalizations(context, "${titleKey}_button_hint"),
        child: Tooltip(
          message: Internationalization.internationalization
              .getLocalizations(context, "${titleKey}_button_title"),
          child: Switch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}