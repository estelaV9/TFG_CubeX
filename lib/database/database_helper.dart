import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> initDatabase() async {
    sqfliteFfiInit(); // INICIALIZAR EL sqflite PARA ESCRITORIO
    databaseFactory = databaseFactoryFfi;

    // OBTENER LA RUTA DE LA BASE DE DATOS EN LA CARPETA DATABASE
    final dbPath = join(Directory.current.path, 'lib', 'database', 'databaseCubeX.db');

    if (await databaseExists(dbPath)) {
      print("Base de datos ya existe en la ruta: $dbPath");
    } else {
      print("La base de datos no existe, creándola en: $dbPath");
    } // SE VERIFICA SI EL ARCHIVO YA EXISTE (prueba para ver si pilla la ruta bien)

    final db = await databaseFactory.openDatabase(dbPath); // SE ABRE LA BASE DE DATOS
    await db.execute('PRAGMA foreign_keys = ON;'); // ACTIVA LA VERIFICACION DE CLAVES FORANEAS

    return db;
  } // FUNCION PARA INICIALIZAR LA BASE DE DATOS DESDE EL ARCHIVO DE "databaseCubeX.db"

  static Future<Database> get database async {
    _database ??= await initDatabase(); // SI LA BD NO ESTA INICIALIZADA, SE INICIALIZA
    return _database!;
  } // FUNCION PARA OBTENER EL OBJETO DE LA BASE DE DATOS
}