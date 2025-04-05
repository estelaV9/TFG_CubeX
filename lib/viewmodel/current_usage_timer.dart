import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider para gestionar el **tiempo de uso de la aplicacion**.
///
/// Esta clase se encarga de contar el tiempo que el usuario ha estado utilizando la aplicacion,
/// almacena el tiempo en segundos y proporciona metodos para iniciar, detener y reiniciar el contador.
/// Cada vez que el tiempo cambia, notifica a los listeners.
class CurrentUsageTimer with ChangeNotifier, WidgetsBindingObserver {
  int _secondsUsed = 0; // TIEMPO TOTAL EN SEGUNDOS
  bool _isRunning = false; // FLAG PARA SABER SI ESTA CONTANDO
  Timer? _timer; // TIMER PARA CONTAR SEGUNDOS

  /// Agrega un obsevador del ciclo de vida y carga el tiempo
  CurrentUsageTimer() {
    WidgetsBinding.instance.addObserver(this);
    _loadTime(); // CARGA EL TIEMPO AL INICIO
  }

  /// Obtiene el tiempo actual en segundos.
  int get secondsUsed => _secondsUsed;

  /// Método que inicia el contador solo si la app esta activa
  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _secondsUsed++; // INCREMENTA EL TIEMPO CADA SEGUNDO
        notifyListeners(); // NOTIFICA A LA UI SOBRE EL CAMBIO DE ESTADO
      });
    }
  }

  /// Método para detener el contador.
  void stop() {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel(); // DETIENE EL TIMER
      _saveTime(); // GUARDA EL TIEMPO ACTUAL EN SHARED PREFERENCES
    }
  }

  /// Método que reinicia el contador a 0.
  void reset() {
    _secondsUsed = 0; // RESTABLECE EL TIEMPO A CERO
    notifyListeners(); // NOTIFICA A LA UI SOBRE EL CAMBIO DE ESTADO
    _saveTime(); // GUARDA EL TIEMPO ACTUAL EN SHARED PREFERENCES
  }

  /// Método que carga el tiempo almacenado en el SharedPreferences.
  Future<void> _loadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _secondsUsed =
        prefs.getInt('usage_time') ?? 0; // OBTIENE EL TIEMPO ALMACENADO
    notifyListeners(); // NOTIFICA A LA UI SOBRE EL CAMBIO DE ESTADO
  }

  /// Método que guarda el tiempo en el SharedPreferences.
  Future<void> _saveTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usage_time', _secondsUsed); // ALMACENA EL TIEMPO ACTUAL
  }

  /// Método que detecta cuando la app se abre o se minimiza
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      start(); // SI LA APP SE ABRE, SE REANUDA EL CONTADOR
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      stop(); // SI LA APP SE MINIMIZA, SE DETIENE EL CONTADOR
    }
  }

  /// Método `dispose()` que elimina el obsevador y cancela el timer
  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // ELIMINA EL OBSERVADOR DEL CICLO DE VIDA
    _timer?.cancel(); // CANCELA EL TIMER
    super.dispose(); // LLAMA AL METODO DE DISPONER DE LA SUPERCLASE
  }

  /// Método para formatear el tiempo en años, meses, dias y horas.
  static String formatTime(int seconds) {
    int years = seconds ~/ (365 * 24 * 3600); // CALCULA LOS AÑOS
    int remainingSeconds = seconds % (365 * 24 * 3600);

    int months = remainingSeconds ~/ (30 * 24 * 3600); // CALCULA LOS MESES
    remainingSeconds %= (30 * 24 * 3600);

    int days = remainingSeconds ~/ (24 * 3600); // CALCULA LOS DIAS
    remainingSeconds %= (24 * 3600);

    int hours = remainingSeconds ~/ 3600; // CALCULA LAS HORAS

    // DEVUELVE EL TIEMPO FORMATEADO EN UNA CADENA
    if (years > 0) {
      return "${years}a ${months}m ${days}d";
    } else if (months > 0) {
      return "${months}m ${days}d";
    } else if (days > 0) {
      return "${days}d ${hours}h";
    } else {
      return hours == 1 ? "$hours hora" : "$hours horas";
    }
  }
}