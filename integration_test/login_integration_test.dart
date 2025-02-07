import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:esteladevega_tfg_cubex/main.dart';  // Asegúrate de importar tu app principal

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login Flow Test', (tester) async {
    // 1. Lanzamos la aplicación
    await tester.pumpWidget(CubeXApp());  // Reemplaza MyApp con el nombre de tu app principal

    // 2. Encontramos los widgets por las claves
    final usernameField = find.byKey(Key('usernameField'));
    final passwordField = find.byKey(Key('passwordField'));
    final loginButton = find.byKey(Key('loginButton'));

    // 3. Introducimos el texto en los campos de texto
    await tester.enterText(usernameField, 'testuser');
    await tester.enterText(passwordField, 'password123');
    await tester.tap(loginButton);  // Hacemos clic en el botón de login

    // 4. Esperamos que se complete la navegación y la UI se actualice
    await tester.pumpAndSettle();  // Esto espera a que todos los cambios de UI se completen

    // 5. Verificamos que la pantalla principal haya cargado correctamente
    expect(find.text('Bienvenido, testuser'), findsOneWidget);  // Asegúrate de que el nombre de usuario aparece
    expect(find.byKey(Key('homeScreenKey')), findsOneWidget);  // Verifica que un widget específico de la pantalla principal esté presente
  });

  testWidgets('Login with invalid credentials', (tester) async {
    // 1. Lanzamos la aplicación
    await tester.pumpWidget(CubeXApp());

    // 2. Encontramos los widgets por las claves
    final usernameField = find.byKey(Key('usernameField'));
    final passwordField = find.byKey(Key('passwordField'));
    final loginButton = find.byKey(Key('loginButton'));

    // 3. Introducimos credenciales incorrectas
    await tester.enterText(usernameField, 'invaliduser');
    await tester.enterText(passwordField, 'wrongpassword');
    await tester.tap(loginButton);

    // 4. Esperamos que se complete la navegación y la UI se actualice
    await tester.pumpAndSettle();

    // 5. Verificamos que se muestra un mensaje de error
    expect(find.text('Credenciales incorrectas'), findsOneWidget);
  });
}
