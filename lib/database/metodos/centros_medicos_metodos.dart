import 'package:sqflite/sqflite.dart';
import 'package:ADAM/models/db_model.dart'; // Importa tu modelo CentroMedico
import 'package:ADAM/utils/custom_logger.dart';
import 'package:ADAM/database/db_adam.dart';

class CentrosMedicosCRUD {
  
  // Función para obtener centros médicos usando el modelo CentroMedico
  static Future<List<CentroMedico>> getCentrosMedicos({String? region, String? comuna}) async {
    CustomLogger().logInfo('Obteniendo centros médicos...');
    try {
      final db = await DatabaseHelper().database;
      String query = 'SELECT * FROM centrosMedicos';
      List<dynamic> args = [];

      // Ajustar la consulta con filtros opcionales
      if (region != null && comuna != null) {
        query += ' WHERE Region = ? AND Comuna = ?';
        args.add(region);
        args.add(comuna);
      } else if (region != null) {
        query += ' WHERE Region = ?';
        args.add(region);
      }

      // Ejecutar la consulta
      final List<Map<String, dynamic>> result = await db.rawQuery(query, args);
      
      // Convertir el resultado en una lista de objetos CentroMedico
      return result.map((map) => CentroMedico.fromMap(map)).toList();
    } catch (e) {
      CustomLogger().logError('Error al obtener centros médicos: $e');
      return [];
    }
  }

  // Función para obtener todas las regiones
  static Future<List<String>> getRegiones() async {
    CustomLogger().logInfo('Obteniendo regiones...');
    try {
      final db = await DatabaseHelper().database;
      final result = await db.rawQuery('SELECT DISTINCT Region FROM centrosMedicos');

      // Convertir el resultado a una lista de strings
      return result.map((e) => e['Region'] as String).toList();
    } catch (e) {
      CustomLogger().logError('Error al obtener regiones: $e');
      return [];
    }
  }

  // Función para obtener comunas en base a una región específica
  static Future<List<String>> getComunas(String region) async {
    CustomLogger().logInfo('Obteniendo comunas...');
    try {
      final db = await DatabaseHelper().database;
      final result = await db.rawQuery('SELECT DISTINCT Comuna FROM centrosMedicos WHERE Region = ?', [region]);

      // Convertir el resultado a una lista de strings
      return result.map((e) => e['Comuna'] as String).toList();
    } catch (e) {
      CustomLogger().logError('Error al obtener comunas: $e');
      return [];
    }
  }
}
