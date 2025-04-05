import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Clase encargada de gestionar la **internacionalización** de la aplicación.
///
/// Esta clase permite la traducción de textos según el idioma seleccionado por el usuario.
/// A través de esta clase se accede a los textos localizados en la aplicación.
/// Se utiliza principalmente para gestionar la creación de textos traducidos en los
/// widgets de la UI.
///
/// También incluye soporte para la accesibilidad, proporcionando una integración
/// con los `semantics` para mejorar la experiencia de los usuarios con discapacidades.
class Internationalization {
  static Internationalization internationalization = Internationalization();

  /// Crea un widget `Semantics` con el texto traducido y accesibilidad.
  ///
  /// Este método genera un widget `Semantics` que incluye las traducciones
  /// correspondientes a los parámetros proporcionados (etiqueta)
  /// y representa con un `Text()` con estilos.
  ///
  /// [context] El contexto para obtener las traducciones.
  /// [label] La clave de la etiqueta de accesibilidad.
  /// [hint] La clave del hint de accesibilidad.
  /// [l10nKey] La clave para obtener la traducción del texto mostrado.
  /// [style] El estilo del texto.
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

  /// Obtiene la traducción para una clave específica.
  ///
  /// Este método busca la traducción correspondiente a la clave proporcionada
  /// dentro de las traducciones localizadas.
  ///
  /// [l10n] El objeto de localización que contiene las traducciones.
  /// [key] La clave para buscar la traducción.
  ///
  /// Retorna el texto traducido o la clave si no se encuentra la traducción.
  String _getLocalizedString(AppLocalizations l10n, String key) {
    // SE UTILIZA UN MAPA QUE ASOCIA LAS CLAVES CON LA LAMBDA QUE RETORNAN LAS CADENAS TRADUCIDAS
    final translations = {
      'cube_x': () => l10n.cube_x,
      'main_title': () => l10n.main_title,
      'main_title_hint': () => l10n.main_title_hint,
      'login_label': () => l10n.login_label,
      'login_hint': () => l10n.login_hint,
      'signup_label': () => l10n.signup_label,
      'signup_hint': () => l10n.signup_hint,
      'login_screen_title': () => l10n.login_screen_title,
      'login_screen_title_label': () => l10n.login_screen_title_label,
      'login_screen_title_hint': () => l10n.login_screen_title_hint,
      'forgot_password': () => l10n.forgot_password,
      'forgot_password_label': () => l10n.forgot_password_label,
      'forgot_password_hint': () => l10n.forgot_password_hint,
      'sign_in': () => l10n.sign_in,
      'sign_in_label': () => l10n.sign_in_label,
      'sign_in_hint': () => l10n.sign_in_hint,
      'no_account': () => l10n.no_account,
      'no_account_label': () => l10n.no_account_label,
      'no_account_hint': () => l10n.no_account_hint,
      'sign_up_button': () => l10n.sign_up_button,
      'sign_up_button_label': () => l10n.sign_up_button_label,
      'sign_up_button_hint': () => l10n.sign_up_button_hint,
      'signup_screen_title': () => l10n.signup_screen_title,
      'signup_screen_title_label': () => l10n.signup_screen_title_label,
      'signup_screen_title_hint': () => l10n.signup_screen_title_hint,
      'already_have_account': () => l10n.already_have_account,
      'already_have_account_label': () => l10n.already_have_account_label,
      'already_have_account_hint': () => l10n.already_have_account_hint,
      'login_link': () => l10n.login_link,
      'login_link_label': () => l10n.login_link_label,
      'login_link_hint': () => l10n.login_link_hint,
      'username': () => l10n.username,
      'username_label': () => l10n.username_label,
      'username_hint': () => l10n.username_hint,
      'mail': () => l10n.mail,
      'mail_label': () => l10n.mail_label,
      'mail_hint': () => l10n.mail_hint,
      'password': () => l10n.password,
      'password_label': () => l10n.password_label,
      'password_hint': () => l10n.password_hint,
      'confirm_password': () => l10n.confirm_password,
      'confirm_password_label': () => l10n.confirm_password_label,
      'confirm_password_hint': () => l10n.confirm_password_hint,
      'time_label': () => l10n.time_label,
      'time_hint': () => l10n.time_hint,
      'dnf': () => l10n.dnf,
      'dnf_label': () => l10n.dnf_label,
      'dnf_hint': () => l10n.dnf_hint,
      'plus_two': () => l10n.plus_two,
      'plus_two_label': () => l10n.plus_two_label,
      'plus_two_hint': () => l10n.plus_two_hint,
      'delete_cube_type_label': () => l10n.delete_cube_type_label,
      'delete_cube_type_hint': () => l10n.delete_cube_type_hint,
      'cube_type_deleted_successful': () => l10n.cube_type_deleted_successful,
      'cube_type_deletion_failed': () => l10n.cube_type_deletion_failed,
      'insert_new_type_label': () => l10n.insert_new_type_label,
      'insert_new_type_hint': () => l10n.insert_new_type_hint,
      'create_new_cube_type': () => l10n.create_new_cube_type,
      'select_cube_type': () => l10n.select_cube_type,
      'enter_new_cube_type': () => l10n.enter_new_cube_type,
      'add_custom_scramble_label': () => l10n.add_custom_scramble_label,
      'enter_new_scramble': () => l10n.enter_new_scramble,
      'delete_session_label': () => l10n.delete_session_label,
      'delete_session_hint': () => l10n.delete_session_hint,
      'session_not_found': () => l10n.session_not_found,
      'session_deleted_successful': () => l10n.session_deleted_successful,
      'session_deletion_failed': () => l10n.session_deletion_failed,
      'select_session_label': () => l10n.select_session_label,
      'create_new_session_label': () => l10n.create_new_session_label,
      'create_new_session_button': () => l10n.create_new_session_button,
      'create_new_session_hint': () => l10n.create_new_session_hint,
      'type_session_name': () => l10n.type_session_name,
      'account_created_successfully': () => l10n.account_created_successfully,
      'accept_label': () => l10n.accept_label,
      'accept_hint': () => l10n.accept_hint,
      'cancel_label': () => l10n.cancel_label,
      'cancel_hint': () => l10n.cancel_hint,
      'copied_successfully': () => l10n.copied_successfully,
      'new_type_inserted_successful': () => l10n.new_type_inserted_successful,
      'chosen_name_already_exists': () => l10n.chosen_name_already_exists,
      'add_scramble_empty': () => l10n.add_scramble_empty,
      'scramble_added_successful': () => l10n.scramble_added_successful,
      'add_session_name_empty': () => l10n.add_session_name_empty,
      'session_added_successful': () => l10n.session_added_successful,
      'failed_create_session': () => l10n.failed_create_session,
      'incorrect_username_password': () => l10n.incorrect_username_password,
      'error_creating_account': () => l10n.error_creating_account,
      'account_email_exists': () => l10n.account_email_exists,
      'username_already_in_use': () => l10n.username_already_in_use,
      'general': () => l10n.general,
      'timer': () => l10n.timer,
      'app_theme': () => l10n.app_theme,
      'my_profile': () => l10n.my_profile,
      'championship': () => l10n.championship,
      'versus': () => l10n.versus,
      'other': () => l10n.other,
      'settings': () => l10n.settings,
      'about_the_app': () => l10n.about_the_app,
      'log_out': () => l10n.log_out,
      'show_password': () => l10n.show_password,
      'hide_password': () => l10n.hide_password,
      'github': () => l10n.github,
      'go_github': () => l10n.go_github,
      'enter_app': () => l10n.enter_app,
      'delete_account': () => l10n.delete_account,
      'save_data': () => l10n.save_data,
      'edit_button': () => l10n.edit_button,
      'delete_time': () => l10n.delete_time,
      'add_comment': () => l10n.add_comment,
      'add_scramble_manual': () => l10n.add_scramble_manual,
      'reset_scramble': () => l10n.reset_scramble,
      'more_option': () => l10n.more_option,
      'add_new_time': () => l10n.add_new_time,
      'add_penalty': () => l10n.add_penalty,
      'date': () => l10n.date,
      'search_time': () => l10n.search_time,
      'choose_session': () => l10n.choose_session,
      'choose_cube_type': () => l10n.choose_cube_type,
      'description': () => l10n.description,
      'open_source': () => l10n.open_source,
      'version': () => l10n.version,
      'developer_name': () => l10n.developer_name,
      'developer_email': () => l10n.developer_email,
      'developer': () => l10n.developer,
      'tools': () => l10n.tools,
      'tools_list': () => l10n.tools_list,
      'name_github': () => l10n.name_github,
      'time_configuration': () => l10n.time_configuration,
      'account': () => l10n.account,
      'languages': () => l10n.languages,
      'notification': () => l10n.notification,
      'select_notification': () => l10n.select_notification,
      'select_languages': () => l10n.select_languages,
      'configure_timer': () => l10n.configure_timer,
      'spanish': () => l10n.spanish,
      'spanish_hint': () => l10n.spanish_hint,
      'english': () => l10n.english,
      'english_hint': () => l10n.english_hint,
      'delete_time_correct': () => l10n.delete_time_correct,
      'delete_time_error': () => l10n.delete_time_error,
      'add_time_label': () => l10n.add_time_label,
      'add_time_hint': () => l10n.add_time_hint,
      'add_scramble_form_label': () => l10n.add_scramble_form_label,
      'add_scramble_form_hint': () => l10n.add_scramble_form_hint,
      'add_time_form_label': () => l10n.add_time_form_label,
      'add_time_form_hint': () => l10n.add_time_form_hint,
      'add_time_successfully': () => l10n.add_time_successfully,
      'add_time_error': () => l10n.add_time_error,
      'delete_user_successfully': () => l10n.delete_user_successfully,
      'delete_user_error': () => l10n.delete_user_error,
      'all_times_deletion_failed': () => l10n.all_times_deletion_failed,
      'all_times_deleted_successful': () => l10n.all_times_deleted_successful,
      'delete_all_times_hint': () => l10n.delete_all_times_hint,
      'delete_all_times_label': () => l10n.delete_all_times_label,
      'search_time_or_comments': () => l10n.search_time_or_comments,
      'update_user_successfully': () => l10n.update_user_successfully,
      'update_user_error': () => l10n.update_user_error,
      'exit_without_saving': () => l10n.exit_without_saving,
      'unsaved_changes_message': () => l10n.unsaved_changes_message,
      'insert_old_pass_label': () => l10n.insert_old_pass_label,
      'insert_old_pass_hint': () => l10n.insert_old_pass_hint,
      'old_pass_form_label': () => l10n.old_pass_form_label,
      'old_pass_form_hint': () => l10n.old_pass_form_hint,
      'old_pass_error': () => l10n.old_pass_error,
      'field_null': () => l10n.field_null,
      'confirm_pass_field_null': () => l10n.confirm_pass_field_null,
      'password_mismatch_error': () => l10n.password_mismatch_error,
      'actual_delete_time': () => l10n.actual_delete_time,
      'actual_delete_time_content': () => l10n.actual_delete_time_content,
      'add_comment_time': () => l10n.add_comment_time,
      'add_comment_time_content': () => l10n.add_comment_time_content,
      'time_saved_error': () => l10n.time_saved_error,
      'time_error': () => l10n.time_error,
      'share_not_implemented': () => l10n.share_not_implemented,
      'share_error': () => l10n.share_error,
      'pdf_generation_error': () => l10n.pdf_generation_error,
      'no_times_found': () => l10n.no_times_found,
      'pdf_saved_success': () => l10n.pdf_saved_success,
      'sort_by': () => l10n.sort_by,
      'date': () => l10n.date,
      'ascending': () => l10n.ascending,
      'descending': () => l10n.descending,
      'time': () => l10n.time,
      'close_popover': () => l10n.close_popover,
      'close_popover_hint': () => l10n.close_popover_hint,
      'ascending_hint': () => l10n.ascending_hint,
      'descending_hint': () => l10n.descending_hint,
      'order_date_hint': () => l10n.order_date_hint,
      'order_time_hint': () => l10n.order_time_hint,
    }; // SEGUN LA PALABRA QUE LE PASEMOS RETORNARA LA TRADUCCION DE ESA CLAVE

    // SI LA CLAVE NO EXISTE EN LA TRADUCCION, DEVUELVE LA CLAVE
    return translations[key]?.call() ?? key;
  } // METODO QUE OBTIENE LA TRADUCCION SEGUN LA CLASE (metodo axuliar)

  /// Devuelve solo el texto traducido de la clave proporcionada.
  ///
  /// Este método se utiliza cuando solo quieres obtener la traducción sin
  /// utilizar un widget `Semantics` completo.
  ///
  /// [context] El contexto para obtener las traducciones.
  /// [key] La clave para obtener la traducción.
  String getLocalizations(BuildContext context, String key) {
    // OBTIENE LAS TRADUCCIONES DEL CONTEXTO
    final l10n = AppLocalizations.of(context)!;
    return _getLocalizedString(l10n, key);
  } // METODO PARA DEVOLVER SOLO EL TEXTO DE LA TRADUCCION
}
