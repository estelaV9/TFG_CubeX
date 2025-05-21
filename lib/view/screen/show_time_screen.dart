import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/model/configuration_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../viewmodel/current_time.dart';
import '../../viewmodel/settings_option/current_configure_timer.dart';
import '../../viewmodel/settings_option/current_language.dart';
import '../utilities/app_styles.dart';

/// Pantalla que muestra un cronómetro con o sin tiempo de inspección previa.
/// - Muestra penalizaciones (+2 o DNF) si se excede el tiempo de inspección.
/// - Se puede ocultar el tiempo durante la resolución.
/// - El tiempo de inspección y visibilidad de la resolución son configurables por el usuario.
/// - Si las alertas están activadas, se reproducirá un sonido y/o se activará una vibración
/// cuando el tiempo de inspección llegue a los ocho o doce segundos.
class ShowTimeScreen extends StatefulWidget {
  const ShowTimeScreen({super.key});

  @override
  State<ShowTimeScreen> createState() => _ShowTimeScreenState();
}

class _ShowTimeScreenState extends State<ShowTimeScreen> {
  String _showTime = ""; // TEXTO QUE SE MUESTRA EN PANTALLA
  int _currentTime = 15; // TIEMPO DE CUENTA ATRAS INICIAL
  Timer? _countDownTimer; // TEMPORIZADOR PARA LA CUENTA ATRAS
  Timer? _timeTimer; // TEMPORIZADOR PARA EL CRONOMETRO
  int _auxTime = 0; // TIEMPO TRANSCURRIDO EN EL CRONOMETRO
  bool _isCountingDown = false; // ESTADO DE CUENTA ATRAS
  bool _isTimeRunning = false; // ATRIBUTO PARA SABER SI HA EMPEZADO A CRONOMETRARSE

  late CurrentTime currentTime;

  // PARA REPRODUCIR LAS ALERTAS
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // EJECUTA LA FUNCION DESPUES DE QUE EL FRAME ACTUAL TERMINE DE CONSTRUIRSE,
    // ASI NO CAUSA ERRORES DURANTE EL BUILD PARA HACER CAMBIOS EN EL STATE O EN PROVIDERS
    // (se soluciona el mensaje de error cuando pulsas en el timer de setState() or
    // markNeedsBuild() called during build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final confi = Provider.of<CurrentConfigurationTimer>(context, listen: false).configurationTimer;
      if (!confi.isActiveInspection) {
        // SI EL USUARIO TIENE PUESTO QUE NO DESEA TENER EL TIEMPO DE INSPECCION SE ACTIVA
        // EL CRONOMETRO
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _countDownTimer?.cancel();
    _timeTimer?.cancel();
    _isTimeRunning = false;
    super.dispose();
  } // SE LIMIPIAN LOS TEMPORIZADORES AL SALIR PORQUE SI NO DA ERROR

