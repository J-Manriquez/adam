import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart'; // Importar para kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Importar para el soporte web
import '../models/db_model.dart'; // Importamos el modelo
import '../utils/custom_logger.dart'; // Importamos logger

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
  try {
    // Si la base de datos ya ha sido creada, simplemente regresamos esa instancia
    if (_database != null) {
      CustomLogger().logError('Base de datos ya inicializada.'); // Log de que la base de datos ya está creada
      return _database!;
    } else {
      CustomLogger().logError('Base de datos no inicializada.'); // Log de que la base de datos no está creada
    }

    // Comprobamos si estamos en un entorno web
    if (kIsWeb) {
      CustomLogger().logError('Entorno detectado: Web'); // Log de entorno web
      databaseFactory = databaseFactoryFfiWeb;
    } else if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux)) {
      CustomLogger().logError('Entorno detectado: Escritorio (Windows o Linux)'); // Log de entorno escritorio
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } else {
      CustomLogger().logError('Entorno detectado: Móvil (Android o iOS)'); // Log de entorno móvil
      databaseFactory = databaseFactory; // En móviles no se hace nada especial
    }

    // Inicializamos la base de datos
    CustomLogger().logError('Inicializando la base de datos...'); // Log de inicio de la creación de la base de datos
    _database = await _initDB();
    CustomLogger().logError('Base de datos inicializada correctamente.'); // Log de que la base de datos fue creada exitosamente
    return _database!;
  } catch (e, stackTrace) {
    // Captura de cualquier error y log detallado
    CustomLogger().logError('Error al inicializar la base de datos: $e');
    CustomLogger().logError('Stack trace: $stackTrace'); // Log del stack trace para mayor detalle del error
    rethrow; // Vuelve a lanzar el error si deseas manejarlo más adelante en el código
  }
}


  // Método para inicializar la base de datos y crear las tablas
  Future<Database> _initDB() async {
    try {
      // Obtenemos la ruta del directorio donde se almacenará la base de datos
      String path = join(await getDatabasesPath(), 'adam_database.db');
      // Creamos la base de datos y definimos las tablas
      return await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              // Creación de tablas
              try {
                // 1 -----------------------------------------------------------------------------
                // Creación de la tabla Usuario
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS Usuario (
                    rut TEXT PRIMARY KEY NOT NULL,
                    pnombre TEXT NOT NULL,
                    snombre TEXT NOT NULL,
                    papellido TEXT NOT NULL,
                    sapellido TEXT NOT NULL,
                    alias TEXT NOT NULL,
                    genero TEXT NOT NULL,
                    altura TEXT NOT NULL,
                    peso TEXT NOT NULL,
                    imc TEXT NOT NULL,
                    tipo_sangre TEXT NOT NULL,
                    fecha_nacimiento TEXT NOT NULL,
                    alergias TEXT NOT NULL,
                    cronico TEXT NOT NULL,
                    donante TEXT NOT NULL,
                    limitacion_fisica TEXT NOT NULL,
                    toma_medicamentos TEXT NOT NULL
                  );
                ''');
                // 2 -----------------------------------------------------------------------------
                // Creación de la tabla DolenciasSintomas
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS DolenciasSintomas (
                    id_dolencia INTEGER PRIMARY KEY NOT NULL,
                    dolenciaSintoma TEXT NOT NULL,
                    fechaHoraActual TEXT NOT NULL,
                    descripcion TEXT NOT NULL,
                    parteCuerpoAfectada TEXT NOT NULL,
                    tiempoDesdeAparicion TEXT, 
                    nivelDolor TEXT NOT NULL,
                    usuario_rut TEXT NOT NULL,
                    FOREIGN KEY(usuario_rut) REFERENCES Usuario(rut)
                  );
                ''');
                // 3 -----------------------------------------------------------------------------
                // Creación de la tabla DolenciasMedicamentos
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS DolenciasMedicamentos (
                    id INTEGER PRIMARY KEY NOT NULL,
                    nombreMedicamento TEXT,
                    dosis TEXT,
                    dolencia_id INTEGER NOT NULL,
                    FOREIGN KEY(dolencia_id) REFERENCES DolenciasSintomas(id_dolencia)
                  );
                ''');
                // 4 -----------------------------------------------------------------------------
                // Creación de la tabla Medicamentos
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS Medicamentos (
                      id INTEGER PRIMARY KEY NOT NULL,
                      medicamento TEXT NOT NULL,
                      dosis TEXT NOT NULL,
                      periodicidad TEXT NOT NULL,
                      horarios TEXT NOT NULL,
                      estadoNotificacion TEXT NOT NULL,
                      usuario_rut TEXT NOT NULL,
                      FOREIGN KEY(usuario_rut) REFERENCES Usuario(rut)
                  );
                ''');
                // 5 -----------------------------------------------------------------------------
                // Creación de la tabla Alergias
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS Alergias (
                      id INTEGER PRIMARY KEY NOT NULL,
                      tipo TEXT NOT NULL,
                      alergeno TEXT NOT NULL,
                      usuario_rut TEXT NOT NULL,
                      FOREIGN KEY(usuario_rut) REFERENCES Usuario(rut)
                  );
                ''');
                // 6 -----------------------------------------------------------------------------
                // Creación de la tabla PatologiasCronicas
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS PatologiasCronicas (
                      id INTEGER PRIMARY KEY NOT NULL,
                      tipo_patologia TEXT NOT NULL,
                      nombre_patologia TEXT NOT NULL,
                      transmisibilidad TEXT NOT NULL,
                      morbilidad_intensidad TEXT NOT NULL,
                      usuario_rut TEXT NOT NULL,
                      FOREIGN KEY(usuario_rut) REFERENCES Usuario(rut)
                  );
                ''');
                // 7 -----------------------------------------------------------------------------
                // Creación de la tabla Limitaciones
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS Limitaciones(
                    id INTEGER PRIMARY KEY NOT NULL,
                    tipo_lim TEXT NOT NULL,
                    severidad_lim TEXT NOT NULL,
                    origen_lim TEXT NOT NULL,
                    descripcion_lim TEXT NOT NULL,
                    usuario_rut TEXT NOT NULL,
                    FOREIGN KEY(usuario_rut) REFERENCES Usuario(rut)
                  );
                ''');
                // 8 -----------------------------------------------------------------------------
                // Creación de la tabla HistorialChat
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS HistorialChat( 
                    id TEXT PRIMARY KEY NOT NULL,
                    fecha_hora TEXT NOT NULL,
                    funcion_reconocida TEXT NOT NULL, 
                    input TEXT NOT NULL,
                    output TEXT NOT NULL,
                    usuario_rut TEXT NOT NULL,
                    FOREIGN KEY(usuario_rut) REFERENCES Usuario(rut)
                  );
                ''');
                // 9 -----------------------------------------------------------------------------
                // Creación de la tabla Contacto
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS Contacto(
                    id INTEGER PRIMARY KEY NOT NULL,
                    nombreCompleto TEXT NOT NULL,
                    alias TEXT NOT NULL,
                    numero TEXT NOT NULL,
                    relacion TEXT NOT NULL,
                    estadoContacto TEXT NOT NULL,
                    usuario_rut TEXT NOT NULL,
                    FOREIGN KEY(usuario_rut) REFERENCES Usuario(rut)
                  );
                ''');
                // 10 -----------------------------------------------------------------------------
                // Creación de la tabla centrosMedicos
                await db.execute('''
                  CREATE TABLE IF NOT EXISTS centrosMedicos(
                    id TEXT PRIMARY KEY NOT NULL,
                    Region TEXT NOT NULL,
                    Nombre_Oficial TEXT NOT NULL,
                    Comuna TEXT NOT NULL,
                    Direccion TEXT NOT NULL,
                    Telefono TEXT, -- Telefono puede ser NULL
                    Actualizado_al TEXT NOT NULL
                  );
                ''');

                // 11 -----------------------------------------------------------------------------
                // 12 -----------------------------------------------------------------------------
                // 13 -----------------------------------------------------------------------------
                // 14 -----------------------------------------------------------------------------
                // 15 -----------------------------------------------------------------------------

                // Agrega el resto de las tablas aquí, similar al anterior
              } catch (e) {
                CustomLogger().logError('Error al crear las tablas: $e');
              }
            },
          ));
    } catch (e) {
      CustomLogger().logError('Error al inicializar la base de datos: $e');
      rethrow; // Re-lanzamos la excepción para manejarla más arriba si es necesario
    }
  }

  // Método para cerrar la base de datos

  Future<void> closeDB() async {
    try {
      final db = await database;
      db.close();
    } catch (e) {
      CustomLogger().logError('Error al cerrar la base de datos: $e');
    }
  }

// 1 -----------------------------------------------------------------------------
  // Método para agregar un usuario
  Future<void> insertUsuario(Usuario usuario) async {
    try {
      // Obtenemos la base de datos
      final db = await database;
      await db.insert(
        'Usuario',
        usuario.toMap(), // Convertimos el objeto a mapa
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar el usuario: $e');
    }
  }

  // Método para obtener un usuario
  Future<Usuario?> getUsuario(String rut) async {
    try {
      final db = await database;
      // Realizamos la consulta para obtener un usuario por su RUT
      final List<Map<String, dynamic>> maps = await db.query(
        'Usuario',
        where: 'rut = ?',
        whereArgs: [rut], // Proporcionamos el RUT como argumento
      );
      // Si no encontramos el usuario, regresamos null
      if (maps.isNotEmpty) {
        return Usuario.fromMap(
            maps.first); // Convertimos el mapa a un objeto Usuario
      }
      return null; // Regresamos null si no se encuentra el usuario
    } catch (e) {
      CustomLogger().logError('Error al obtener el usuario: $e');
      return null; // Regresamos null en caso de error
    }
  }

  // Método para eliminar un usuario
  Future<void> deleteUsuario(String rut) async {
    try {
      final db = await database;
      await db.delete(
        'Usuario',
        where: 'rut = ?', // Especificamos la condición de eliminación
        whereArgs: [rut], // Proporcionamos el RUT como argumento
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar el usuario: $e');
    }
  }

// 2 -----------------------------------------------------------------------------
  // Métodos CRUD para DolenciasSintomas
  Future<void> insertDolencia(DolenciaSintoma dolencia) async {
    try {
      final db = await database;
      await db.insert(
        'DolenciasSintomas',
        dolencia.toMap(),
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar la dolencia: $e');
    }
  }

  Future<List<DolenciaSintoma>> getDolencia(String usuarioRut) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'DolenciasSintomas',
        where: 'usuario_rut = ?',
        whereArgs: [usuarioRut],
      );

      return List.generate(maps.length, (i) {
        return DolenciaSintoma.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener las dolencias: $e');
      return [];
    }
  }

  Future<void> deleteDolencia(int idDolencia) async {
    try {
      final db = await database;
      await db.delete(
        'DolenciasSintomas',
        where: 'id_dolencia = ?',
        whereArgs: [idDolencia],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar la dolencia: $e');
    }
  }

// 3 -----------------------------------------------------------------------------
  // Métodos CRUD para DolenciasMedicamentos
  Future<void> insertDolenciaMedicamento(
      DolenciaMedicamento medicamento) async {
    try {
      final db = await database;
      await db.insert(
        'DolenciasMedicamentos',
        medicamento.toMap(),
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar el medicamento: $e');
    }
  }

  Future<List<DolenciaMedicamento>> getDolenciaMedicamento(
      int dolenciaId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'DolenciasMedicamentos',
        where: 'dolencia_id = ?',
        whereArgs: [dolenciaId],
      );

      return List.generate(maps.length, (i) {
        return DolenciaMedicamento.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener los medicamentos: $e');
      return [];
    }
  }

  Future<void> deleteDolenciaMedicamento(int id) async {
    try {
      final db = await database;
      await db.delete(
        'DolenciasMedicamentos',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar el medicamento: $e');
    }
  }

// 4 -----------------------------------------------------------------------------
  // Métodos CRUD para Medicamentos
  Future<void> insertMedicamento(Medicamento medicamento) async {
    try {
      final db = await database;
      await db.insert('Medicamentos', medicamento.toMap());
    } catch (e) {
      CustomLogger().logError('Error al insertar el medicamento: $e');
    }
  }

  Future<List<Medicamento>> getMedicamentos(String usuarioRut) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'Medicamentos',
        where: 'usuario_rut = ?',
        whereArgs: [usuarioRut],
      );

      return List.generate(maps.length, (i) {
        return Medicamento.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener los medicamentos: $e');
      return [];
    }
  }

  Future<void> deleteMedicamento(int id) async {
    try {
      final db = await database;
      await db.delete(
        'Medicamentos',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar el medicamento: $e');
    }
  }

// 5 -----------------------------------------------------------------------------
  // Métodos CRUD para Alergias
  Future<void> insertAlergia(Alergia alergia) async {
    try {
      final db = await database;
      await db.insert('Alergias', alergia.toMap());
    } catch (e) {
      CustomLogger().logError('Error al insertar la alergia: $e');
    }
  }

  Future<List<Alergia>> getAlergias(String usuarioRut) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'Alergias',
        where: 'usuario_rut = ?',
        whereArgs: [usuarioRut],
      );

      return List.generate(maps.length, (i) {
        return Alergia.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener las alergias: $e');
      return [];
    }
  }

  Future<void> deleteAlergia(int id) async {
    try {
      final db = await database;
      await db.delete(
        'Alergias',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar la alergia: $e');
    }
  }

// 6 -----------------------------------------------------------------------------
  // Métodos CRUD para PatologiasCronicas
  Future<void> insertPatologiaCronica(PatologiaCronica patologia) async {
    try {
      final db = await database;
      await db.insert('PatologiasCronicas', patologia.toMap());
    } catch (e) {
      CustomLogger().logError('Error al insertar la patología crónica: $e');
    }
  }

  Future<List<PatologiaCronica>> getPatologiasCronicas(
      String usuarioRut) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'PatologiasCronicas',
        where: 'usuario_rut = ?',
        whereArgs: [usuarioRut],
      );

      return List.generate(maps.length, (i) {
        return PatologiaCronica.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener las patologías crónicas: $e');
      return [];
    }
  }

  Future<void> deletePatologiaCronica(int id) async {
    try {
      final db = await database;
      await db.delete(
        'PatologiasCronicas',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar la patología crónica: $e');
    }
  }

// 7 -----------------------------------------------------------------------------
  // Métodos CRUD para Limitaciones
  Future<void> insertLimitacion(Limitacion limitacion) async {
    try {
      final db = await database;
      await db.insert('Limitaciones', limitacion.toMap());
    } catch (e) {
      CustomLogger().logError('Error al insertar la limitación: $e');
    }
  }

  Future<List<Limitacion>> getLimitaciones(String usuarioRut) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'Limitaciones',
        where: 'usuario_rut = ?',
        whereArgs: [usuarioRut],
      );

      return List.generate(maps.length, (i) {
        return Limitacion.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener las limitaciones: $e');
      return [];
    }
  }

  Future<void> deleteLimitacion(int id) async {
    try {
      final db = await database;
      await db.delete(
        'Limitaciones',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar la limitación: $e');
    }
  }

// 8 -----------------------------------------------------------------------------
  // Métodos CRUD para HistorialChat
  Future<void> insertHistorialChat(HistorialChat historial) async {
    try {
      final db = await database;
      await db.insert('HistorialChat', historial.toMap());
    } catch (e) {
      CustomLogger().logError('Error al insertar el historial: $e');
    }
  }

  Future<List<HistorialChat>> getHistorialChats(String usuarioRut) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'HistorialChat',
        where: 'usuario_rut = ?',
        whereArgs: [usuarioRut],
      );

      return List.generate(maps.length, (i) {
        return HistorialChat.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener el historial: $e');
      return [];
    }
  }

  Future<void> deleteHistorialChat(String id) async {
    try {
      final db = await database;
      await db.delete(
        'HistorialChat',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar el historial: $e');
    }
  }

// 9 -----------------------------------------------------------------------------
  // Métodos CRUD para Contacto
  Future<void> insertContacto(Contacto contacto) async {
    try {
      final db = await database;
      await db.insert('Contacto', contacto.toMap());
    } catch (e) {
      CustomLogger().logError('Error al insertar el contacto: $e');
    }
  }

  Future<List<Contacto>> getContactos(String usuarioRut) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'Contacto',
        where: 'usuario_rut = ?',
        whereArgs: [usuarioRut],
      );

      return List.generate(maps.length, (i) {
        return Contacto.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener los contactos: $e');
      return [];
    }
  }

  Future<void> deleteContacto(int id) async {
    try {
      final db = await database;
      await db.delete(
        'Contacto',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar el contacto: $e');
    }
  }

// 10 -----------------------------------------------------------------------------
  // Método para insertar un nuevo centro médico
  Future<void> insertCentroMedico(CentroMedico centroMedico) async {
    try {
      final db = await database;
      await db.insert(
        'centrosMedicos',
        centroMedico.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar el centro médico: $e');
    }
  }

  // Método para obtener todos los centros médicos de un usuario específico
  Future<List<CentroMedico>> getCentrosMedicos() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('centrosMedicos');

      return List.generate(maps.length, (i) {
        return CentroMedico.fromMap(maps[i]);
      });
    } catch (e) {
      CustomLogger().logError('Error al obtener los centros médicos: $e');
      return [];
    }
  }

  // Método para eliminar un centro médico por ID
  Future<void> deleteCentroMedico(String id) async {
    try {
      final db = await database;

      await db.delete(
        'centrosMedicos',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      CustomLogger().logError('Error al eliminar el centro médico: $e');
    }
  }

// 11 -----------------------------------------------------------------------------
// 12 -----------------------------------------------------------------------------
// 13 -----------------------------------------------------------------------------
// 14 -----------------------------------------------------------------------------
// 15 -----------------------------------------------------------------------------
}
