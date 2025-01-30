import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Internationalization {
  static Internationalization internationalization = Internationalization();

  Semantics createLocalizedSemantics(BuildContext context, String label,
      String hint, String l10nKey, TextStyle style) {
    // OBTIENE LAS TRADUCCIONES DEL CONTEXTO
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: _getLocalizedString(l10n, label),
      hint: _getLocalizedString(l10n, hint),
      child: Text(_getLocalizedString(l10n, l10nKey), style: style),
    );
  } // METODO PARA GENERAR UN SEMANTICS CON UN TEXTO PARA LA INTERNALIONALIZACION

  String _getLocalizedString(AppLocalizations l10n, String key) {
    switch (key) {
      case 'cube_x':
        return l10n.cube_x;
      case 'main_title':
        return l10n.main_title;
      case 'main_title_hint':
        return l10n.main_title_hint;

      case 'login_label':
        return l10n.login_label;
      case 'login_hint':
        return l10n.login_hint;

      case 'signup_label':
        return l10n.signup_label;
      case 'signup_hint':
        return l10n.signup_hint;

      case 'login_screen_title':
        return l10n.login_screen_title;
      case 'login_screen_title_label':
        return l10n.login_screen_title_label;
      case 'login_screen_title_hint':
        return l10n.login_screen_title_hint;

      case 'forgot_password':
        return l10n.forgot_password;
      case 'forgot_password_label':
        return l10n.forgot_password_label;
      case 'forgot_password_hint':
        return l10n.forgot_password_hint;

      case 'sign_in':
        return l10n.sign_in;
      case 'sign_in_label':
        return l10n.sign_in_label;
      case 'sign_in_hint':
        return l10n.sign_in_hint;

      case 'no_account':
        return l10n.no_account;
      case 'no_account_label':
        return l10n.no_account_label;
      case 'no_account_hint':
        return l10n.no_account_hint;

      case 'sign_up_button':
        return l10n.sign_up_button;
      case 'sign_up_button_label':
        return l10n.sign_up_button_label;
      case 'sign_up_button_hint':
        return l10n.sign_up_button_hint;

      case 'signup_screen_title':
        return l10n.signup_screen_title;
      case 'signup_screen_title_label':
        return l10n.signup_screen_title_label;
      case 'signup_screen_title_hint':
        return l10n.signup_screen_title_hint;

      case 'already_have_account':
        return l10n.already_have_account;
      case 'already_have_account_label':
        return l10n.already_have_account_label;
      case 'already_have_account_hint':
        return l10n.already_have_account_hint;

      case 'login_link':
        return l10n.login_link;
      case 'login_link_label':
        return l10n.login_link_label;
      case 'login_link_hint':
        return l10n.login_link_hint;

      case 'username':
        return l10n.username;
      case 'username_label':
        return l10n.username_label;
      case 'username_hint':
        return l10n.username_hint;

      case 'mail':
        return l10n.mail;
      case 'mail_label':
        return l10n.mail_label;
      case 'mail_hint':
        return l10n.mail_hint;

      case 'password':
        return l10n.password;
      case 'password_label':
        return l10n.password_label;
      case 'password_hint':
        return l10n.password_hint;

      case 'confirm_password':
        return l10n.confirm_password;
      case 'confirm_password_label':
        return l10n.confirm_password_label;
      case 'confirm_password_hint':
        return l10n.confirm_password_hint;

      // SI NO ENCUENTRA UNA TRADUCCION, DEVUELVE LA CLASE
      default:
        return key;
    } // SEGUN LA PALABRA QUE LE PASEMOS RETORNARA LA TRADUCCION DE ESA CLAVE
  } // METODO QUE OBTIENE LA TRADUCCION SEGUN LA CLASE (metodo axuliar)

  String getLocalizations(BuildContext context, String key) {
    // OBTIENE LAS TRADUCCIONES DEL CONTEXTO
    final l10n = AppLocalizations.of(context)!;
    return _getLocalizedString(l10n, key);
  } // METODO PARA DEVOLVER SOLO EL TEXTO DE LA TRADUCCION
}
