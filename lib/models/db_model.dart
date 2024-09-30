// 1 -----------------------------------------------------------------------------
class Usuario {
  final String rut; // RUT del usuario
  final String pnombre; // Primer nombre
  final String snombre; // Segundo nombre
  final String papellido; // Primer apellido
  final String sapellido; // Segundo apellido
  final String alias; // Alias
  final String genero; // Género
  final String altura; // Altura
  final String peso; // Peso
  final String imc; // Índice de Masa Corporal
  final String tipo_sangre; // Tipo de sangre
  final String fecha_nacimiento; // Fecha de nacimiento
  final String alergias; // Alergias
  final String cronico; // Enfermedades crónicas
  final String donante; // Donante de órganos
  final String limitacion_fisica; // Limitaciones físicas
  final String toma_medicamentos; // Toma de medicamentos

  // Constructor
  Usuario({
    required this.rut,
    required this.pnombre,
    required this.snombre,
    required this.papellido,
    required this.sapellido,
    required this.alias,
    required this.genero,
    required this.altura,
    required this.peso,
    required this.imc,
    required this.tipo_sangre,
    required this.fecha_nacimiento,
    required this.alergias,
    required this.cronico,
    required this.donante,
    required this.limitacion_fisica,
    required this.toma_medicamentos,
  });

  // Método para convertir un objeto Usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'rut': rut,
      'pnombre': pnombre,
      'snombre': snombre,
      'papellido': papellido,
      'sapellido': sapellido,
      'alias': alias,
      'genero': genero,
      'altura': altura,
      'peso': peso,
      'imc': imc,
      'tipo_sangre': tipo_sangre,
      'fecha_nacimiento': fecha_nacimiento,
      'alergias': alergias,
      'cronico': cronico,
      'donante': donante,
      'limitacion_fisica': limitacion_fisica,
      'toma_medicamentos': toma_medicamentos,
    };
  }

  // Método para convertir un mapa a un objeto Usuario (opcional)
  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      rut: map['rut'],
      pnombre: map['pnombre'],
      snombre: map['snombre'],
      papellido: map['papellido'],
      sapellido: map['sapellido'],
      alias: map['alias'],
      genero: map['genero'],
      altura: map['altura'],
      peso: map['peso'],
      imc: map['imc'],
      tipo_sangre: map['tipo_sangre'],
      fecha_nacimiento: map['fecha_nacimiento'],
      alergias: map['alergias'],
      cronico: map['cronico'],
      donante: map['donante'],
      limitacion_fisica: map['limitacion_fisica'],
      toma_medicamentos: map['toma_medicamentos'],
    );
  }
}

// 2 -----------------------------------------------------------------------------
class DolenciaSintoma {
  final int idDolencia; // ID de la dolencia
  final String dolenciaSintoma; // Nombre del síntoma
  final String fechaHoraActual; // Fecha y hora de la consulta
  final String descripcion; // Descripción del síntoma
  final String parteCuerpoAfectada; // Parte del cuerpo afectada
  final String?
      tiempoDesdeAparicion; // Tiempo desde que apareció el síntoma (opcional)
  final String nivelDolor; // Nivel de dolor
  final String usuarioRut; // RUT del usuario que presenta la dolencia

  // Constructor
  DolenciaSintoma({
    required this.idDolencia,
    required this.dolenciaSintoma,
    required this.fechaHoraActual,
    required this.descripcion,
    required this.parteCuerpoAfectada,
    this.tiempoDesdeAparicion,
    required this.nivelDolor,
    required this.usuarioRut,
  });

  // Método para convertir un objeto DolenciaSintoma a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_dolencia': idDolencia,
      'dolenciaSintoma': dolenciaSintoma,
      'fechaHoraActual': fechaHoraActual,
      'descripcion': descripcion,
      'parteCuerpoAfectada': parteCuerpoAfectada,
      'tiempoDesdeAparicion': tiempoDesdeAparicion,
      'nivelDolor': nivelDolor,
      'usuario_rut': usuarioRut,
    };
  }

  // Método para convertir un mapa a un objeto DolenciaSintoma
  static DolenciaSintoma fromMap(Map<String, dynamic> map) {
    return DolenciaSintoma(
      idDolencia: map['id_dolencia'],
      dolenciaSintoma: map['dolenciaSintoma'],
      fechaHoraActual: map['fechaHoraActual'],
      descripcion: map['descripcion'],
      parteCuerpoAfectada: map['parteCuerpoAfectada'],
      tiempoDesdeAparicion: map['tiempoDesdeAparicion'],
      nivelDolor: map['nivelDolor'],
      usuarioRut: map['usuario_rut'],
    );
  }
}

