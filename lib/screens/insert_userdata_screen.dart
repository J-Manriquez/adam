import 'package:flutter/material.dart';
import 'package:ADAM/widgets/formularios/usuario_form.dart'; // Asegúrate de que la ruta sea correcta
import 'package:provider/provider.dart';
import 'package:ADAM/models/font_size_model.dart'; // Importamos el modelo de tamaño de fuente
import 'package:ADAM/models/theme_model.dart'; // Importamos el modelo de tema

class UserDataEntryScreen extends StatelessWidget {
  const UserDataEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSizeModel = Provider.of<FontSizeModel>(
        context); // Obtenemos el modelo de tamaño de fuente
    final themeModel =
        Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: themeModel.primaryIconColor),
            iconSize: fontSizeModel.iconSize, // Tamaño dinámico del ícono
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Registro de Usuario',
                style: TextStyle(
                  fontSize:
                      fontSizeModel.titleSize, // Tamaño dinámico para subtítulo
                  color:
                      themeModel.primaryTextColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        backgroundColor:
            themeModel.primaryButtonColor, // Color dinámico del AppBar
      ),
      body: Container(
        color: themeModel.backgroundColor, // Fondo dinámico
        padding: EdgeInsets.all(16.0),
        child: UsuarioForm(isEditMode: false,), // Aquí llamas al formulario de usuario
      ),
    );
  }
}
