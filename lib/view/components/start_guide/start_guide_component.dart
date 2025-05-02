import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/bottom_navigation.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/change_screen.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/internationalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import '../../../model/start_guide/guide_step.dart';
import '../../../model/start_guide/highlight_position.dart';
import '../../../model/start_guide/mascot_position.dart';
import '../../../viewmodel/settings_option/current_language.dart';

/// Clase que gestiona el componente del tutorial de introducción de la aplicación
/// cuando un usuario se crea una cuenta.
///
/// Esta clase se encarga de mostrar una secuencia de pasos guiados para enseñar
/// al usuario los componentes de la aplicacion y para que sirven, resaltado esos elementos y
/// permitiendo cambiar de idioma.
///
/// Los pasos de la guía están definidos con la clase [GuideStep] y pueden incluir:
/// - Texto animado.
/// - Una imagen de la mascota con una posicion.
/// - El elemento resaltado.
/// - Botones para continuar o saltar.
///
/// La guía se construye y muestra usando [SmartDialog] y puede adaptarse según el idioma
/// seleccionado por el usuario.
class StartGuideComponent {
  /// Contexto principal de la aplicación.
  late BuildContext _context;

  /// Lista de pasos definidos para la guía.
  late List<GuideStep> _guideSteps;

  /// Índice del paso actual del tutorial.
  int _currentStepIndex = 0;

  /// Atributos que indican los botones de selección de idioma.
  ValueNotifier<bool> isSelectedSpainNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSelectedEnglishNotifier = ValueNotifier<bool>(true);

  /// Valor que representa el idioma seleccionado, por defecto sera inglés.
  ValueNotifier<String> selectedLanguageNotifier = ValueNotifier<String>('en');

  /// Establece el idioma actual del tutorail.
  void setLanguage(String languageCode) {
    selectedLanguageNotifier.value = languageCode;
  }

  // CONSTANTES UTILIZADAS PARA CONFIGURACION DE LA GUIA
  static const _animationSpeed = Duration(milliseconds: 100);
  static const _pauseDuration = Duration(seconds: 1);
  static const _dialogTransitionDelay = Duration(milliseconds: 50);
  static const _defaultIconSize = 50.0;
  static const _defaultImageWidth = 150.0;
  static const _defaultMascotImageWidth = 200.0;
  static const _defaultHighlightBorderRadius = 10.0;

  // MAPA DE RUTAS DE IMAGENES PARA LAS MASCOTAS
  static const _mascotAssets = {
    'wave': "assets/cubix/cubix_wave.png",
    'curious': "assets/cubix/cubix_curious.png",
    'statistics': "assets/cubix/cubix_statistics.png",
    'session': "assets/cubix/cubix_session.png",
    'scramble': "assets/cubix/cubix_scramble.png",
    'inspection': "assets/cubix/cubix_inspection.png",
    'cubeTypes': "assets/cubix/cubix_cubetypes.png",
    'jump': "assets/cubix/cubix_jump.png",
    'einstein': "assets/cubix/cubix_einstein.png",
  };

