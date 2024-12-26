import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';

class DatabaseHelper {
  static Database? _database;
  static final logger = Logger();

  static Future<Database> initDatabase() async {
    sqfliteFfiInit(); // INICIALIZAR EL sqflite PARA ESCRITORIO
    databaseFactory = databaseFactoryFfi;

    // OBTENER LA RUTA DE LA BASE DE DATOS EN LA CARPETA DATABASE
    final dbPath = join(Directory.current.path, 'lib', 'database', 'database_schema.db');
    final db = await databaseFactory.openDatabase(dbPath);
    logger.i("Se creo correctamente la base de datos"); // SE MUESTRA UN MENSAJE

    try {
      // SE EJECUTA EL ARCHIVO QUE CONTIENE TODA LA BASE DE DATOS
      await _createTables(db);
    } catch (e) {
      logger.e("Error al crear las tablas: $e");
    }
    return db;
  } // FUNCION PARA INICIALIZAR LA BASE DE DATOS DESDE EL ARCHIVO DE "databaseCubeX.db"

  static Future<void> _createTables(Database db) async {
    // RUTA DEL ARCHIVO DONDE SE ENCUENTRA LA BASE DE DATOS
    final dbFilePath =
        join(Directory.current.path, 'lib', 'database', 'databaseCubeX.db');
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
