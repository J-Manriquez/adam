import 'package:sqflite/sqflite.dart';
import 'package:ADAM/models/db_model.dart';
import 'package:ADAM/utils/custom_logger.dart';
import 'package:ADAM/database/db_adam.dart';

class DatabaseCRUD {
  // 1 -----------------------------------------------------------------------------
  // Método para agregar un usuario
  Future<void> insertUsuario(Usuario usuario) async {
    try {
      // Obtenemos la base de datos
      final db = await DatabaseHelper().database;
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
      final db = await DatabaseHelper().database;
      // Realizamos la consulta para obtener un usuario por su RUT
      final List<Map<String, dynamic>> maps = await db.query(
        'Usuario',
        where: 'rut = ?',
        whereArgs: [rut], // Proporcionamos el RUT como argumento
      );
      // Si no encontramos el usuario, regresamos null
      if (maps.isNotEmpty) {
        return Usuario.fromMap(maps.first); // Convertimos el mapa a un objeto Usuario
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
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
      await db.insert(
        'DolenciasSintomas',
        dolencia.toMap(),
      );
    } catch (e) {
        CustomLogger().logError('Error al insertar la dolencia: $e');
    }
  }

  Future<List<DolenciaSintoma>> getDolencia(String usuarioRut) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
  Future<void> insertDolenciaMedicamento(DolenciaMedicamento medicamento) async {
    try{
      final db = await DatabaseHelper().database;
      await db.insert(
        'DolenciasMedicamentos',
        medicamento.toMap(),
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar el medicamento: $e');
    }
  }

  Future<List<DolenciaMedicamento>> getDolenciaMedicamento(int dolenciaId) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
    final db = await DatabaseHelper().database;
    await db.insert(
      'Medicamentos', 
      medicamento.toMap()
    );
  } catch (e) {
    CustomLogger().logError('Error al insertar el medicamento: $e');
  }
}

  Future<List<Medicamento>> getMedicamentos(String usuarioRut) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
      await db.insert(
        'Alergias', 
        alergia.toMap()
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar la alergia: $e');
    }
  }

  Future<List<Alergia>> getAlergias(String usuarioRut) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
      await db.insert(
        'PatologiasCronicas', 
        patologia.toMap()
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar la patología crónica: $e');
    }
  }

  Future<List<PatologiaCronica>> getPatologiasCronicas(String usuarioRut) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
      await db.insert(
        'Limitaciones', 
        limitacion.toMap()
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar la limitación: $e');
    }
  }

  Future<List<Limitacion>> getLimitaciones(String usuarioRut) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
      await db.insert(
        'HistorialChat', 
        historial.toMap()
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar el historial: $e');
    }
  }

  Future<List<HistorialChat>> getHistorialChats(String usuarioRut) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
      await db.insert(
        'Contacto', 
        contacto.toMap()
      );
    } catch (e) {
      CustomLogger().logError('Error al insertar el contacto: $e');
    }
  }

  Future<List<Contacto>> getContactos(String usuarioRut) async {
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
      final db = await DatabaseHelper().database;
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
    try{
    final db = await DatabaseHelper().database;

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