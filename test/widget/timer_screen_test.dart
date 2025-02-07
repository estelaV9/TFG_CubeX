import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esteladevega_tfg_cubex/view/screen/timer_screen.dart';

void main() {
  testWidgets('Deberia mostrar el TimerScreen correctamente', (WidgetTester tester) async {
    // CARGA EL WIDGET TimerScreen
    await tester.pumpWidget(const MaterialApp(home: TimerScreen()));

    // VERIFICA QUE EL WIDGET QUE DEBE APARECER ESTE EN LA PANTALLA
    expect(find.byType(TimerScreen), findsOneWidget); // VERIFICAR QUE SE CARGUE UNA VEZ
    expect(find.text('0.00'), findsOneWidget); // EL TIEMPO INICIAL
  });
}
