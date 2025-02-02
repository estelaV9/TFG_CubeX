import 'dart:async';
import 'package:flutter/material.dart';
import '../../utilities/app_color.dart';

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

  @override
  void dispose() {
    _countDownTimer?.cancel();
    _timeTimer?.cancel();
    super.dispose();
  } // SE LIMIPIAN LOS TEMPORIZADORES AL SALIR PORQUE SI NO DA ERROR

  void startCountDown(int seconds) {
    _isCountingDown = true;
    _currentTime = seconds;

    _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        setState(() {
          _showTime = _currentTime.toString();
        });
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
    _auxTime = 0; // REINICIAMOS EL TIEMPO QUE SE HAYA TRANSCURRIDO
    _timeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _auxTime++; // INCREMENTAMOS EL TIEMPO EN DECIMAS DE SEGUNDO
        // SE ACTUALIZA EL TEXTO CON EL TIEMPO FORMATEADO
        _showTime = _formatTime();
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
    return Scaffold(
      body: GestureDetector(
        // CUANDO MANTIENE PRESIONADO INICIA EL TIEMPO DE INSPECCION
        /// nota: investigar si se puede mejorar este sistema y que se "mantenga
        /// pulsado" desde la otra pantalla
        onLongPress: () {
          if (!_isCountingDown) {
            // INICIAR CUENTA ATRAS DESDE 15 SEGUNDOS (como se inicializa en 15
            // y tarda un segundo en iniciar se deja en 14)
            startCountDown(14);
          }
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
          _timeTimer?.cancel(); // SE DETIENE CRONOMETRO
          Navigator.pop(context, _showTime); // SE REGRESA CON EL TIEMPO
        },
        child: Stack(
          children: [
            // FONDO DEGRADADO
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.upLinearColor,
                      AppColors.downLinearColor,
                    ],
                  ),
                ),
              ),
            ),

            // TEXTO QUE MUESTRA EL TIEMPO
            Center(
              child: Text(
                _showTime.isEmpty ? "15" : _showTime, // TEXTO INICIAL O TIEMPO
                style: const TextStyle(
                  fontSize: 55,
                  color: AppColors.darkPurpleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
