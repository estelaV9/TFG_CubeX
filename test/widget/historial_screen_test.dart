import 'package:esteladevega_tfg_cubex/view/screen/settings.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_cube_type.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/settings_option/current_language.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_scramble.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_session.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_statistics.dart';
import 'package:esteladevega_tfg_cubex/viewmodel/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:esteladevega_tfg_cubex/view/screen/historial_screen.dart';
import 'package:esteladevega_tfg_cubex/view/components/card_time_historial.dart';
import 'package:esteladevega_tfg_cubex/view/components/search_time_container.dart';
import 'package:esteladevega_tfg_cubex/view/navigation/app_drawer.dart';

// TERMINAL: flutter test test/widget/historial_screen_test.dart
void main() {
  testWidgets(
    'Debería mostrar el HistorialScreen correctamente',
    (WidgetTester tester) async {
      // SE INICIALIZA LAS PREFERENCIAS
      await SettingsScreenState.startPreferences();

      // SE CONFIGURA EL WIDGET DE LA APP
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CurrentCubeType()),
            ChangeNotifierProvider(create: (_) => CurrentLanguage()),
            ChangeNotifierProvider(create: (_) => CurrentStatistics()),
            ChangeNotifierProvider(create: (_) => CurrentScramble()),
            ChangeNotifierProvider(create: (_) => CurrentSession()),
            ChangeNotifierProvider(create: (_) => CurrentUser()),
          ],
          child: const MaterialApp(
            home: HistorialScreen(),
          ),
        ),
      );

      // ESPERA
      await tester.pump(const Duration(seconds: 1));

      // VERIFICA QUE ESTE EL WIDGET HistorialScreen
      expect(find.byType(HistorialScreen), findsOneWidget);

      // VERIFICA QUE LOS COMPONENTES PRINCIPALES SE MUESTRAN
      expect(find.byType(SearchTimeContainer), findsOneWidget); // BUSCA TIEMPOS
      expect(find.byType(CardTimeHistorial), findsOneWidget); // HISTORIAL
      expect(find.byType(AppDrawer), findsOneWidget); // DRAWER

      // VERIFICA EL BOTON DE CONFIGURACION
      final settingsIcon = find.byIcon(Icons.settings);
      expect(settingsIcon, findsOneWidget); // VERIFICA QUE ESTE EL BOTON

      // SIMULA TAP EN EL BOTON DE CONFIGURACION PARA ABRIR EL DRAWER
      await tester.tap(settingsIcon);
      await tester.pumpAndSettle(); // SE ESPERA

      // VERIFICA QUE EL DRAWER SE ABRIO CORRECTAMENTE
      expect(find.byType(Drawer), findsOneWidget);
    },
    timeout: const Timeout(Duration(minutes: 1)), // AUMENTA EL TIEMPO
  );
}