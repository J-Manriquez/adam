import 'package:ADAM/models/font_size_model.dart';
import 'package:flutter/material.dart';
import 'package:ADAM/models/db_model.dart';
import 'package:ADAM/database/metodos/usuario_metodos.dart';
import 'package:ADAM/widgets/fecha_picker_widget.dart';
import 'package:ADAM/widgets/altura_peso_picker_widget.dart';
import 'package:ADAM/models/theme_model.dart'; // Importamos el modelo de tema
import 'package:provider/provider.dart';
import 'package:ADAM/widgets/dropdown_widget.dart';

class UsuarioForm extends StatefulWidget {
  final Usuario? usuario; // Si se proporciona, estamos en modo de edición
  final bool isEditMode; // Para definir si es creación o edición

  const UsuarioForm({Key? key, this.usuario, required this.isEditMode})
      : super(key: key);

  @override
  _UsuarioFormState createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  final UsuarioCRUD _usuarioCRUD = UsuarioCRUD();

  // Controladores para los campos del formulario
  final TextEditingController rutController = TextEditingController();
  final TextEditingController pnombreController = TextEditingController();
  final TextEditingController snombreController = TextEditingController();
  final TextEditingController papellidoController = TextEditingController();
  final TextEditingController sapellidoController = TextEditingController();
  final TextEditingController aliasController = TextEditingController();

  // Variables para los dropdowns
  String? generoSeleccionado;
  String? tipoSangreSeleccionado;
  String? factorRhSeleccionado;
  String? alergiasSeleccionado;
  String? cronicoSeleccionado;
  String? donanteSeleccionado;
  String? limitacionFisicaSeleccionado;
  String? tomaMedicamentosSeleccionado;
  String? imcCalculado;

  double? alturaSeleccionada;
  double? pesoSeleccionado;

  DateTime? fechaNacimientoSeleccionada;

