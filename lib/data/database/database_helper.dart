import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

// ESTA CLASE EMULA, TANTO EN DESKTOP COMO EN MOVIL
class DatabaseHelper {
  static Database? _database;
  static final logger = Logger();

  static Future<Database> initDatabase() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return _initMobileDatabase(); // INICIA EN MOVILES
    } else {
      return _initDesktopDatabase(); // INICIA EN DESKTOP
    } // SEGUN EL ENTORNO (SI ES MOVIL O DESKTOP) SE EJECUTA DE UNA MANERA
  } // FUNCION PARA INICIALIZAR LA BASE DE DATOS

  static Future<Database> _initMobileDatabase() async {
    // OBTENER LA RUTA DE LA BASE DE DATOS PARA MOVIL
    final dbPath = await getDatabasesPath();
    final dbFullPath = join(dbPath, 'database_schema.db');

    // RUTA DEL ARCHIVO DONDE SE ENCUENTRA LA BASE DE DATOS
    final dbFilePath = join(dbPath, 'databaseCubeX.db');

    logger.i("Ruta de la base de datos: $dbFilePath");

    try {
      final exists = await File(dbFullPath).exists();
      if (!exists) {
        logger.i("La base de datos no existe, copiándola desde los assets...");
        final ByteData data =
            await rootBundle.load('assets/database/databaseCubeX.db');
        final buffer = data.buffer.asUint8List();
        await File(dbFullPath).writeAsBytes(buffer);
      }
    } catch (e) {
      logger.e("Error al copiar la base de datos: $e");
    }

    // SE ABRE LA BASE DE DATOS
    final db = await openDatabase(dbFullPath);
    logger.i("Se creo correctamente la base de datos"); // SE MUESTRA UN MENSAJE

    // HABILITAR CLASE FORANEAS
    await db.execute('PRAGMA foreign_keys = ON;');

    try {
      // SE EJECUTA EL ARCHIVO QUE CONTIENE TODA LA BASE DE DATOS
      await _createTables(db);
    } catch (e) {
      logger.e("Error al crear las tablas: $e");
    }

    return db;
  } // MOVILES: FUNCION PARA INICIALIZAR LA BASE DE DATOS DESDE EL ARCHIVO DE "databaseCubeX.db"

  static Future<Database> _initDesktopDatabase() async {
    sqfliteFfiInit(); // INICIALIZAR EL sqflite PARA ESCRITORIO
    databaseFactory = databaseFactoryFfi;

    // OBTENER LA RUTA DE LA BASE DE DATOS EN LA CARPETA DATABASE
    final dbPath = join(
        Directory.current.path, 'lib', 'data/database', 'database_schema.db');

    // RUTA DEL ARCHIVO DONDE SE ENCUENTRA LA BASE DE DATOS
    final dbFilePath = join(
        Directory.current.path, 'lib', 'data/database', 'databaseCubeX.db');

    final db = await databaseFactory.openDatabase(dbPath);
    logger.i("Se creó correctamente la base de datos"); // SE MUESTRA UN MENSAJE

    // HABILITAR CLASE FORANEAS
    await db.execute('PRAGMA foreign_keys = ON;');

    try {
      // SE EJECUTA EL ARCHIVO QUE CONTIENE TODA LA BASE DE DATOS
      await _createTables(db);
    } catch (e) {
      logger.e("Error al crear las tablas: $e");
    }

    return db;
  } // DESKTOP: FUNCION PARA INICIALIZAR LA BASE DE DATOS DESDE EL ARCHIVO DE "databaseCubeX.db"

  static Future<void> _createTables(Database db) async {
    try {
      // SE CREAN LAS TABLAS
      await db.transaction((txn) async {
        // EJECUTAR LAS SENTENCIAS SQL PARA CREAR TODAS LAS TABLAS
        await txn.execute('''
            CREATE TABLE IF NOT EXISTS user (
              idUser INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT(12) NOT NULL UNIQUE, 
              mail TEXT NOT NULL UNIQUE, 
              passwordHash TEXT NOT NULL,
              creationDate TIME NOT NULL,
              imageUrl TEXT NOT NULL
            );
          ''');

        await txn.execute('''
            INSERT OR REPLACE INTO user (username, mail, passwordHash, creationDate, imageUrl)
            VALUES ('admin', 'admin@admin.com', '12345678(', CURRENT_TIMESTAMP, 'imagen');
          ''');

        await txn.execute('''
            CREATE TABLE IF NOT EXISTS cubeType (
              idCubeType INTEGER PRIMARY KEY AUTOINCREMENT,
              cubeName TEXT NOT NULL, 
              idUser INTEGER NOT NULL, 
              UNIQUE (idUser, cubeName)
            );
          ''');

        await txn.execute('''
            CREATE TABLE IF NOT EXISTS sessionTime (
              idSession INTEGER PRIMARY KEY AUTOINCREMENT,
              idUser INTEGER NOT NULL,
              sessionName TEXT NOT NULL,
              creationDate TIME NOT NULL,
              idCubeType INTEGER NOT NULL,
              FOREIGN KEY (idUser) REFERENCES user (idUser),
              FOREIGN KEY (idCubeType) REFERENCES cubeType (idCubeType),
              UNIQUE (idUser, sessionName, idCubeType)
            );
          ''');

        await txn.execute('''
            CREATE TABLE IF NOT EXISTS timeTraining (
              idTimeTraining INTEGER PRIMARY KEY AUTOINCREMENT,
              idSession INTEGER NOT NULL,
              scramble TEXT NOT NULL,
              timeInSeconds REAL NOT NULL,
              comments TEXT DEFAULT NULL,
              penalty TEXT CHECK(penalty IN ('none', 'DNF', '+2')) DEFAULT 'none',
              registrationDate TIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (idSession) REFERENCES sessionTime (idSession)
            );
          ''');

        await txn.execute('''
            CREATE TABLE IF NOT EXISTS versusCompetition (
              idVersusCompe INTEGER PRIMARY KEY AUTOINCREMENT,
              idUser INTEGER NOT NULL,
              cuber1Name TEXT NOT NULL,
              cuber2Name TEXT NOT NULL,
              winner TEXT NOT NULL,
              registrationDate TIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (idUser) REFERENCES user (idUser)
            );
          ''');

        await txn.execute('''
            CREATE TABLE IF NOT EXISTS timeCompetition (
              idTimeCompetition INTEGER PRIMARY KEY AUTOINCREMENT,
              idVersusCompe INTEGER NOT NULL,
              scramble TEXT NOT NULL,
              timeCuber1InSeconds REAL NOT NULL,
              timeCuber2InSeconds REAL NOT NULL,
              commentsCuber1 TEXT DEFAULT NULL,
              commentsCuber2 TEXT DEFAULT NULL,
              penaltyCuber1 TEXT CHECK(penaltyCuber1 IN ('none', 'DNF', '+2')) DEFAULT 'none',
              penaltyCuber2 TEXT CHECK(penaltyCuber2 IN ('none', 'DNF', '+2')) DEFAULT 'none',
              registrationDate TIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
              idCubeType INTEGER NOT NULL,
              FOREIGN KEY (idCubeType) REFERENCES cubeType (idCubeType), 
              FOREIGN KEY (idVersusCompe) REFERENCES versusCompetition (idVersusCompe)
            );
          ''');

        await txn.execute('''
            CREATE TABLE IF NOT EXISTS average (
              idAverage INTEGER PRIMARY KEY AUTOINCREMENT,
              idSession INTEGER NOT NULL,
              avgTimeInSeconds REAL DEFAULT NULL,
              numberOfSolves INTEGER DEFAULT NULL,
              pbTimeInSeconds REAL DEFAULT NULL,
              worstTimeInSeconds REAL DEFAULT NULL,
              FOREIGN KEY (idSession) REFERENCES sessionTime (idSession)
            );
          ''');

        logger.i("Tablas creadas correctamente.");
      });
    } catch (e) {
      logger.e("Error al crear las tablas: $e");
    }
  } // METODO PARA CREAR LAS TABLAS

  static Future<Database> get database async {
    _database ??=
        await initDatabase(); // SI LA BD NO ESTA INICIALIZADA, SE INICIALIZA
    return _database!;
  } // FUNCION PARA OBTENER EL OBJETO DE LA BASE DE DATOS
}
