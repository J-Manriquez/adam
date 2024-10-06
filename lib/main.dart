import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/theme_model.dart'; // Importa el modelo de tema
import 'models/font_size_model.dart'; // Importa el modelo de tamaños de fuente
import 'screens/home_screen.dart'; // Importa la pantalla principal de inicio
import 'screens/sos_screen.dart'; // Importa la pantalla de SOS
import 'screens/reminder_screen.dart'; // Importa la pantalla de recordatorios
import 'screens/settings_screen.dart'; // Importamos la pantalla de configuraciones
import 'utils/custom_logger.dart';
import 'database/db_adam.dart'; // Importa DatabaseHelper
import 'package:ADAM/database/initialization/centros_medicos_init.dart';
import 'screens/informative_screen.dart'; // Nueva pantalla informativa
import 'screens/insert_userdata_screen.dart';   // Nueva pantalla para el formulario de datos
import 'package:ADAM/database/metodos/usuario_metodos.dart';

void main() async {
  // Nos aseguramos de que los widgets se inicialicen correctamente
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos el logger si es necesario (opcional)
  CustomLogger().logInfo('Inicializando la aplicación...');

  // Inicializamos el modelo UsuarioCRUD
  final usuarioCRUD = UsuarioCRUD();

  try {
    // Inicializamos la base de datos antes de lanzar la app
    await DatabaseHelper().database;
    CustomLogger().logInfo('Base de datos inicializada correctamente.');

    // Inicia la inserción de centros médicos en segundo plano
    insertCentrosMedicosInBackground();

  } catch (e) {
    // Capturamos posibles errores en la inicialización
    CustomLogger().logError('Error al inicializar la base de datos: $e');
  }


  // Comprobar si los datos del usuario existen
  bool userDataExists = await usuarioCRUD.checkIfUserDataExists(); // Implementa esta función


  // Después de la inicialización, lanzamos la aplicación
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeModel()), // Proveedor de colores
        ChangeNotifierProvider(
            create: (context) =>
                FontSizeModel()), // Proveedor de tamaños de fuente
      ],
      child: MyApp(initialRoute: userDataExists ? '/home' : '/userDataEntry'), // Modificado aquí
    ),
  );
}

/// Función que inserta los centros médicos en segundo plano
void insertCentrosMedicosInBackground() {
  Future.delayed(Duration.zero, () async {
    try {
      // Inserta los centros médicos sin retrasar el inicio de la app
      await initializeCentrosMedicos();
      CustomLogger().logInfo('Centros médicos inicializados correctamente.');
    } catch (e) {
      CustomLogger().logError('Error al inicializar los centros médicos: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({Key? key, required this.initialRoute}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADAM',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute, // Establece la ruta inicial
      routes: {
        '/info': (context) => const InfoScreen(),
        '/userDataEntry': (context) => const UserDataEntryScreen(),
        '/home': (context) => MainScreen(customLogger: CustomLogger()), // Cambia a MainScreen
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final CustomLogger customLogger; // Agregar este campo
  const MainScreen(
      {super.key,
      required this.customLogger}); // Asegúrate de requerir el parámetro

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Índice seleccionado inicialmente (1 = HomeScreen)
  final List<Widget> _pages = [];
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Clave global para controlar el Scaffold

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const SosScreen(),
      const HomeScreen(),
      const ReminderScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModel =
        Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema
    final fontSizeModel = Provider.of<FontSizeModel>(
        context); // Obtenemos el modelo de tamaño de fuente

    return Scaffold(
      key: _scaffoldKey, // Asigna el Scaffold al GlobalKey
      appBar: AppBar(
        backgroundColor:
            themeModel.primaryButtonColor, // Color dinámico para el AppBar
        // Personaliza el ícono de menú (drawer) con el tamaño que quieras
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: fontSizeModel.iconSize, // Aplica el tamaño personalizado
            color: themeModel.primaryIconColor, // Aplica el color dinámico
          ),
          onPressed: () {
            // Abre el drawer utilizando el ScaffoldState a través del GlobalKey
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'Asistente Digital',
          style: TextStyle(
            fontSize:
                fontSizeModel.titleSize, // Tamaño dinámico del texto del título
            color: themeModel.primaryTextColor, // Color dinámico del texto
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor:
            themeModel.backgroundColor, // Color dinámico para el Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: themeModel
                    .primaryButtonColor, // Color dinámico en el header del Drawer
              ),
              child: Text(
                'Menú principal',
                style: TextStyle(
                  color:
                      themeModel.primaryTextColor, // Color dinámico del texto
                  fontSize:
                      fontSizeModel.titleSize, // Tamaño dinámico del texto
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  size: fontSizeModel.iconSize,
                  color: themeModel
                      .secondaryIconColor), // Ícono con tamaño dinámico
              title: Text(
                'Configuraciones',
                style: TextStyle(
                  color:
                      themeModel.secondaryTextColor, // Color dinámico del texto
                  fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SettingsScreen()), // Navega a SettingsScreen
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info,
                  size: fontSizeModel.iconSize,
                  color: themeModel
                      .secondaryIconColor), // Ícono con tamaño dinámico
              title: Text(
                'Acerca de',
                style: TextStyle(
                  color:
                      themeModel.secondaryTextColor, // Color dinámico del texto
                  fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                ),
              ),
              onTap: () {
                // Implementa la navegación a la pantalla "Acerca de"
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: themeModel.backgroundColor, // Color de fondo dinámico
        child: _pages[
            _selectedIndex], // Cambia la página según el índice seleccionado
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.warning,
                size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,
                size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
            label: 'Recordatorios',
          ),
        ],
        currentIndex: _selectedIndex, // Índice seleccionado
        selectedItemColor: themeModel
            .secondaryButtonColor, // Color dinámico del ítem seleccionado
        unselectedItemColor:
            themeModel.primaryIconColor, // Color para ítems no seleccionados
        backgroundColor:
            themeModel.primaryButtonColor, // Color de fondo dinámico
        showUnselectedLabels: true,

        // Modifica el tamaño del texto de los labels
        selectedLabelStyle: TextStyle(
          fontSize:
              fontSizeModel.textSize, // Tamaño dinámico del texto seleccionado
          color: themeModel.secondaryIconColor, // Color del texto seleccionado
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeModel.textSize -
              2, // Tamaño dinámico del texto no seleccionado
          color: themeModel.primaryIconColor, // Color del texto no seleccionado
        ),
        onTap:
            _onItemTapped, // Método que se llama cuando se selecciona un ítem
      ),
    );
  }
}
