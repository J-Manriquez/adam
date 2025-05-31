import 'package:hive/hive.dart';

part 'medication_data.g.dart';

@HiveType(typeId: 6)
class MedicationData extends HiveObject {
  @HiveField(0)
  String id; // ID único del medicamento

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String name; // Nombre del medicamento

  @HiveField(3)
  String concentration; // Concentración/dosis

  @HiveField(4)
  String concentrationUnit; // Unidad de concentración (mg, ml, etc.)

  @HiveField(5)
  String form; // Forma farmacéutica (tableta, cápsula, jarabe, etc.)

  @HiveField(6)
  int frequency; // Frecuencia diaria (cada 8h, 2 veces al día, etc.)

  @HiveField(7)
  DateTime startTime; // Hora de inicio

  @HiveField(8)
  bool isIndefinite; // Si el tratamiento es indefinido

  @HiveField(9)
  int? durationDays; // Duración del tratamiento en días (si no es indefinido)

  @HiveField(10)
  DateTime startDate; // Fecha de inicio

  @HiveField(11)
  DateTime? endDate; // Fecha de término (calculada o null si es indefinido)

  @HiveField(12)
  String specialInstructions; // Instrucciones especiales

  @HiveField(13)
  DateTime createdAt;

  @HiveField(14)
  DateTime updatedAt;

  MedicationData({
    required this.id,
    this.userId,
    required this.name,
    required this.concentration,
    required this.concentrationUnit,
    required this.form,
    required this.frequency,
    required this.startTime,
    required this.isIndefinite,
    this.durationDays,
    required this.startDate,
    this.endDate,
    required this.specialInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();

  // Método para convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'concentration': concentration,
      'concentrationUnit': concentrationUnit,
      'form': form,
      'frequency': frequency,
      'startTime': startTime.millisecondsSinceEpoch,
      'isIndefinite': isIndefinite,
      'durationDays': durationDays,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'specialInstructions': specialInstructions,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Método para crear desde Map de Firebase
  factory MedicationData.fromMap(Map<String, dynamic> map) {
    return MedicationData(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      concentration: map['concentration'],
      concentrationUnit: map['concentrationUnit'],
      form: map['form'],
      frequency: map['frequency'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      isIndefinite: map['isIndefinite'],
      durationDays: map['durationDays'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endDate']) : null,
      specialInstructions: map['specialInstructions'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  // Método para calcular los horarios de toma
  List<DateTime> calculateDoseTimes() {
    List<DateTime> times = [];
    int intervalHours = 24 ~/ frequency;
    
    for (int i = 0; i < frequency; i++) {
      DateTime doseTime = DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        startTime.hour,
        startTime.minute,
      );
      doseTime = doseTime.add(Duration(hours: i * intervalHours));
      times.add(doseTime);
    }
    
    return times;
  }

  // Método para obtener el próximo horario de toma
  DateTime? getNextDoseTime() {
    final now = DateTime.now();
    final doseTimes = calculateDoseTimes();
    
    // Ajustar los horarios a la fecha actual
    List<DateTime> todayTimes = doseTimes.map((time) {
      return DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
    }).toList();
    
    // Encontrar el próximo horario
    for (var time in todayTimes) {
      if (time.isAfter(now)) {
        return time;
      }
    }
    
    // Si no hay más horarios hoy, tomar el primero de mañana
    if (todayTimes.isNotEmpty) {
      return todayTimes.first.add(const Duration(days: 1));
    }
    
    return null;
  }
}