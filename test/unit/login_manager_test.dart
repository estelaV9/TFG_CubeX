import 'package:flutter_test/flutter_test.dart';
// TERMINAL: flutter test test/unit/login_manager_test.dart

// CLASE PARA GESTIONAR EL INICIO DE SESION
class LoginManager {
  final Map<String, String> _users = {
    'a@a.com': '12345678(',
    'admin@admin.com': 'adminpass'
  }; // LISTA CON USUARIOS DE PRUEBA

  bool login(String email, String password) {
    return _users[email] == password;
  } // FUNCION PARA VERIFICAR SI EL MAIL Y LA CONTRASEÑA COINCIDEN
}

void main() {
  // SE AGRUPAN LAS PRUEBAS
  group('LoginManagerTest', () {
    // SE CREA UN OBJETO DE LA CLASE PARA PODER PROBAR
    final loginManager = LoginManager();

    // PRUEBA 1: LOGIN CON CREDENCIALES CORRECTAS
    test('Login con credenciales correctas', () {
      expect(loginManager.login('a@a.com', '12345678('), isTrue);
    });

    // PRUEBA 2: LOGIN FALLIDO CON CONTRASEÑA INCORRECTA
    test('Login fallido con contraseña incorrecta', () {
      expect(loginManager.login('a@a.com', 'shrek'), isFalse);
    });

    // PRUEBA 3: LOGIN FALLIDO CON UN USUARIO QUE NO EXISTE
    test('Login fallido con usuario inexistente', () {
      expect(loginManager.login('shrek@shrek.com', 'shrek32'), isFalse);
    });

    test('Login fallido con intento de inyeccion SQL', () {
      expect(loginManager.login('a@a.com', "' OR '1'='1"), isFalse);
    });

  });
}