  /// Método para iniciar la cuenta atrás de la inspección.
  ///
  /// Este método gestiona el tiempo de inspección, comenzando desde los segundos
  /// proporcionados y reduciéndolos hasta que llega a cero. Durante la inspección, si
  /// el tiempo alcanza los valores ocho o doce segundos y esta activa las alertas,
  /// se realizará una alerta dependiendo de la configuración seleccionada por el
  /// usuario (vibración y/o sonido).
  ///
  /// Parámetros:
  /// - `seconds`: El número de segundos desde los cuales comenzará la cuenta atrás.
  void startCountDown(int seconds) async {
    _isCountingDown = true;
    _currentTime = seconds;
    final confi = context.read<CurrentConfigurationTimer>().configurationTimer;
    final locale = context.read<CurrentLanguage>().locale;

    _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_currentTime > 0) {
        setState(() {
          _showTime = _currentTime.toString();
        });

        if (confi.alertAt8And12Seconds && (_currentTime == 8 || _currentTime == 12)) {
          if (confi.inspectionAlertType == InspectionAlertType.vibrant ||
              confi.inspectionAlertType == InspectionAlertType.both) {
            // HACE QUE VIBRE UN SEGUNDO
            Vibration.vibrate(duration: 1000);
          } // SI EL TIPO DE ALERTA ES VIBRACION O AMBAS

          if (confi.inspectionAlertType == InspectionAlertType.sound ||
              confi.inspectionAlertType == InspectionAlertType.both) {
            try {
              if (_currentTime == 8) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await audioPlayer.play(AssetSource(
                      // DEPENDIENDO EL IDIOMA, REPRODUCE UNO U OTRO
                      locale.languageCode == "en"
                          ? "sound_alerts/eight_seconds.mp3"
                          : "sound_alerts/ocho_segundos.mp3")
                  );
                });
              } // SI EL TIEMPO DE INSPECCION ES DE 8 SEGUNDOS

              if (_currentTime == 12) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await audioPlayer.play(AssetSource(
                      // DEPENDIENDO EL IDIOMA, REPRODUCE UNO U OTRO
                      locale.languageCode == "en"
                          ? "sound_alerts/twelve_seconds.mp3"
                          : "sound_alerts/doce_segundos.mp3"));
                });
              } // SI EL TIEMPO DE INSPECCION ES DE 12 SEGUNDOS
            } catch (e) {
              DatabaseHelper.logger.e("Error al reproducir el audio: $e");
            }
          } // SI EL TIPO DE ALERTA ES DE SONIDO O DE AMBAS
        } // SI ESTA ACTIVA LA ALERTA DE LOS 8 Y 12 SEGUNDOS

        _currentTime--; // REDUCIR TIEMPO
      } else if (_currentTime > -2) {
        // MUESTRA "+2" POR DOS SEGUNDOS
        setState(() {
          _showTime = "+2";
        });
        _currentTime--;
      } else {
        // SI SIGUE, TERMINA CON "DNF"
        setState(() {
          _showTime = "DNF";
        });
        _stopCountDown(); // SE DETIENE EL TEMPORIZADOR
        _isCountingDown = false;
        _countDownTimer?.cancel();
      } // DEPENDIENDO EL TIEMPO MOSTRAR EL TIEMPO O LAS PENALIZACIONES
    });
  } // METODO PARA INICIAR EL TIEMPO DE INSPECCION

  void _stopCountDown() {
    _isCountingDown = false; // DESACTIVAMOS CUENTA ATRAS
    _countDownTimer?.cancel(); // PARA EL TIMER
  } // METODO PARA DETENER EL TEMPORIZADOR

  void _startTimer() {
    // SE AVISA DE QUE EL CRONOMETRO HA COMENZADO
    _isTimeRunning = true;
    _auxTime = 0; // REINICIAMOS EL TIEMPO QUE SE HAYA TRANSCURRIDO
    _timeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _auxTime++; // INCREMENTAMOS EL TIEMPO EN DECIMAS DE SEGUNDO
        // SE ACTUALIZA EL TEXTO CON EL TIEMPO FORMATEADO
        _showTime = _formatTime();

        if (_auxTime == 35999) {
          // SI LLEGA A 59:59.9 SE PARA:
          // 59 MINUTOS = 3540 SEGUNDOS
          // 3540 * 10 = 35400 DECIMAS + (9.9 SEGUNDOS * 10 = 99 DECIMAS) = 35999
          _stopCountDown();
        } // VALIDACION POR SI SE PASA DE TIEMPO
      });
    });
  } // EMPIEZA EL TIMER

  String _formatTime() {
    int totalDeciseconds = _auxTime; // TIEMPO EN DECIMAS DE SEGUNDO
    int seconds = totalDeciseconds ~/ 10; // SEGUNDOS TOTALES
    int deciseconds = totalDeciseconds % 10; // DECIMAS DE SEGUNDO

    if (seconds < 60) {
      // MENOS DE UN MINUTO: MOSTRAR EN "SS.D"
      return "$seconds.$deciseconds";
    } else {
      // MAS DE UN MINUTO: FORMATEAR EN "MM:SS.D"
      int minutes = seconds ~/ 60; // MINUTOS
      seconds = seconds % 60; // SEGUNDOS RESTANTES
      return "$minutes:${seconds.toString().padLeft(2, '0')}.$deciseconds";
    } // DEPENDIENDO EL TIEMPO SE MUESTRA DE UNA FORMA U OTRA
  } // METODO PARA FORMATEAR EL TIEMPO

  @override
  Widget build(BuildContext context) {
    // OBTIENE LA CONFIGURACION ACTUAL DEL TIMER
    final configurationsTimer = context.watch<CurrentConfigurationTimer>().configurationTimer;

    return Scaffold(
      body: GestureDetector(
        // CUANDO MANTIENE PRESIONADO INICIA EL TIEMPO DE INSPECCION
        /// nota: investigar si se puede mejorar este sistema y que se "mantenga
        /// pulsado" desde la otra pantalla
        onLongPress: () {
          if (!_isCountingDown && configurationsTimer.isActiveInspection) {
            // INICIAR CUENTA ATRAS DESDE LOS SEGUNDOS DE INSPECCION ELEGIDOS POR EL USUARIO
            // (como se inicializa en los segundos puestos y tarda un segundo en iniciar se deja en -1)
            startCountDown(configurationsTimer.inspectionSeconds - 1);
          } // SI AL INSPECCION ESTA ACTIVA
        },

        // CUANDO TERMINA DE MANTENER, EMPIEZA LA CUENTA ATRAS
        onLongPressEnd: (_) {
          if (_isCountingDown) {
            _stopCountDown(); // DETIENE TIEMPO DE INSPECCION
            _startTimer(); // SE INCIA EL CRONOMETRO
          }
        },
        // CUANDO SE PULSA, SE DENIENE EL CRONOMETRO Y SE REGRESA A LA PANTALLA PRINCIPAL
        onTap: () {
          // (controlar que cuando inicia y no ha hecho la inspeccion, el
          // usuario no de un tap y se salga del timer)
          if (_auxTime > 0) {
            _timeTimer?.cancel(); // SE DETIENE CRONOMETRO
            Navigator.pop(context, _showTime); // SE REGRESA CON EL TIEMPO
          } // SOLO PERMITE SALIRSE SI EL CRONOMETRO YA COMENZO
        },
        child: Stack(
          children: [
            // FONDO DEGRADADO
            Positioned.fill(
              child: Container(decoration: AppStyles.boxDecorationContainer()),
            ),

            // TEXTO QUE MUESTRA EL TIEMPO
            Center(
              child: Text(
                // SI EL TIEMPO PARA MOSTRAR NO ESTA VACIO Y LA INSPECCION ESTA ACTIVADA
                _showTime.isEmpty && configurationsTimer.isActiveInspection
                    ? // SE MUESTRA EN UN PRIMER INSTANTE LOS SEGUNDOS DE INSPECCION QUE TIENE EL USUARIO
                    configurationsTimer.inspectionSeconds.toString()
                    : // SI ESTA ACTIVADO EL ESCONDER EL TIEMPO Y ESTA CRONOMETRANDO
                    configurationsTimer.hideRunningTime && _isTimeRunning
                        ? "" // NO SE MUESTRA EL TIEMPO
                        : _showTime, // TEXTO INICIAL O TIEMPO
                style: AppStyles.darkPurpleAndBold(55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}