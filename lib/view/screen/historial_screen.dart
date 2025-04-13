import 'package:esteladevega_tfg_cubex/view/components/card_time_historial.dart';
import 'package:esteladevega_tfg_cubex/view/components/search_time_container.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/pdf_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../components/Icon/icon.dart';
import '../../view/components/cube_header_container.dart';
import '../../view/navigation/app_drawer.dart';
import 'package:esteladevega_tfg_cubex/view/utilities/app_color.dart';

import '../components/waves_painter/small_wave_container_painter.dart';

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
  // OBJETO PARA LA CLASE QUE GENERA EL PDF
  PdfGenerator pdfGenerator = PdfGenerator();

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
            bottom: 80,
            child: CardTimeHistorial(),
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: SpeedDial(
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
                pdfGenerator.convertPdf(context, ShareOption.download);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.more_horiz, color: Colors.white),
              label: "Otros",
              backgroundColor: Colors.blueGrey,
              onTap: () {
                pdfGenerator.convertPdf(context, ShareOption.moreOptions);
              },
            ),
          ],
        ),
      ),
    );
  }
}