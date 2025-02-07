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

      case 'time_label':
        return l10n.time_label;
      case 'time_hint':
        return l10n.time_hint;

      case 'dnf':
        return l10n.dnf;
      case 'dnf_label':
        return l10n.dnf_label;
      case 'dnf_hint':
        return l10n.dnf_hint;

      case 'plus_two':
        return l10n.plus_two;
      case 'plus_two_label':
        return l10n.plus_two_label;
      case 'plus_two_hint':
        return l10n.plus_two_hint;

      case 'delete_cube_type_label':
        return l10n.delete_cube_type_label;

      case 'delete_cube_type_hint':
        return l10n.delete_cube_type_hint;

      case 'cube_type_deleted_successful':
        return l10n.cube_type_deleted_successful;
      case 'cube_type_deletion_failed':
        return l10n.cube_type_deletion_failed;

      case 'insert_new_type_label':
        return l10n.insert_new_type_label;
      case 'insert_new_type_hint':
        return l10n.insert_new_type_hint;
      case 'create_new_cube_type':
        return l10n.create_new_cube_type;
      case 'select_cube_type':
        return l10n.select_cube_type;

      case 'enter_new_cube_type':
        return l10n.enter_new_cube_type;

      case 'add_custom_scramble_label':
        return l10n.add_custom_scramble_label;

      case 'enter_new_scramble':
        return l10n.enter_new_scramble;

      case 'delete_session_label':
        return l10n.delete_session_label;
      case 'delete_session_hint':
        return l10n.delete_session_hint;

      case 'session_not_found':
        return l10n.session_not_found;

      case 'session_deleted_successful':
        return l10n.session_deleted_successful;
      case 'session_deletion_failed':
        return l10n.session_deletion_failed;

      case 'select_session_label':
        return l10n.select_session_label;
      case 'create_new_session_label':
        return l10n.create_new_session_label;
      case 'create_new_session_button':
        return l10n.create_new_session_button;
      case 'create_new_session_hint':
        return l10n.create_new_session_hint;
      case 'type_session_name':
        return l10n.type_session_name;

      case 'account_created_successfully':
        return l10n.account_created_successfully;

      case 'accept_label':
        return l10n.accept_label;

      case 'accept_hint':
        return l10n.accept_hint;
      case 'cancel_label':
        return l10n.cancel_label;
      case 'cancel_hint':
        return l10n.cancel_hint;

      case 'copied_successfully':
        return l10n.copied_successfully;

      case 'new_type_inserted_successful':
        return l10n.new_type_inserted_successful;
      case 'chosen_name_already_exists':
        return l10n.chosen_name_already_exists;

      case 'add_scramble_empty':
        return l10n.add_scramble_empty;
      case 'scramble_added_successful':
        return l10n.scramble_added_successful;

      case 'add_session_name_empty':
        return l10n.add_session_name_empty;
      case 'session_added_successful':
        return l10n.session_added_successful;

      case 'failed_create_session':
        return l10n.failed_create_session;

      case 'incorrect_username_password':
        return l10n.incorrect_username_password;

      case 'error_creating_account':
        return l10n.error_creating_account;
      case 'account_email_exists':
        return l10n.account_email_exists;
      case 'username_already_in_use':
        return l10n.username_already_in_use;

      case 'general':
        return l10n.general;
      case 'timer':
        return l10n.timer;
      case 'app_theme':
        return l10n.app_theme;
      case 'my_profile':
        return l10n.my_profile;

      case 'championship':
        return l10n.championship;
      case 'versus':
        return l10n.versus;

      case 'other':
        return l10n.other;
      case 'settings':
        return l10n.settings;
      case 'about_the_app':
        return l10n.about_the_app;

      case 'log_out':
        return l10n.log_out;

      case 'show_password':
        return l10n.show_password;
      case 'hide_password':
        return l10n.hide_password;
      case 'github':
        return l10n.github;
      case 'go_github':
        return l10n.go_github;
      case 'enter_app':
        return l10n.enter_app;
      case 'delete_account':
        return l10n.delete_account;
      case 'save_data':
        return l10n.save_data;
      case 'edit_button':
        return l10n.edit_button;

      case 'delete_time':
        return l10n.delete_time;
      case 'add_comment':
        return l10n.add_comment;
      case 'add_scramble_manual':
        return l10n.add_scramble_manual;
      case 'more_option':
        return l10n.more_option;
      case 'add_new_time':
        return l10n.add_new_time;
      case 'add_penalty':
        return l10n.add_penalty;
      case 'date':
        return l10n.date;
      case 'search_time':
        return l10n.search_time;
      case 'choose_session':
        return l10n.choose_session;
      case 'choose_cube_type':
        return l10n.choose_cube_type;

      case 'description':
        return l10n.description;
      case 'open_source':
        return l10n.open_source;
      case 'version':
        return l10n.version;
      case 'developer_name':
        return l10n.developer_name;
      case 'developer_email':
        return l10n.developer_email;
      case 'developer':
        return l10n.developer;
      case 'tools':
        return l10n.tools;
      case 'tools_list':
        return l10n.tools_list;
      case 'name_github':
        return l10n.name_github;

      case 'time_configuration':
        return l10n.time_configuration;
      case 'account':
        return l10n.account;
      case 'languages':
        return l10n.languages;
      case 'notification':
        return l10n.notification;
      case 'select_notification':
        return l10n.select_notification;
      case 'select_languages':
        return l10n.select_languages;
      case 'configure_timer':
        return l10n.configure_timer;

      case 'spanish':
        return l10n.spanish;
      case 'spanish_hint':
        return l10n.spanish_hint;
      case 'english':
        return l10n.english;
      case 'english_hint':
        return l10n.english_hint;

      case 'delete_time_correct':
        return l10n.delete_time_correct;
      case 'delete_time_error':
        return l10n.delete_time_error;

      case 'add_time_label':
        return l10n.add_time_label;
      case 'add_time_hint':
        return l10n.add_time_hint;
      case 'add_scramble_form_label':
        return l10n.add_scramble_form_label;
      case 'add_scramble_form_hint':
        return l10n.add_scramble_form_hint;
      case 'add_time_form_label':
        return l10n.add_time_form_label;
      case 'add_time_form_hint':
        return l10n.add_time_form_hint;

      case 'add_time_successfully':
        return l10n.add_time_successfully;
      case 'add_time_error':
        return l10n.add_time_error;

      case 'delete_user_successfully':
        return l10n.delete_user_successfully;
      case 'delete_user_error':
        return l10n.delete_user_error;

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
