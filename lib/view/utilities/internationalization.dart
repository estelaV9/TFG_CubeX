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

  /// Crea un widget de texto internacionalizado con accesibilidad.
  ///
  /// Este método es como un "atajo" más simple del metodo `createLocalizedSemantics`
  /// para generar un widget `Semantics`.
  ///
  /// Es útil cuando no se requieren etiquetas o hints, asi se puede reutilizar
  /// una misma clave para todos los campos de accesibilidad y no repetir codigo.
  ///
  /// Parámetros:
  /// - [context]: El contexto actual de la aplicación.
  /// - [key]: Clave de localización que se usa como etiqueta, hint y contenido.
  /// - [style]: Estilo aplicado al widget `Text`.
  Widget localizedTextOnlyKey(BuildContext context, String key, {required TextStyle style}) {
    return Internationalization.internationalization.createLocalizedSemantics(
      context, key, key, key, style,
    );
  }

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
      'copy_scramble': () => l10n.copy_scramble,
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
      'general_statistics': () => l10n.general_statistics,
      'best_single': () => l10n.best_single,
      'worst_single': () => l10n.worst_single,
      'solve_count': () => l10n.solve_count,
      'dnf_count': () => l10n.dnf_count,
      'plus_two_count': () => l10n.plus_two_count,
      'dnf_percentage': () => l10n.dnf_percentage,
      'plus_two_percentage': () => l10n.plus_two_percentage,
      'total_solve_time': () => l10n.total_solve_time,
      'tooltip_best_single': () => l10n.tooltip_best_single,
      'semantic_best_single': () => l10n.semantic_best_single,
      'tooltip_worst_single': () => l10n.tooltip_worst_single,
      'semantic_worst_single': () => l10n.semantic_worst_single,
      'tooltip_solve_count': () => l10n.tooltip_solve_count,
      'semantic_solve_count': () => l10n.semantic_solve_count,
      'tooltip_dnf_count': () => l10n.tooltip_dnf_count,
      'semantic_dnf_count': () => l10n.semantic_dnf_count,
      'tooltip_plus_two_count': () => l10n.tooltip_plus_two_count,
      'semantic_plus_two_count': () => l10n.semantic_plus_two_count,
      'tooltip_dnf_percentage': () => l10n.tooltip_dnf_percentage,
      'semantic_dnf_percentage': () => l10n.semantic_dnf_percentage,
      'tooltip_plus_two_percentage': () => l10n.tooltip_plus_two_percentage,
      'semantic_plus_two_percentage': () => l10n.semantic_plus_two_percentage,
      'tooltip_total_solve_time': () => l10n.tooltip_total_solve_time,
      'semantic_total_solve_time': () => l10n.semantic_total_solve_time,
      'performance_over_time': () => l10n.performance_over_time,
      'yearly': () => l10n.yearly,
      'monthly': () => l10n.monthly,
      'daily': () => l10n.daily,
      'graph_orientation': () => l10n.graph_orientation,
      'toggle_times_visibility': () => l10n.toggle_times_visibility,
      'average_analysis': () => l10n.average_analysis,
      'average_analysis_label': () => l10n.average_analysis_label,
      'average_analysis_hint': () => l10n.average_analysis_hint,
      'current': () => l10n.current,
      'current_label': () => l10n.current_label,
      'current_hint': () => l10n.current_hint,
      'average': () => l10n.average,
      'average_label': () => l10n.average_label,
      'average_hint': () => l10n.average_hint,
      'ao5': () => l10n.ao5,
      'ao5_label': () => l10n.ao5_label,
      'ao5_hint': () => l10n.ao5_hint,
      'ao12': () => l10n.ao12,
      'ao12_label': () => l10n.ao12_label,
      'ao12_hint': () => l10n.ao12_hint,
      'ao50': () => l10n.ao50,
      'ao50_label': () => l10n.ao50_label,
      'ao50_hint': () => l10n.ao50_hint,
      'ao100': () => l10n.ao100,
      'ao100_label': () => l10n.ao100_label,
      'ao100_hint': () => l10n.ao100_hint,
      'aoTotal': () => l10n.aoTotal,
      'aoTotal_hint': () => l10n.aoTotal_hint,
      'aoTotal_label': () => l10n.aoTotal_label,
      'best': () => l10n.best,
      'best_label': () => l10n.best_label,
      'best_hint': () => l10n.best_hint,
      'worst': () => l10n.worst,
      'worst_label': () => l10n.worst_label,
      'worst_hint': () => l10n.worst_hint,
      'total_average': () => l10n.total_average,
      'total_average_label': () => l10n.total_average_label,
      'total_average_hint': () => l10n.total_average_hint,
      'session_deletion_failed_content': () => l10n.session_deletion_failed_content,
      'session_deletion_failed_content_label': () => l10n.session_deletion_failed_content_label,
      'session_deletion_failed_content_hint': () => l10n.session_deletion_failed_content_hint,
      'cube_deletion_failed_content': () => l10n.cube_deletion_failed_content,
      'cube_deletion_failed_content_label': () => l10n.cube_deletion_failed_content_label,
      'cube_deletion_failed_content_hint': () => l10n.cube_deletion_failed_content_hint,
      'enable_notifications_title': () => l10n.enable_notifications_title,
      'enable_notifications_label': () => l10n.enable_notifications_label,
      'enable_notifications_hint': () => l10n.enable_notifications_hint,
      'enable_notifications_description': () => l10n.enable_notifications_description,
      'enable_notifications_button_hint': () => l10n.enable_notifications_button_hint,
      'enable_notifications_button_title': () => l10n.enable_notifications_button_title,

      'daily_notifications_title': () => l10n.daily_notifications_title,
      'daily_notifications_description': () => l10n.daily_notifications_description,
      'daily_notifications_button_title': () => l10n.daily_notifications_button_title,
      'daily_notifications_button_hint': () => l10n.daily_notifications_button_hint,

      'weekly_motivation_title': () => l10n.weekly_motivation_title,
      'weekly_motivation_description': () => l10n.weekly_motivation_description,
      'weekly_motivation_button_title': () => l10n.weekly_motivation_button_title,
      'weekly_motivation_button_hint': () => l10n.weekly_motivation_button_hint,

      'new_record_notification_title': () => l10n.new_record_notification_title,
      'new_record_notification_description': () => l10n.new_record_notification_description,
      'new_record_notification_button_title': () => l10n.new_record_notification_button_title,
      'new_record_notification_button_hint': () => l10n.new_record_notification_button_hint,

      'training_reminders_title': () => l10n.training_reminders_title,
      'training_reminders_description': () => l10n.training_reminders_description,
      'training_reminders_button_title': () => l10n.training_reminders_button_title,
      'training_reminders_button_hint': () => l10n.training_reminders_button_hint,

      'weekly_summary_title': () => l10n.weekly_summary_title,
      'weekly_summary_description': () => l10n.weekly_summary_description,
      'weekly_summary_button_title': () => l10n.weekly_summary_button_title,
      'weekly_summary_button_hint': () => l10n.weekly_summary_button_hint,

      'inactivity_notification_title': () => l10n.inactivity_notification_title,
      'inactivity_notification_description': () => l10n.inactivity_notification_description,
      'inactivity_notification_button_title': () => l10n.inactivity_notification_button_title,
      'inactivity_notification_button_hint': () => l10n.inactivity_notification_button_hint,

      'weekly_stats_title': () => l10n.weekly_stats_title,
      'weekly_stats_description': () => l10n.weekly_stats_description,
      'weekly_stats_button_title': () => l10n.weekly_stats_button_title,
      'weekly_stats_button_hint': () => l10n.weekly_stats_button_hint,

      'hide_time_title': () => l10n.hide_time_title,
      'hide_time_description': () => l10n.hide_time_description,
      'hide_time_button_title': () => l10n.hide_time_button_title,
      'hide_time_button_hint': () => l10n.hide_time_button_hint,

      'record_time_alert_title': () => l10n.record_time_alert_title,
      'record_time_alert_description': () => l10n.record_time_alert_description,
      'record_time_alert_button_title': () => l10n.record_time_alert_button_title,
      'record_time_alert_button_hint': () => l10n.record_time_alert_button_hint,

      'best_average_alert_title': () => l10n.best_average_alert_title,
      'best_average_alert_description': () => l10n.best_average_alert_description,
      'best_average_alert_button_title': () => l10n.best_average_alert_button_title,
      'best_average_alert_button_hint': () => l10n.best_average_alert_button_hint,

      'worst_time_alert_title': () => l10n.worst_time_alert_title,
      'worst_time_alert_description': () => l10n.worst_time_alert_description,
      'worst_time_alert_button_title': () => l10n.worst_time_alert_button_title,
      'worst_time_alert_button_hint': () => l10n.worst_time_alert_button_hint,

      'inspection_title': () => l10n.inspection_title,
      'advanced_options_title': () => l10n.advanced_options_title,
      'empty_stats_title': () => l10n.empty_stats_title,
      'empty_stats_label': () => l10n.empty_stats_label,
      'empty_stats_hint': () => l10n.empty_stats_hint,
      'alerts': () => l10n.alerts,
      'inspection_description': () => l10n.inspection_description,
      'inspection_button_title': () => l10n.inspection_button_title,
      'inspection_button_hint': () => l10n.inspection_button_hint,
      'inspection_time_title': () => l10n.inspection_time_title,
      'inspection_time_description': () => l10n.inspection_time_description,
      'inspection_time_button_title': () => l10n.inspection_time_button_title,
      'inspection_time_button_hint': () => l10n.inspection_time_button_hint,
      'time_default': () => l10n.time_default,
      'time_default_label': () => l10n.time_default_label,
      'time_default_hint': () => l10n.time_default_hint,
      'inspection_time_form': () => l10n.inspection_time_form,
      'inspection_field_required': () => l10n.inspection_field_required,
      'inspection_only_numbers': () => l10n.inspection_only_numbers,
      'inspection_range_1_59': () => l10n.inspection_range_1_59,
      'inspection_advanced_title': () => l10n.inspection_advanced_title,
      'alert_at_8_12_title': () => l10n.alert_at_8_12_title,
      'alert_at_8_12_description': () => l10n.alert_at_8_12_description,
      'alert_at_8_12_button_title': () => l10n.alert_at_8_12_button_title,
      'alert_at_8_12_button_hint': () => l10n.alert_at_8_12_button_hint,
      'alert_type_title': () => l10n.alert_type_title,
      'alert_type_description': () => l10n.alert_type_description,
      'inspection_alert_vibrant_type': () => l10n.inspection_alert_vibrant_type,
      'inspection_alert_sound_type': () => l10n.inspection_alert_sound_type,
      'inspection_alert_both_type': () => l10n.inspection_alert_both_type,
      'delete': () => l10n.delete,
      'delete_selected_times_button': () => l10n.delete_selected_times_button,
      'close_selected_time': () => l10n.close_selected_time,
      'reset': () => l10n.reset,
      'reset_notifications_button': () => l10n.reset_notifications_button,
      'permission_required_title': () => l10n.permission_required_title,
      'permission_required_description': () => l10n.permission_required_description,
      'open_settings_button': () => l10n.open_settings_button,
      'notification_permissions_denied': () => l10n.notification_permissions_denied,

      'tour_intro_hello': () => l10n.tour_intro_hello,
      'tour_intro_welcome': () => l10n.tour_intro_welcome,
      'tour_intro_tour_question': () => l10n.tour_intro_tour_question,
      'tour_header': () => l10n.tour_header,
      'tour_cubeType': () => l10n.tour_cubeType,
      'tour_session': () => l10n.tour_session,
      'tour_scramble': () => l10n.tour_scramble,
      'tour_timer': () => l10n.tour_timer,
      'tour_quick_stats': () => l10n.tour_quick_stats,
      'tour_go_to_history': () => l10n.tour_go_to_history,
      'tour_history': () => l10n.tour_history,
      'tour_go_to_stats': () => l10n.tour_go_to_stats,
      'tour_stats': () => l10n.tour_stats,
      'tour_end_title': () => l10n.tour_end_title,
      'tour_end_message': () => l10n.tour_end_message,

      'form_error_minimum_8_characters': () => l10n.form_error_minimum_8_characters,
      'form_error_required_field': () => l10n.form_error_required_field,
      'form_error_no_spaces_allowed': () => l10n.form_error_no_spaces_allowed,
      'form_error_special_character_required': () => l10n.form_error_special_character_required,
      'form_error_number_required': () => l10n.form_error_number_required,
      'form_error_invalid_email': () => l10n.form_error_invalid_email,
      'form_error_passwords_do_not_match': () => l10n.form_error_passwords_do_not_match,
      'form_error_name_max_length': () => l10n.form_error_name_max_length,
      'dialog_exit_app_title': () => l10n.dialog_exit_app_title,
      'dialog_exit_app_message': () => l10n.dialog_exit_app_message,
      'comments': () => l10n.comments,
      'no_comments': () => l10n.no_comments,
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