// 3 -----------------------------------------------------------------------------
class DolenciaMedicamento {
  final int id; // ID del medicamento
  final String? nombreMedicamento; // Nombre del medicamento (opcional)
  final String? dosis; // Dosis del medicamento (opcional)
  final int dolenciaId; // ID de la dolencia asociada

  // Constructor
  DolenciaMedicamento({
    required this.id,
    this.nombreMedicamento,
    this.dosis,
    required this.dolenciaId,
  });

  // Método para convertir un objeto DolenciaMedicamento a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreMedicamento': nombreMedicamento,
      'dosis': dosis,
      'dolencia_id': dolenciaId,
    };
  }

  // Método para convertir un mapa a un objeto DolenciaMedicamento
  static DolenciaMedicamento fromMap(Map<String, dynamic> map) {
    return DolenciaMedicamento(
      id: map['id'],
      nombreMedicamento: map['nombreMedicamento'],
      dosis: map['dosis'],
      dolenciaId: map['dolencia_id'],
    );
  }
}

// 4 -----------------------------------------------------------------------------
class Medicamento {
  final int id;
  final String medicamento;
  final String dosis;
  final String periodicidad;
  final String horarios;
  final String estadoNotificacion;
  final String usuarioRut;

  Medicamento({
    required this.id,
    required this.medicamento,
    required this.dosis,
    required this.periodicidad,
    required this.horarios,
    required this.estadoNotificacion,
    required this.usuarioRut,
  });

  // Conversión de un mapa a un objeto Medicamento
  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      id: map['id'],
      medicamento: map['medicamento'],
      dosis: map['dosis'],
      periodicidad: map['periodicidad'],
      horarios: map['horarios'],
      estadoNotificacion: map['estadoNotificacion'],
      usuarioRut: map['usuario_rut'],
    );
  }

  // Conversión de un objeto Medicamento a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicamento': medicamento,
      'dosis': dosis,
      'periodicidad': periodicidad,
      'horarios': horarios,
      'estadoNotificacion': estadoNotificacion,
      'usuario_rut': usuarioRut,
    };
  }
}

// 5 -----------------------------------------------------------------------------
class Alergia {
  final int id;
  final String tipo;
  final String alergeno;
  final String usuarioRut;

  Alergia({
    required this.id,
    required this.tipo,
    required this.alergeno,
    required this.usuarioRut,
  });

  // Conversión de un mapa a un objeto Alergia
  factory Alergia.fromMap(Map<String, dynamic> map) {
    return Alergia(
      id: map['id'],
      tipo: map['tipo'],
      alergeno: map['alergeno'],
      usuarioRut: map['usuario_rut'],
    );
  }

  // Conversión de un objeto Alergia a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'alergeno': alergeno,
      'usuario_rut': usuarioRut,
    };
  }
}

// 6 -----------------------------------------------------------------------------
class PatologiaCronica {
  final int id;
  final String tipoPatologia;
  final String nombrePatologia;
  final String transmisibilidad;
  final String morbilidadIntensidad;
  final String usuarioRut;

  PatologiaCronica({
    required this.id,
    required this.tipoPatologia,
    required this.nombrePatologia,
    required this.transmisibilidad,
    required this.morbilidadIntensidad,
    required this.usuarioRut,
  });

  // Conversión de un mapa a un objeto PatologiaCronica
  factory PatologiaCronica.fromMap(Map<String, dynamic> map) {
    return PatologiaCronica(
      id: map['id'],
      tipoPatologia: map['tipo_patologia'],
      nombrePatologia: map['nombre_patologia'],
      transmisibilidad: map['transmisibilidad'],
      morbilidadIntensidad: map['morbilidad_intensidad'],
      usuarioRut: map['usuario_rut'],
    );
  }

  // Conversión de un objeto PatologiaCronica a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo_patologia': tipoPatologia,
      'nombre_patologia': nombrePatologia,
      'transmisibilidad': transmisibilidad,
      'morbilidad_intensidad': morbilidadIntensidad,
      'usuario_rut': usuarioRut,
    };
  }
}

// 7 -----------------------------------------------------------------------------
class Limitacion {
  final int id;
  final String tipoLim;
  final String severidadLim;
  final String origenLim;
  final String descripcionLim;
  final String usuarioRut;

