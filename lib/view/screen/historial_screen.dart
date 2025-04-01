import 'dart:io';

import 'package:esteladevega_tfg_cubex/data/dao/time_training_dao.dart';
import 'package:esteladevega_tfg_cubex/data/database/database_helper.dart';
import 'package:esteladevega_tfg_cubex/view/components/card_time_historial.dart';
import 'package:esteladevega_tfg_cubex/view/components/search_time_container.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/dao/cubetype_dao.dart';
import '../../data/dao/session_dao.dart';
import '../../data/dao/user_dao.dart';
import '../../model/time_training.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../../viewmodel/current_user.dart';
import '../components/Icon/icon.dart';
import '../../view/components/cube_header_container.dart';
import '../../view/navigation/app_drawer.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';

import '../components/waves_painter/small_wave_container_painter.dart';
import 'package:pdf/widgets.dart' as pw;

/// Pantalla del historial
///
/// Esta clase muestra los tiempos de una sesión de un tipo de cubo determinado.
/// Se encuentra compuesta por:
/// - El header con la información sobre el tipo de cubo y la sesión que se está usando. Se ubica en la parte superior derecha.
/// - El contenedor para añadir un tiempo manualmente.
/// - Una lista de tarjetas que contiene los tiempos registrados para la sesión y cubo seleccionados.
///
/// También incluye un botón flotante que permite al usuario exportar y compartir los tiempos de la sesión:
/// - **Iconos:** Si el botón está cerrado, muestra el ícono de compartir. Si está abierto, muestra el ícono de cerrar.
/// - **Acciones:** Cuando se abre, se muestran opciones como:
///   - **Download:** Permite al usuario descargar el archivo PDF con los tiempos de la sesión.
///   - **Otros:** Muestra más opciones de compartir, que permite compartir el PDF en diferentes plataformas.
///
/// El `floatingActionButton` esta manejado por el widget `SpeedDial`.
class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // KEY PARA CONTROLLAR EL SCAFFOLD PARA EL DRAWER
      drawer: const AppDrawer(), // DRAWER
      body: Stack(
        children: [
          // FONDO DEGRADADO
          Positioned.fill(
              child: Container(
            decoration: const BoxDecoration(
              // COLOR DEGRADADO PARA EL FONDO
              gradient: LinearGradient(
                begin: Alignment.topCenter, // DESDE ARRIBA
                end: Alignment.bottomCenter, // HASTA ABAJO
                colors: [
                  // COLOR DE ARRIBA DEL DEGRADADO
                  AppColors.upLinearColor,
                  // COLOR DE ABAJO DEL DEGRADADO
                  AppColors.downLinearColor,
                ],
              ),
            ),
          )),

          Positioned(
            // UBICARLO EN LA ESQUINA SUPERIOR IZQUIERDA
            top: 0,
            left: 0,
            child: CustomPaint(
              painter: SmallWaveContainerPainter(
                backgroundColor: AppColors.lightVioletColor,
              ),
              child: SizedBox(
                width: 190, // ANCHO
                height: 97, // ALTO
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, top: 0),
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: IconClass.iconMaker(
                          context, Icons.settings, "settings", 26),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // CONTAINER DEL TIPO DE CUBO Y LA SESION UN POCO MAS ABAJO A LA DERECHA
          const Positioned(
            top: 43,
            right: 20,
            child: CubeHeaderContainer(),
          ),

          const Positioned(
            top: 110,
            right: 20,
            left: 20,
            child: SearchTimeContainer(),
          ),

          const Positioned(
            top: 175,
            right: 20,
            left: 20,
            bottom: 20,
            child: CardTimeHistorial(),
          ),
        ],
      ),

      floatingActionButton: SpeedDial(
        // SI NO HA PULSADO, SE PONE EL ICONO DE COMPARTIR, SI NO EL ICONO DE CERRAR
        icon: _isOpen ? Icons.close : Icons.share,
        backgroundColor: AppColors.speedDialButtonBackground,
        // CUANDO SE ABRE, LA PANTALLA SE TORNA DE UN BLANCO
        overlayColor: Colors.white12,
        // OPACIDAD DEL COLOR BLANCO
        overlayOpacity: 0.5,
        spacing: 10,
        // CUANDO SE ABRE, SE CAMBIA EL VALOR
        onOpen: () {
          setState(() {
            _isOpen = true;
          });
        },
        // CUANDO SE CIERRA SE CAMBIA EL VALOR
        onClose: () {
          setState(() {
            _isOpen = false;
          });
        },
        children: [
          SpeedDialChild(
            child: const Icon(Icons.download, color: Colors.white),
            label: "Download",
            backgroundColor: AppColors.imagenBg,
            onTap: () {
              convertPdf(context, ShareOption.download);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.more_horiz, color: Colors.white),
            label: "Otros",
            backgroundColor: Colors.blueGrey,
            onTap: () {
              convertPdf(context, ShareOption.moreOptions);
            },
          ),
        ],
      ),
    );
  }
}

