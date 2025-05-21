import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/dao/supebase/cubetype_dao_sb.dart';
import '../../data/dao/supebase/session_dao_sb.dart';
import '../../data/dao/supebase/time_training_dao_sb.dart';
import '../../data/dao/supebase/user_dao_sb.dart';
import '../../data/database/database_helper.dart';
import '../../model/time_training.dart';
import '../../viewmodel/current_cube_type.dart';
import '../../viewmodel/current_session.dart';
import '../../viewmodel/current_user.dart';
import 'alert.dart';
import 'package:pdf/widgets.dart' as pw;

/// Clase encargada de generar y exportar archivos PDF con los tiempos de entrenamiento.
///
/// La clase `PdfGenerator` permite crear documentos PDF que contienen los tiempos registrados
/// en una sesión específica, mostrando detalles como el nombre de la sesión, el tipo de cubo,
/// la fecha y los tiempos obtenidos. Además, ofrece funcionalidad para exportar el archivo
/// generado, ya sea descargándolo en el dispositivo o compartiéndolo mediante otras aplicaciones.
///
/// Sus principales métodos:
/// - `convertPdf`: Controla el proceso completo de generación y exportación.
/// - `_generatePdf`: Construye el contenido visual del PDF.
/// - `_pdfExport`: Se encarga de guardar o compartir el archivo, según la plataforma y la opción elegida.
/// - `_shareByMoreOptions`: Utiliza las opciones nativas del dispositivo para compartir el PDF.
///
/// Se adapta al sistema operativo en uso (Android, iOS, Windows, macOS).
class PdfGenerator {
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
      final userDaoSb = UserDaoSb();
      final idUser = await userDaoSb.getIdUserFromName(currentUser!.username);
      // VERIFICAR QUE NO DE ERROR
      if (idUser == -1) return;

      // CONSEGUIR LA SESION Y EL TIPO DE CUBO ACTUAL
      final currentSession = context.read<CurrentSession>();
      final currentCube = context.read<CurrentCubeType>();
      final cubeTypeDaoSb = CubeTypeDaoSb();
      final cubeType = await cubeTypeDaoSb.getCubeTypeByNameAndIdUser(
          currentCube.cubeType!.cubeName, idUser);
      // VERIFICAR QUE NO DE ERROR
      if (cubeType.idCube == -1) return;

      final sessionDaoSb = SessionDaoSb();
      final session = await sessionDaoSb.getSessionByUserCubeName(
          idUser, currentSession.session!.sessionName, cubeType.idCube!);
      // VERIFICAR QUE NO DE ERROR
      if (session!.idSession == -1) return;

      // CONSEGUIR TODOS LOS TIEMPOS
      final timeTrainingDaoSb = TimeTrainingDaoSb();
      final times = await timeTrainingDaoSb.getTimesOfSession(session.idSession);

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
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              // ENCABEZADO DE LA TABLA
              headers: ['Time (s)', 'Penalty', 'Scramble'],
              // LOS TIEMPOS
              data: times
                  .map((time) => [
                        time.timeInSeconds.toString(),
                        time.penalty ?? 'No Penalty',
                        time.scramble
                      ])
                  .toList(),
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
      if (shareOption == ShareOption.moreOptions) {
        await _shareByMoreOptions(context, filePath);
      }

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
  Future<void> _shareByMoreOptions(
      BuildContext context, String filePath) async {
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
}

/// Enum que define las opciones de compartir un archivo PDF.
///
/// - [download]: Guarda el archivo sin compartirlo.
/// - [moreOptions]: Permite compartir el archivo con otras aplicaciones.
enum ShareOption { download, moreOptions }