  // Listas de opciones para los dropdowns
  final List<String> generos = [
    'Mujer',
    'Hombre',
    'No binarie',
    'Prefiero no decirlo'
  ];
  final List<String> tiposSangre = ['A', 'B', 'AB', 'O'];
  final List<String> factoresRh = ['Rh+', 'Rh-'];
  final List<String> opcionesSiNo = ['Sí', 'No'];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.usuario != null) {
      rutController.text = widget.usuario!.rut;
      pnombreController.text = widget.usuario!.pnombre;
      snombreController.text =
          widget.usuario!.snombre; // Si es nulo, asignar cadena vacía
      papellidoController.text = widget.usuario!.papellido;
      sapellidoController.text = widget.usuario!.sapellido; // Si es nulo
      aliasController.text = widget.usuario!.alias; // Si es nulo
      alturaSeleccionada = double.tryParse(widget.usuario!.altura) ?? 0.0;
      pesoSeleccionado = double.tryParse(widget.usuario!.peso) ?? 0.0;
      imcCalculado = widget.usuario!.imc;
      fechaNacimientoSeleccionada =
          DateTime.tryParse(widget.usuario!.fecha_nacimiento) ?? DateTime.now();
      generoSeleccionado = widget.usuario!.genero;
      tipoSangreSeleccionado = widget.usuario!.tipo_sangre.split(' ')[0];
      factorRhSeleccionado = widget.usuario!.tipo_sangre.split(' ')[1];
      alergiasSeleccionado = widget.usuario!.alergias;
      cronicoSeleccionado = widget.usuario!.cronico;
      donanteSeleccionado = widget.usuario!.donante;
      limitacionFisicaSeleccionado = widget.usuario!.limitacion_fisica;
      tomaMedicamentosSeleccionado = widget.usuario!.toma_medicamentos;
    } else {
      // Inicializa imcCalculado a '0.00' si no estamos en modo de edición
      imcCalculado = '0.00';
    }
  }

  @override
  void dispose() {
    // Limpiamos los controladores cuando el formulario se cierra
    rutController.dispose();
    pnombreController.dispose();
    snombreController.dispose();
    papellidoController.dispose();
    sapellidoController.dispose();
    aliasController.dispose();
    super.dispose();
  }

  // Método para manejar la inserción o actualización de datos
  Future<void> _saveUsuario() async {
    if (_formKey.currentState!.validate()) {
      final nuevoUsuario = Usuario(
        rut: rutController.text,
        pnombre: pnombreController.text,
        snombre: snombreController.text,
        papellido: papellidoController.text,
        sapellido: sapellidoController.text,
        alias: aliasController.text,
        genero: generoSeleccionado!,
        altura: alturaSeleccionada!.toString(),
        peso: pesoSeleccionado!.toString(),
        imc: imcCalculado ??
            '0.00', // Guardar '0.00' si no se ha calculado el IMC
        tipo_sangre: '$tipoSangreSeleccionado $factorRhSeleccionado',
        fecha_nacimiento: fechaNacimientoSeleccionada!
            .toIso8601String(), // Guardar fecha como ISO 8601
        alergias: alergiasSeleccionado!,
        cronico: cronicoSeleccionado!,
        donante: donanteSeleccionado!,
        limitacion_fisica: limitacionFisicaSeleccionado!,
        toma_medicamentos: tomaMedicamentosSeleccionado!,
      );

      if (widget.isEditMode) {
        // Actualizamos el usuario existente
        int result = await _usuarioCRUD.updateUsuario(nuevoUsuario);
        if (result > 0) {
          // Éxito en la actualización
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Usuario actualizado correctamente')));
        } else {
          // Fallo en la actualización
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al actualizar el usuario')));
        }
      } else {
        // Insertamos un nuevo usuario
        await _usuarioCRUD.insertUsuario(nuevoUsuario);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario creado correctamente')));
      }

      Navigator.of(context).pop(); // Volvemos a la pantalla anterior
    }
  }

  // Método para calcular el IMC
  void _calcularIMC() {
    // Verificamos si el peso es mayor que 0
    if (pesoSeleccionado != null && pesoSeleccionado! > 0) {
      // Verificamos que la altura no sea cero o nula
      if (alturaSeleccionada != null && alturaSeleccionada! > 0) {
        // Fórmula: IMC = peso / (altura en metros)^2
        double alturaEnMetros =
            alturaSeleccionada! / 100; // Convertimos altura a metros
        double imc = pesoSeleccionado! /
            (alturaEnMetros * alturaEnMetros); // Calculamos IMC

        // Guardamos el IMC con 2 decimales
        setState(() {
          imcCalculado = imc.toStringAsFixed(
              2); // Actualizamos el estado con el IMC calculado
        });
      } else {
        // Si la altura es cero o nula, mostramos 0
        setState(() {
          imcCalculado = '0'; // Establecemos IMC a 0
        });
      }
    } else {
      // Si el peso es 0 o nulo, mostramos 0
      setState(() {
        imcCalculado = '0'; // Establecemos IMC a 0
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel =
        Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema
    final fontSizeModel = Provider.of<FontSizeModel>(
        context); // Obtenemos el modelo de tamaño de fuente

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.isEditMode ? 'Editar Usuario' : ''),
      // ),
      body: Container(
        // padding: const EdgeInsets.all(16.0),
        color: themeModel.backgroundColor,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campos del formulario
              Text(
                'RUT:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              TextFormField(
                controller: rutController,
                decoration: InputDecoration(
                  labelText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.secondaryButtonColor.withOpacity(0.5),
                        width: 4.0), // Color cuando el campo está enfocado
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.primaryButtonColor,
                        width: 2.0), // Color cuando el campo no está enfocado
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su RUT';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Primer Nombre:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              TextFormField(
                controller: pnombreController,
                decoration: InputDecoration(
                  labelText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.secondaryButtonColor.withOpacity(0.5),
                        width: 4.0), // Color cuando el campo está enfocado
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.primaryButtonColor,
                        width: 2.0), // Color cuando el campo no está enfocado
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su primer nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Segundo Nombre:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              TextFormField(
                controller: snombreController,
                decoration: InputDecoration(
                  labelText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.secondaryButtonColor.withOpacity(0.5),
                        width: 4.0), // Color cuando el campo está enfocado
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.primaryButtonColor,
                        width: 2.0), // Color cuando el campo no está enfocado
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su segundo nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Primer Apellido:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              TextFormField(
                controller: papellidoController,
                decoration: InputDecoration(
                  labelText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.secondaryButtonColor.withOpacity(0.5),
                        width: 4.0), // Color cuando el campo está enfocado
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.primaryButtonColor,
                        width: 2.0), // Color cuando el campo no está enfocado
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su primer apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Segundo Apellido:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              TextFormField(
                controller: sapellidoController,
                decoration: InputDecoration(
                  labelText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.secondaryButtonColor.withOpacity(0.5),
                        width: 4.0), // Color cuando el campo está enfocado
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.primaryButtonColor,
                        width: 2.0), // Color cuando el campo no está enfocado
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su primer apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Alias:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              TextFormField(
                controller: aliasController,
                decoration: InputDecoration(
                  labelText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.secondaryButtonColor.withOpacity(0.5),
                        width: 4.0), // Color cuando el campo está enfocado
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: themeModel.primaryButtonColor,
                        width: 2.0), // Color cuando el campo no está enfocado
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su Alias ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                'Género:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              // Dropdown de Género
              buildDropdownField(
                '',
                generos,
                generoSeleccionado,
                (String? value) {
                  setState(() {
                    generoSeleccionado = value;
                  });
                },
                0.8,
                context,
              ),
              const SizedBox(height: 15),
              Text(
                'Altura (cm):',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              // picker de altura
              AlturaPesoPicker(
                title: 'Altura',
                onValueSelected: (double altura) {
                  // Guardar la altura seleccionada
                  setState(() {
                    alturaSeleccionada = altura;
                    _calcularIMC(); // Calcular IMC cuando se selecciona una nueva altura
                  });
                },
                selectedColor: themeModel.primaryButtonColor.withOpacity(0.7),
              ),
              const SizedBox(height: 15),
              Text(
                'Peso (kg):',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              // picker de peso
              AlturaPesoPicker(
                title: 'Peso',
                onValueSelected: (double peso) {
                  // Guardar el peso seleccionado
                  setState(() {
                    pesoSeleccionado = peso;
                    _calcularIMC(); // Calcular IMC cuando se selecciona una nueva altura
                  });
                },
                selectedColor: themeModel.primaryButtonColor.withOpacity(0.7),
              ),
              const SizedBox(height: 15),
              Text(
                'IMC:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              // Texto para mostrar el IMC calculado
              // Reemplazar este widget por el siguiente:
              Container(
                child: TextFormField(
                  controller: TextEditingController(text: imcCalculado ?? '0'),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: '',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: themeModel.secondaryButtonColor.withOpacity(0.5),
                        width: 4.0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: themeModel.primaryButtonColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Fecha de Nacimiento:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              // Botón para abrir el date picker
              FechaNacimientoPicker(
                onDateSelected: (DateTime fecha) {
                  // Guardar la fecha seleccionada
                  setState(() {
                    fechaNacimientoSeleccionada = fecha;
                  });
                },
                selectedColor: themeModel.primaryButtonColor.withOpacity(0.7),
              ),
              const SizedBox(height: 15),
              Text(
                'Tipo de Sangre:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              // Dropdown de Tipo de Sangre (dos dropdowns en una fila)
              Row(
                children: [
                  Expanded(
                    child: buildDropdownField(
                      'Grupo sanguíneo',
                      tiposSangre,
                      tipoSangreSeleccionado,
                      (String? value) {
                        setState(() {
                          tipoSangreSeleccionado = value;
                        });
                      },
                      0.3,
                      context,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildDropdownField(
                      'Factor RH',
                      factoresRh,
                      factorRhSeleccionado,
                      (String? value) {
                        setState(() {
                          factorRhSeleccionado = value;
                        });
                      },
                      0.3,
                      context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                '¿Tiene alergias?',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              // Dropdowns de Alergias, Crónico, Donante, etc.
              buildDropdownField(
                '',
                opcionesSiNo,
                alergiasSeleccionado,
                (String? value) {
                  setState(() {
                    alergiasSeleccionado = value;
                  });
                },
                0.8,
                context,
              ),
              const SizedBox(height: 15),
              Text(
                '¿Tiene alguna enfermedad crónica?',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              buildDropdownField(
                '',
                opcionesSiNo,
                cronicoSeleccionado,
                (String? value) {
                  setState(() {
                    cronicoSeleccionado = value;
                  });
                },
                0.8,
                context,
              ),
              const SizedBox(height: 15),
              Text(
                '¿Es donante de organos?',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              buildDropdownField(
                '',
                opcionesSiNo,
                donanteSeleccionado,
                (String? value) {
                  setState(() {
                    donanteSeleccionado = value;
                  });
                },
                0.8,
                context,
              ),
              const SizedBox(height: 15),
              Text(
                '¿Tiene alguna limitación física?',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              buildDropdownField(
                '',
                opcionesSiNo,
                limitacionFisicaSeleccionado,
                (String? value) {
                  setState(() {
                    limitacionFisicaSeleccionado = value;
                  });
                },
                0.8,
                context,
              ),
              const SizedBox(height: 15),
              Text(
                '¿Toma algun medicamentos regularmente o recetado?',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
              buildDropdownField(
                '',
                opcionesSiNo,
                tomaMedicamentosSeleccionado,
                (String? value) {
                  setState(() {
                    tomaMedicamentosSeleccionado = value;
                  });
                },
                0.8,
                context,
              ),
              const SizedBox(height: 20),
              // Botón para guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeModel.primaryButtonColor,
                  ),
                  child: Text(widget.isEditMode ? 'Actualizar' : 'Guardar',
                      style: TextStyle(
                          fontSize: fontSizeModel.textSize,
                          color: themeModel.primaryTextColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