  Limitacion({
    required this.id,
    required this.tipoLim,
    required this.severidadLim,
    required this.origenLim,
    required this.descripcionLim,
    required this.usuarioRut,
  });

  // Conversión de un mapa a un objeto Limitacion
  factory Limitacion.fromMap(Map<String, dynamic> map) {
    return Limitacion(
      id: map['id'],
      tipoLim: map['tipo_lim'],
      severidadLim: map['severidad_lim'],
      origenLim: map['origen_lim'],
      descripcionLim: map['descripcion_lim'],
      usuarioRut: map['usuario_rut'],
    );
  }

  // Conversión de un objeto Limitacion a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo_lim': tipoLim,
      'severidad_lim': severidadLim,
      'origen_lim': origenLim,
      'descripcion_lim': descripcionLim,
      'usuario_rut': usuarioRut,
    };
  }
}

// 8 -----------------------------------------------------------------------------
class HistorialChat {
  final String id;
  final String fechaHora;
  final String funcionReconocida;
  final String input;
  final String output;
  final String usuarioRut;

  HistorialChat({
    required this.id,
    required this.fechaHora,
    required this.funcionReconocida,
    required this.input,
    required this.output,
    required this.usuarioRut,
  });

  // Conversión de un mapa a un objeto HistorialChat
  factory HistorialChat.fromMap(Map<String, dynamic> map) {
    return HistorialChat(
      id: map['id'],
      fechaHora: map['fecha_hora'],
      funcionReconocida: map['funcion_reconocida'],
      input: map['input'],
      output: map['output'],
      usuarioRut: map['usuario_rut'],
    );
  }

  // Conversión de un objeto HistorialChat a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha_hora': fechaHora,
      'funcion_reconocida': funcionReconocida,
      'input': input,
      'output': output,
      'usuario_rut': usuarioRut,
    };
  }
}

// 9 -----------------------------------------------------------------------------
class Contacto {
  final int id;
  final String nombreCompleto;
  final String alias;
  final String numero;
  final String relacion;
  final String estadoContacto;
  final String usuarioRut;

  Contacto({
    required this.id,
    required this.nombreCompleto,
    required this.alias,
    required this.numero,
    required this.relacion,
    required this.estadoContacto,
    required this.usuarioRut,
  });

  // Conversión de un mapa a un objeto Contacto
  factory Contacto.fromMap(Map<String, dynamic> map) {
    return Contacto(
      id: map['id'],
      nombreCompleto: map['nombreCompleto'],
      alias: map['alias'],
      numero: map['numero'],
      relacion: map['relacion'],
      estadoContacto: map['estadoContacto'],
      usuarioRut: map['usuario_rut'],
    );
  }

  // Conversión de un objeto Contacto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCompleto': nombreCompleto,
      'alias': alias,
      'numero': numero,
      'relacion': relacion,
      'estadoContacto': estadoContacto,
      'usuario_rut': usuarioRut,
    };
  }
}

// 10 -----------------------------------------------------------------------------
class CentroMedico {
  final String id;
  final String region;
  final String nombreOficial;
  final String comuna;
  final String direccion;
  final String? telefono; // Telefono es opcional (nullable)
  final String actualizadoAl;

  CentroMedico({
    required this.id,
    required this.region,
    required this.nombreOficial,
    required this.comuna,
    required this.direccion,
    this.telefono, // Es nullable
    required this.actualizadoAl,
  });

  // Conversión de un mapa a un objeto CentroMedico
  factory CentroMedico.fromMap(Map<String, dynamic> map) {
    return CentroMedico(
      id: map['id'],
      region: map['Region'],
      nombreOficial: map['Nombre_Oficial'],
      comuna: map['Comuna'],
      direccion: map['Direccion'],
      telefono: map['Telefono'],
      actualizadoAl: map['Actualizado_al'],
    );
  }

  // Conversión de un objeto CentroMedico a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Region': region,
      'Nombre_Oficial': nombreOficial,
      'Comuna': comuna,
      'Direccion': direccion,
      'Telefono': telefono,
      'Actualizado_al': actualizadoAl,
    };
  }
}

// 11 -----------------------------------------------------------------------------
// 12 -----------------------------------------------------------------------------
// 13 -----------------------------------------------------------------------------
// 14 -----------------------------------------------------------------------------
// 15 -----------------------------------------------------------------------------
