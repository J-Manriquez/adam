// ADAM/database/metodos/usuario_metodos.dart

import 'package:ADAM/models/db_model.dart';
import 'package:ADAM/utils/custom_logger.dart';
import 'package:ADAM/database/db_adam.dart';

class UsuarioCRUD {
  // Agrega esta función para verificar si los datos del usuario existen
  Future<bool> checkIfUserDataExists() async {
    // Accede a la instancia de la base de datos
    final db = await DatabaseHelper()
        .database; // Asegúrate de que DatabaseHelper esté configurado para acceder a la DB

    // Realiza una consulta para contar el número de registros en la tabla Usuario
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM Usuario');

    // Verificamos el conteo de registros
    if (result.isNotEmpty) {
      // Retorna true si hay al menos un registro
      return result.first['COUNT(*)'] > 0;
    } else {
      // Retorna false si la consulta no devolvió resultados
      return false;
    }
  }

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

  // Método para actualizar un usuario existente en la base de datos
  Future<int> updateUsuario(Usuario usuario) async {
    try {
      // Iniciamos la base de datos llamando al método estático db de la clase DB
      final db = await DatabaseHelper().database;

      // Actualizamos el registro del usuario en la tabla 'Usuario'
      return await db.update(
        'Usuario', // Nombre de la tabla en la base de datos
        usuario.toMap(), // Convierte el objeto usuario a un mapa de datos
        where:
            'rut = ?', // Condición WHERE para identificar el registro por el id
        whereArgs: [
          usuario.rut
        ], // Argumento para el WHERE, es decir, el id del usuario a actualizar
      );
    } catch (e) {
      // Si ocurre un error, lo registramos en el logger
      CustomLogger().logError('Error al actualizar el usuario: $e');
      // Retornamos 0 para indicar que no se actualizó ningún registro
      return 0;
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
}
