import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/theme_model.dart'; // Importa el modelo de tema
import 'models/font_size_model.dart'; // Importa el modelo de tamaños de fuente
import 'screens/home_screen.dart'; // Importa la pantalla principal de inicio
import 'screens/sos_screen.dart'; // Importa la pantalla de SOS
import 'screens/reminder_screen.dart'; // Importa la pantalla de recordatorios
import 'screens/settings_screen.dart'; // Importamos la pantalla de configuraciones

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel()), // Proveedor de colores
        ChangeNotifierProvider(create: (context) => FontSizeModel()), // Proveedor de tamaños de fuente
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración
      title: 'ADAM', // Define el título de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Establece el tema principal de la app (colores)
      ),
      home: const MainScreen(), // Establece la pantalla principal de la app
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Índice seleccionado inicialmente (1 = HomeScreen)
  final List<Widget> _pages = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Clave global para controlar el Scaffold

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
    final themeModel = Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema
    final fontSizeModel = Provider.of<FontSizeModel>(context); // Obtenemos el modelo de tamaño de fuente

    return Scaffold(
      key: _scaffoldKey, // Asigna el Scaffold al GlobalKey
      appBar: AppBar(
        backgroundColor: themeModel.buttonColor, // Color dinámico para el AppBar
        // Personaliza el ícono de menú (drawer) con el tamaño que quieras
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: fontSizeModel.iconSize, // Aplica el tamaño personalizado
            color: themeModel.textColor, // Aplica el color dinámico
          ),
          onPressed: () {
            // Abre el drawer utilizando el ScaffoldState a través del GlobalKey
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'Asistente Digital',
          style: TextStyle(
            fontSize: fontSizeModel.titleSize, // Tamaño dinámico del texto del título
            color: themeModel.textColor, // Color dinámico del texto
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: themeModel.buttonColor, // Color dinámico en el header del Drawer
              ),
              child: Text(
                'Menú principal',
                style: TextStyle(
                  color: themeModel.textColor, // Color dinámico del texto
                  fontSize: fontSizeModel.titleSize, // Tamaño dinámico del texto
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
              title: Text(
                'Configuraciones',
                style: TextStyle(
                  color: themeModel.textColor, // Color dinámico del texto
                  fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()), // Navega a SettingsScreen
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
              title: Text(
                'Acerca de',
                style: TextStyle(
                  color: themeModel.textColor, // Color dinámico del texto
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
        child: _pages[_selectedIndex], // Cambia la página según el índice seleccionado
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.warning, size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: fontSizeModel.iconSize), // Ícono con tamaño dinámico
            label: 'Recordatorios',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: themeModel.buttonColor, // Color dinámico del ítem seleccionado
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0), // Color para ítems no seleccionados
        onTap: _onItemTapped,
      ),
    );
  }
}