  /// Constructor que inicializa el tutorial y el idioma en función del estado actual.
  StartGuideComponent(BuildContext context) {
    // SE ESTABLECE EL CONTEXTO
    _context = context;

    Locale currentLanguage = context.read<CurrentLanguage>().locale;
    if (currentLanguage.toLanguageTag() == "en") {
      isSelectedSpainNotifier.value = false;
      isSelectedEnglishNotifier.value = true;
    } else {
      isSelectedSpainNotifier.value = true;
      isSelectedEnglishNotifier.value = false;
    } // SE ESTABLECE EL IDIOMA

    // LISTA DE LOS PASOS DE LA GUIA
    _guideSteps = [
      // CADA OBJETO CONTIENE TEXTO, MASCOTA, POSICION DE HIGHLIGHT, NAVEGACION Y SI ES EL FINAL
      const GuideStep(
        textKeys: [
          "tour_intro_hello",
          "tour_intro_welcome",
          "tour_intro_tour_question"
        ],
        mascotAsset: 'wave',
        highlightPosition: null,
        navigationIndex: null,
        isFinalStep: false,
      ),
      const GuideStep(
        textKeys: ["tour_header"],
        mascotAsset: 'curious',
        highlightPosition: HighlightPosition(top: 35, right: 15, height: 73),
        navigationIndex: null,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
      const GuideStep(
        textKeys: ["tour_cubeType"],
        mascotAsset: 'cubeTypes',
        highlightPosition:
            HighlightPosition(top: 48, right: 75, width: 40, height: 40),
        navigationIndex: null,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
      const GuideStep(
        textKeys: ["tour_session"],
        mascotAsset: 'session',
        highlightPosition:
            HighlightPosition(top: 48, right: 30, width: 40, height: 40),
        navigationIndex: null,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
      const GuideStep(
        textKeys: ["tour_scramble"],
        mascotAsset: 'scramble',
        highlightPosition: HighlightPosition(
            top: 100, left: 10, right: 10, width: 40, height: 156),
        navigationIndex: null,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 20),
      ),
      const GuideStep(
        textKeys: ["tour_timer"],
        mascotAsset: 'inspection',
        highlightPosition: HighlightPosition(
            top: 260, bottom: 160, left: 10, right: 10, width: 40, height: 40),
        navigationIndex: null,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
      const GuideStep(
        textKeys: ["tour_quick_stats"],
        mascotAsset: 'statistics',
        highlightPosition: HighlightPosition(
            bottom: 65, left: 10, right: 10, width: 40, height: 90),
        navigationIndex: null,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 20),
      ),
      GuideStep(
        textKeys: ["tour_go_to_history"],
        mascotAsset: 'wave',
        highlightPosition: HighlightPosition(
            bottom: 13,
            left: _calculateHighlightPosition(_context, 0),
            width: 40,
            height: 40),
        navigationIndex: null,
        isFinalStep: false,
      ),
      const GuideStep(
        textKeys: ["tour_history"],
        mascotAsset: 'wave',
        highlightPosition: null,
        navigationIndex: 0,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
      GuideStep(
        textKeys: ["tour_go_to_stats"],
        mascotAsset: 'wave',
        highlightPosition: HighlightPosition(
            bottom: 13,
            right: _calculateHighlightPosition(_context, 2, fromRight: true),
            width: 40,
            height: 40),
        navigationIndex: null,
        isFinalStep: false,
      ),
      const GuideStep(
        textKeys: ["tour_stats"],
        mascotAsset: 'statistics',
        highlightPosition: null,
        navigationIndex: 2,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
      const GuideStep(
        textKeys: ["tour_end_title"],
        mascotAsset: 'jump',
        highlightPosition: null,
        navigationIndex: 1,
        isFinalStep: false,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
      const GuideStep(
        textKeys: ["tour_end_message"],
        mascotAsset: 'einstein',
        highlightPosition: null,
        navigationIndex: 1,
        isFinalStep: true,
        mascotPosition: MascotPosition(top: 200, right: 40),
      ),
    ];
  }

  /// Calcula la posición para el resaltado de los botones de la navegacion inferior.
  double _calculateHighlightPosition(BuildContext context, int index,
      {bool fromRight = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    // SE DIVIDE ENTRE LAS 3 PANTALLAS QUE HAY EN EL BOTTOMNAV
    final itemWidth = screenWidth / 3;

    // SE CALCULA LA POSICION
    double leftPosition = (itemWidth * index) + (itemWidth - 40) / 2;

    if (fromRight) {
      return screenWidth - leftPosition - 40; // AJUSTE PARA EL RIGHT
    } else {
      return leftPosition;
    }
  }

  /// Muestra la interfaz del paso actual del tutorial con mascota, texto y botones.
  void show(BuildContext context) async {
    _context = context;
    await _replaceDialog(() {
      return SmartDialog.show(builder: (_) {
        return Stack(
          children: [
            _buildIntroText(context),
            Positioned(
                top: 40,
                left: 40,
                child: Row(
                  children: [
                    // Spanish flag
                    ValueListenableBuilder<bool>(
                      // ESCUCHA LOS VALORES DEL SELECTEDSPAINT
                      valueListenable: isSelectedSpainNotifier,
                      // EL CONSTRUCTOR SE EJECTURA CADA VEZ QUE EL VALOR DEL SELECTEDSPAIN
                      // CAMBIA
                      builder: (context, isSelectedSpain, child) {
                        return GestureDetector(
                          onTap: () {
                            isSelectedSpainNotifier.value = true;
                            isSelectedEnglishNotifier.value = false;
                            context.read<CurrentLanguage>().cambiarIdioma('es');
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              border: Border.all(
                                color: Colors.white,
                                width: isSelectedSpain ? 3 : 0,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Image.asset("assets/flag/spain_flag.png",
                                width: 60),
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 40),

                    // English Flag
                    ValueListenableBuilder<bool>(
                      // ESCUCHA LOS VALORES DEL SELECTEDENGLISH
                      valueListenable: isSelectedEnglishNotifier,
                      // EL CONSTRUCTOR SE EJECTURA CADA VEZ QUE EL VALOR DEL SELECTEDENGLISH
                      // CAMBIA
                      builder: (context, isSelectedEnglish, child) {
                        return GestureDetector(
                          onTap: () {
                            isSelectedEnglishNotifier.value = true;
                            isSelectedSpainNotifier.value = false;
                            context.read<CurrentLanguage>().cambiarIdioma('en');
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              border: Border.all(
                                color: Colors.white,
                                width: isSelectedEnglish ? 3 : 0,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Image.asset("assets/flag/english_flag.png",
                                width: 60),
                          ),
                        );
                      },
                    ),
                  ],
                )),
            _buildContinueButton(context),
            _buildSkipButton(),
            _buildMascotImage(),
          ],
        );
      });
    });
    await Future.delayed(const Duration(milliseconds: 1000));
  } // METODO PARA MOSTRAR EL PRIMER DIALOGO DE LA GUIA

  /// Reemplaza cualquier diálogo actual con el nuevo paso.
  Future<void> _replaceDialog(Future<void> Function() showDialog) async {
    await SmartDialog.dismiss();
    await Future.delayed(_dialogTransitionDelay);
    await showDialog();
  } // METODO PARA REEMPLAZAR EL DIALOGO MOSTRADO ACTUALMENTE

  /// Construye el widget que contiene los textos animados traducidos
  /// para el paso actual.
  Widget buildAnimatedTextKit(BuildContext context, List<String> texts) {
    return ValueListenableBuilder<String>(
      // ESCUCHA LOS CAMBIOS DEL LENGUAGE SELECCIONADO
      valueListenable: selectedLanguageNotifier,
      builder: (context, languageCode, _) {
        // MAPEA EL TEXTO A UN TEXTO ANIMADO
        List<AnimatedText> animatedTexts = texts.map((text) {
          return TypewriterAnimatedText(
            Internationalization.internationalization
                .getLocalizations(context, text),
            speed: _animationSpeed,
          );
        }).toList();

        // APLCIA UN ESTILO AL TEXTO ANIMADO
        return DefaultTextStyle(
          style: const TextStyle(fontSize: 30.0, fontFamily: 'Console'),
          child: AnimatedTextKit(
            // SE REPITE SIEMPRE
            repeatForever: true,
            // PAUSA ESTABLECIDA ENTRE CADA TEXTO
            pause: _pauseDuration,
            // LISTA DE TEXTOS A MOSTRAR
            animatedTexts: animatedTexts,
          ),
        );
      },
    );
  } // CONSTRUYE LA ANIMACION DE TEXTO CON LAS CLAVES DE TEXTO TRADUCIDAS

  /// Construye el texto introductorio del primer paso.
  Widget _buildIntroText(BuildContext context) => Positioned(
        top: 165,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: SizedBox(
              width: 300.0,
              child: buildAnimatedTextKit(
                  context, _guideSteps[_currentStepIndex].textKeys)),
        ),
      ); // TEXTO INTRODUCTORIO

  /// Botón para continuar al siguiente paso del tutorial.
  Widget _buildContinueButton(BuildContext context) => Positioned(
        bottom: 95,
        left: 40,
        right: 100,
        child: ElevatedButton(
          onPressed: () async {
            SmartDialog.dismiss();
            await _moveToNextStep(context);
          },
          child: const Text("Continue"),
        ),
      ); // BOTON PARA CONTINUAR

  /// Botón para saltarse el tutorial
  Widget _buildSkipButton() => Positioned(
        bottom: 80,
        right: 20,
        child: IconButton(
          onPressed: () {
            SmartDialog.dismiss();
          },
          tooltip: "Skip the tutorial",
          icon: const Icon(Icons.skip_next,
              size: _defaultIconSize, color: Colors.white),
        ),
      ); // BOTON PARA SALTARSE LA GUIA

  /// Botón para finalizarlo.
  Widget _buildFinalButton() => Positioned(
        bottom: 95,
        left: 40,
        right: 40,
        child: ElevatedButton(
          onPressed: () async {
            SmartDialog.dismiss();
          },
          child: const Text("Finish"),
        ),
      ); // BOTON PARA CERRAR LA GUIA

  /// Muestra la imagen de la mascota del paso actual en la posición definida.
  Widget _buildMascotImage() {
    final step = _guideSteps[_currentStepIndex];
    final position = step.mascotPosition;

    if (position != null) {
      return Positioned(
        top: position.top,
        right: position.right,
        child: Image.asset(
          _mascotAssets[step.mascotAsset]!,
          width: _defaultImageWidth,
        ),
      );
    }
    return Align(
      alignment: Alignment.centerRight,
      child: Image.asset(_mascotAssets[step.mascotAsset]!,
          width: _defaultMascotImageWidth),
    );
  } // MUESTRA LA IMAGEN DE LA MASCOTA SEGUN LA CONFIGURACION DEL PASO

  /// Caja iluminada utilizada para resaltar elementos en la interfaz.
  Widget _highlightBox({double? width = 40, double? height = 40}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_defaultHighlightBorderRadius),
          color: Colors.white,
        ),
      ); // LUZ PARA ENFOCAR EL ELEMENTO A MOSTRAR

  /// Avanza al siguiente paso del tutorial, navegación si es necesario.
  Future<void> _moveToNextStep(BuildContext context) async {
    _currentStepIndex++;
    if (_currentStepIndex >= _guideSteps.length) {
      return;
    } // EVITAR QUE SE ACCEDA A UN PASO QUE NO EXISTE EN LA LISTA

    final step = _guideSteps[_currentStepIndex];

    if (step.navigationIndex != null) {
      ChangeScreen.changeScreen(
          BottomNavigation(index: step.navigationIndex!), context);
    } // CAMBIA DE PANTALLA SI EL PASO LO INDICA

    // ESPERA ANTES DE MOSTRAR EL SIGUIENTE DIALOGO
    await Future.delayed(_animationSpeed);

    // CREA EL RESALTADO SI ESTA DEFINIDO
    Positioned? positionedHighlight;
    if (step.highlightPosition != null) {
      final pos = step.highlightPosition!;
      double width = pos.width ?? 40.0;
      double height = pos.height ?? 40.0;

      // CALCULA EL ANCHO PARA EL PASO DEL HEADER
      if (step.textKeys.contains("tour_header")) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        width = screenWidth < 380 ? 245.0 + 10 : screenWidth * 0.75 + 10;
      }

      positionedHighlight = Positioned(
        top: pos.top,
        right: pos.right,
        bottom: pos.bottom,
        left: pos.left,
        child: _highlightBox(
          width: width,
          height: height,
        ),
      );
    }

    // MUESTRA EL DIALOGO DEL PASO ACTUAL
    await _replaceDialog(() {
      return SmartDialog.showAttach(
        // CONTEXTO DONDE SE EJECUTARA EL DIALOGO
        targetContext: context,
        alignment: Alignment.center,
        // EVITA QUE AL CLICKAR FUERA SE CIERRE EL DIALOGO
        clickMaskDismiss: false,
        // ASEGURA QUE SOLO HAY UN DIALOGO ACTIVO (importante)
        keepSingle: true,
        // USA LA ANIMACION DE DESFALLECIMIENTO AL MOSTRA EL DIALOGO
        animationType: SmartAnimationType.fade,
        // SI HAY UNA POSICION DE RESALTADO LO CONSTRUYE EN ESA PARTE PROPORCIONADA
        highlightBuilder: positionedHighlight != null
            ? (_, __) => positionedHighlight!
            : null,
        builder: (_) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                _buildMascotImage(),
                Positioned(
                  bottom: 240,
                  left: 40,
                  right: 40,
                  child: buildAnimatedTextKit(context, step.textKeys),
                ),
                // SI ES EL PASO FINAL SE MUESTRA EL BOTON DE FINALIZAR
                step.isFinalStep
                    ? _buildFinalButton()
                    : _buildContinueButton(context),
                // SI NO NO ES EL ULTIMO PASO, SE MUESTRA EL BOTON DE SALTAR
                !step.isFinalStep ? _buildSkipButton() : const Text(""),
              ],
            ),
          );
        },
      );
    });
  } // PASA AL SIGUIENTE PASO DE LA GUIA
}