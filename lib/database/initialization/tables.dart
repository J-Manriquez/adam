import 'package:sqflite/sqflite.dart';
import 'package:ADAM/utils/custom_logger.dart';

Future<void> createTables(Database db) async {
  CustomLogger().logInfo('Creando tablas...');
  try {
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
  } catch (e) {
    CustomLogger().logError('Error al crear las tablas: $e');
  }
}
