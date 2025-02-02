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
    final dbFilePath =
    join(dbPath, 'databaseCubeX.db');

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

    try {
      // SE EJECUTA EL ARCHIVO QUE CONTIENE TODA LA BASE DE DATOS
      await _createTables(db, dbFilePath);
    } catch (e) {
      logger.e("Error al crear las tablas: $e");
    }

    return db;
  } // MOVILES: FUNCION PARA INICIALIZAR LA BASE DE DATOS DESDE EL ARCHIVO DE "databaseCubeX.db"

  static Future<Database> _initDesktopDatabase() async {
    sqfliteFfiInit(); // INICIALIZAR EL sqflite PARA ESCRITORIO
    databaseFactory = databaseFactoryFfi;

    // OBTENER LA RUTA DE LA BASE DE DATOS EN LA CARPETA DATABASE
    final dbPath =
        join(Directory.current.path, 'lib', 'data/database', 'database_schema.db');

    // RUTA DEL ARCHIVO DONDE SE ENCUENTRA LA BASE DE DATOS
    final dbFilePath =
    join(Directory.current.path, 'lib', 'data/database', 'databaseCubeX.db');

    final db = await databaseFactory.openDatabase(dbPath);
    logger.i("Se creo correctamente la base de datos"); // SE MUESTRA UN MENSAJE

    try {
      // SE EJECUTA EL ARCHIVO QUE CONTIENE TODA LA BASE DE DATOS
      await _createTables(db, dbFilePath);
    } catch (e) {
      logger.e("Error al crear las tablas: $e");
    }

    return db;
  } // DESKTOP: FUNCION PARA INICIALIZAR LA BASE DE DATOS DESDE EL ARCHIVO DE "databaseCubeX.db"

  static Future<void> _createTables(Database db, String dbFilePath) async {
    final file = File(dbFilePath); // SE CONVIERTE A ARCHIVO

    if (!file.existsSync()) {
      logger.e("Archivo DB no encontrado: $dbFilePath");
      return; // DETIENE LA EJECUCIÓN SI EL ARCHIVO NO EXISTE
    } // SI NO EXISTE SE MUESTRA UN ERROR

    final dbContent = await file.readAsString(); // LEE CONTENIDO DEL ARCHIVO

    // SEPARA EL CONTENIDO EN SENTENCIAS
    final dbStatements =
        // SE DIVIDE EL CONTENIDO DEL ARCHIVO DB EN SENTENCIAS SEPARADAS POR ';',
        dbContent
            .split(';')
            // SE ELIMINAN LOS ESPACIOS AL PRINCIPIO Y FINAL DE CADA SENTENCIA,
            .map((stmt) => stmt.trim())
            // Y SE FILTRAN AQUELLOS ELEMENTOS VACÍOS (EN CASO DE QUE HAYA SENTENCIAS VACÍAS)
            .where((stmt) => stmt.isNotEmpty);

    await db.transaction((txn) async {
      for (final statement in dbStatements) {
        await txn.execute(statement);
      }
    }); // SE EJECUTA CADA SENTENCIA DENTRO DE UNA TRANSACCION

    logger.i(
        "Base de datos inicializada correctamente desde archivo de la base de datos.");
  } // METODO PARA CREAR LAS TABLAS

  static Future<Database> get database async {
    _database ??=
        await initDatabase(); // SI LA BD NO ESTA INICIALIZADA, SE INICIALIZA
    return _database!;
  } // FUNCION PARA OBTENER EL OBJETO DE LA BASE DE DATOS
}
