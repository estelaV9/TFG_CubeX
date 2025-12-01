import 'package:shared_preferences/shared_preferences.dart';

/// Clase que representa un paso de un metodo de un cubo.
/// Contiene información como el título, número de paso y el metodo asociado.
class Step {
  /// Identificador único del paso
  int? idStep;

  /// Titulo del paso.
  String stepTitle;

  /// Numero del paso dentro del metodo (para ordenar los pasos)
  int stepNumber;

  /// Identificador del metodo al que pertenece el paso (opcional).
  int? idMethod;

  /// Constructor para inicializar un paso.
  Step(
      {this.idStep,
      required this.stepTitle,
      required this.stepNumber,
      this.idMethod});

  @override
  String toString() {
    return 'Step{idStep: $idStep, stepTitle: $stepTitle, stepNumber: $stepNumber, idMethod: $idMethod}';
  }

  /// Instancia de las preferencias.
  static late SharedPreferences preferences;

  /// Inicializa las preferencias compartidas con valores por defecto si aún no existen.
  static Future<void> startPreferences() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getKeys().isEmpty) {
      await preferences.setInt("idStep", -1);
      await preferences.setString("stepTitle", "");
      await preferences.setInt("stepNumber", -1);
      await preferences.setInt("idMethod", -1);
    }
  }

  /// Guarda los datos del paso actual en [SharedPreferences].
  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setInt("idStep", idStep!);
    await prefs.setString("stepTitle", stepTitle);
    await prefs.setInt("idMethod", idMethod!);
  }

  /// Recupera un objeto `Step` desde los datos guardados en `SharedPreferences`.
  static Step loadFromPreferences(SharedPreferences prefs) {
    return Step(
      idStep: prefs.getInt("idStep") ?? -1,
      stepTitle: prefs.getString("stepTitle") ?? "",
      stepNumber: prefs.getInt("stepNumber") ?? -1,
      idMethod: prefs.getInt("idMethod") ?? -1,
    );
  }
}