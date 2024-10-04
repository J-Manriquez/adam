import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/custom_logger.dart'; // Importamos logger
import 'initialization/tables.dart'; // Importamos las tablas

class DatabaseHelper {
  // Variable estática para la instancia única de la base de datos
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  
  // Constructor privado para crear una única instancia
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Inicializamos la base de datos
  Database? _database;

  Future<Database> get database async {
    CustomLogger().logInfo('Obteniendo la base de datos...');
    // Si la base de datos ya ha sido creada, simplemente regresamos esa instancia
    if (_database != null) return _database!;
    // Si no, la creamos
    _database = await _initDB();
    return _database!;
  } 

  // Método para inicializar la base de datos y crear las tablas
  Future<Database> _initDB() async {
    CustomLogger().logInfo('Inicializando la base de datos...');
    try {
      String path = join(await getDatabasesPath(), 'adam_database.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await createTables(db);
        },
      );
    } catch (e) {
      CustomLogger().logError('Error al inicializar la base de datos: $e');
      rethrow;
    }
  }
  // Método para cerrar la base de datos
  Future<void> closeDB() async {
    CustomLogger().logInfo('Cerrando la base de datos...');
    try {
      final db = await database;
      db.close();  
    } catch (e) {
      CustomLogger().logError('Error al cerrar la base de datos: $e');
    }
  }


}