/// Enum que define las opciones de compartir un archivo PDF.
///
/// - [download]: Guarda el archivo sin compartirlo.
/// - [moreOptions]: Permite compartir el archivo con otras aplicaciones.
enum ShareOption { download, moreOptions }

/// Metodo que genera y exporta un PDF con los tiempos de una sesión determinada.
///
/// Se obtiene la información del usuario, la sesión y el tipo de cubo
/// correspondiente para luego generar y guardar un archivo PDF. Dependiendo de
/// la opción de compartir seleccionada, se permite descargarlo o compartirlo.
///
/// ### Parámetros:
/// - [context]: Contexto de la aplicación para acceder a los datos y mostrar mensajes.
/// - [shareOption]: Indica si el archivo debe ser descargado o compartido.
///
/// ### Características:
/// - Si no se encuentra el usuario, la sesión o el tipo de cubo, el proceso se detiene.
/// - Si no hay tiempos registrados, se muestra un mensaje de error.
/// - Si ocurre un error al generar el PDF, se muestra un mensaje en pantalla.
Future<void> convertPdf(BuildContext context, ShareOption shareOption) async {
  try {
    // CONSEGUIR EL USUARIO ACTUAL
    final currentUser = context.read<CurrentUser>().user;
    final userDao = UserDao();
    final idUser = await userDao.getIdUserFromName(currentUser!.username);
    // VERIFICAR QUE NO DE ERROR
    if (idUser == -1) return;

    // CONSEGUIR LA SESION Y EL TIPO DE CUBO ACTUAL
    final currentSession = context.read<CurrentSession>();
    final currentCube = context.read<CurrentCubeType>();
    final cubeTypeDao = CubeTypeDao();
    final cubeType =
        await cubeTypeDao.cubeTypeDefault(currentCube.cubeType!.cubeName);
    // VERIFICAR QUE NO DE ERROR
    if (cubeType.idCube == -1) return;

    final sessionDao = SessionDao();
    final session = await sessionDao.getSessionByUserCubeName(
        idUser, currentSession.session!.sessionName, cubeType.idCube!);
    // VERIFICAR QUE NO DE ERROR
    if (session!.idSession == -1) return;

    // CONSEGUIR TODOS LOS TIEMPOS
    final timeTrainingDao = TimeTrainingDao();
    final times = await timeTrainingDao.getTimesOfSession(session.idSession);

    if (times.isEmpty) {
      AlertUtil.showSnackBarError(context, "no_times_found");
      return;
    } // VERIFICAR QUE NO ESTE VACIA

    // SE GENERAL EL PDF
    final pdf = await _generatePdf(currentSession, currentCube, times);
    await _pdfExport(context, pdf, currentSession.session!.sessionName,
        shareOption: shareOption);
  } catch (e) {
    DatabaseHelper.logger.e("Error al generar el PDF: $e");
    AlertUtil.showSnackBarError(context, "pdf_generation_error");
  }
}

