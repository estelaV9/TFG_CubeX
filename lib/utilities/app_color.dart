import 'dart:ui';

/// Clase que contiene la paleta de colores utilizada en la aplicación.
///
/// Esta clase define constantes de color estáticas que se usan para
/// decorar toda la interfaz de usuario, facilitando así el esquema de colores.
/// Los colores están definidos mediante valores hexadecimales.
class AppColors {
  /// Color púrpura utilizado en la pantalla de introducción sobretodo.
  static const Color purpleIntroColor = Color(0xFFa88ee7);

  /// Color púrpura para los títulos principales de la aplicación.
  static const Color titlePurple = Color(0xFF8112DD);

  /// Color superior del degradado lineal (gradient).
  static const Color upLinearColor = Color(0xFF4C1787);

  /// Color inferior del degradado lineal (gradient).
  static const Color downLinearColor = Color(0xFFA88EE7);

  /// Tono de púrpura claro utilizado para los títulos de iniciar sesión y registrarse.
  static const Color lightPurpleColor = Color(0xFF8E4EE0);

  /// Tono violeta claro para fondos suaves o elementos resaltados.
  static const Color lightVioletColor = Color(0xFFC5B7E7);

  /// Color púrpura oscuro utilizado para fondos o textos.
  static const Color darkPurpleColor = Color(0xFF41135E);

  /// Variación de púrpura con un tono más cálido.
  static const Color purpleA172de = Color(0xFFa172de);

  /// Color de fondo para imágenes.
  static const Color imagenBg = Color(0xFFa384bd);

  /// Color que se aplica al pasar el ratón (hover) sobre elementos de lista.
  static const Color listTileHover = Color(0xFFc5b7e7);

  /// Color de los botones púrpuras en la interfaz.
  static const Color purpleButton = Color(0xFF8265a4);

  /// Color utilizado para destacar acciones críticas, como eliminar cuentas.
  static const Color deleteAccount = Color(0xFFf2a0ac);
}