/// Método que genera un documento PDF con los tiempos de una sesión determinada.
///
/// Este método crea un documento PDF con formato, incluyendo el nombre de la sesión,
/// el tipo de cubo, la fecha actual y los tiempos registrados.
/// Si no hay tiempos disponibles, se muestra un mensaje indicándolo.
///
/// Devuelve un objeto `pw.Document` con el contenido del PDF generado.
///
/// ### Parámetros:
/// - [currentSession]: La sesión actual seleccionada.
/// - [currentCube]: El tipo de cubo asociado a la sesión.
/// - [times]: Lista de tiempos registrados en la sesión.
///
/// ### Características:
/// - Se agrega una página con formato A4 y márgenes.
/// - Se añade un encabezado con los detalles de la sesión.
/// - Si hay tiempos disponibles, se genera una tabla con los datos.
/// - Si no hay tiempos, se muestra un mensaje indicando su ausencia.
Future<pw.Document> _generatePdf(CurrentSession currentSession,
    CurrentCubeType currentCube, List<TimeTraining> times) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      // FORMATO PAGINA A4
      pageFormat: PdfPageFormat.a4,
      // AÑADIR MARGENES A LA PAGINA
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) => [
        // ENCABEZADO DE LA PAGINA
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
                level: 0,
                child: pw.Text(
                    'Session: ${currentSession.session!.sessionName}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold))),
            pw.Text('Cube Type: ${currentCube.cubeType!.cubeName}',
                style: const pw.TextStyle(fontSize: 14)),
            pw.Text('Date: ${DateTime.now()}',
                style: const pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 10),
          ],
        ),

        // SI HAY TIEMPOS SE MUESTRA LA TABLA
        if (times.isNotEmpty)
          pw.Table.fromTextArray(
            // SE AÑADE BORDES
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            // ENCABEZADO DE LA TABLA
            headers: ['Time (s)', 'Penalty', 'Scramble'],
            // LOS TIEMPOS
            data: times.map((time) => [
                      time.timeInSeconds.toString(),
                      time.penalty ?? 'No Penalty',
                      time.scramble
                    ]).toList(),
            // SE CENTRA
            cellAlignment: pw.Alignment.center,
            cellPadding: const pw.EdgeInsets.all(5),
          )
        else
          // SI NO HAY TIEMPOS DISPONIBLES SE MUESTRA UN MENSAJE
          pw.Text('No times available',
              style:
                  pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12)),
      ],
    ),
  );
  return pdf;
}

/// Método que genera y guarda un archivo PDF en la ubicación según la plataforma.
///
/// Este método exporta un documento PDF y lo guarda en una ubicación dependiendo el SO.
/// Además, permite compartir el archivo si el usuario selecciona la opción de compartir.
///
/// ### Parámetros:
/// - [context]: El contexto de la aplicación, utilizado para mostrar notificaciones.
/// - [pdf]: El documento PDF que se generará y guardará.
/// - [sessionName]: El nombre de la sesión, utilizado para nombrar el archivo PDF.
/// - [shareOption]: Enum que indica si el archivo debe ser compartido tras guardarse.
///
/// ### Plataforma:
/// - **Windows/macOS:** Se abre un explorador de archivos para elegir dónde guardar el PDF.
/// - **Android/iOS:** Se guarda automáticamente en el directorio temporal del sistema.
///
/// ### Caracteristicas:
/// - Si ocurre un error al guardar el archivo, se muestra un mensaje de error.
Future<void> _pdfExport(
    BuildContext context, pw.Document pdf, String sessionName,
    {required ShareOption shareOption}) async {
  String filePath;
  // SEGUN LA PLATAFORMA EN LA QUE ESTE, SE GUARDA EL ARCHIVO PDF
  if (Platform.isWindows || Platform.isMacOS) {
    // SE ABRE EL EXPLORADOR DE ARCHIVOS PARA GUARDARLO
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar PDF',
      fileName: '${sessionName}_times.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // SE GUARDA EL PDF
      filePath = result;
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      AlertUtil.showSnackBarInformation(context, "pdf_saved_success");

      if (shareOption == ShareOption.moreOptions) {
        await _shareByMoreOptions(context, filePath);
      }
    }
  } else if (Platform.isAndroid || Platform.isIOS) {
    // SE GUARDA EN EL SISTEMA TEMPORAL
    final directory = Directory.systemTemp;
    filePath = '${directory.path}/${sessionName}_times.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    AlertUtil.showSnackBarInformation(context, "pdf_saved_success");
  } else {
    AlertUtil.showSnackBarError(context, "share_not_implemented");
  } // PLATAFORMA
}

/// Metodo para compartir un archivo PDF utilizando las opciones de
/// compartir del dispositivo.
///
/// Este método permite al usuario compartir el archivo PDF generado a través de
/// múltiples aplicaciones disponibles en el dispositivo, como WhatsApp, Gmail, Drive, etc.
///
/// ### Parámetros:
/// - [context]: El contexto de la aplicación, utilizado para mostrar mensajes de error.
/// - [filePath]: La ruta del archivo PDF que se desea compartir.
///
/// ### Características:
/// - Si ocurre un error al intentar compartir el archivo,  se muestra un mensaje de error en pantalla.
Future<void> _shareByMoreOptions(BuildContext context, String filePath) async {
  try {
    // ESTE METODO DEL PAQUETE `share_plus` PERMITE COMPARTIR
    // MULTIPLES ARCHIVOS SIMULTANEAMENTE
    await Share.shareXFiles(
      // EN ESTE CASO, SE PASA UNA LISTA CON UN SOLO ARCHIVO
      [XFile(filePath)],
      text: 'Tiempos de la sesión',
    );
  } catch (e) {
    AlertUtil.showSnackBarError(context, "share_error");
  }
}
