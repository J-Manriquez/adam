import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importa la pantalla principal de inicio
import 'screens/sos_screen.dart'; // Importa la pantalla de SOS
import 'screens/reminder_screen.dart'; // Importa la pantalla de recordatorios
import 'screens/settings_screen.dart'; // Importamos la pantalla de configuraciones

// Punto de entrada de la aplicación
void main() {
  // runApp ejecuta la aplicación usando la clase MyApp como widget raíz
  runApp(const MyApp());
}

// Define el widget principal de la aplicación
class MyApp extends StatelessWidget {
  // Constructor de la clase MyApp que utiliza una clave opcional
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp es el contenedor principal que define la estructura básica de la app
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

// Clase que define la pantalla principal (MainScreen) como un StatefulWidget
class MainScreen extends StatefulWidget {
  // Constructor de MainScreen que también utiliza una clave opcional
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(); // Crea el estado asociado
}

// Clase que maneja el estado de MainScreen
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Índice seleccionado inicialmente (1 = HomeScreen)

  // Lista de pantallas disponibles en la navegación principal
  final List<Widget> _pages = [
    const SosScreen(), // Pantalla de SOS
    const HomeScreen(), // Pantalla de inicio
    const ReminderScreen(), // Pantalla de recordatorios
  ];

  // Método que se ejecuta al seleccionar un ítem del BottomNavigationBar
  void _onItemTapped(int index) {
    // Actualiza el índice seleccionado y refresca la UI
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold proporciona la estructura visual básica (AppBar, Drawer, Body, BottomNavigationBar)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Digital'), // Título en la AppBar
      ),
      drawer: Drawer( // Define el menú lateral (drawer)
        child: ListView(
          padding: EdgeInsets.zero, // Elimina el padding para alinear elementos
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Fondo azul para el encabezado del Drawer
              ),
              child: Text(
                'Menú principal', // Texto del encabezado
                style: TextStyle(color: Colors.white, fontSize: 24), // Estilo del texto
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings), // Ícono de configuraciones
              title: const Text('Configuraciones'), // Texto de la opción de menú
              onTap: () {
                // Navega a la pantalla de configuración
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()), // Carga SettingsScreen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info), // Ícono de información
              title: const Text('Acerca de'), // Texto de la opción "Acerca de"
              onTap: () {
                // Aquí se puede implementar la navegación a la pantalla de "Acerca de"
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Cuerpo de la pantalla que cambia según el índice seleccionado
      bottomNavigationBar: BottomNavigationBar( // Barra de navegación inferior
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.warning), // Ícono para SOS
            label: 'SOS', // Etiqueta para el ítem SOS
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ícono para Inicio
            label: 'Inicio', // Etiqueta para el ítem de inicio
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications), // Ícono para Recordatorios
            label: 'Recordatorios', // Etiqueta para el ítem de recordatorios
          ),
        ],
        currentIndex: _selectedIndex, // Índice actual que define la página mostrada
        selectedItemColor: Colors.blue, // Color del ítem seleccionado
        onTap: _onItemTapped, // Llama al método _onItemTapped cuando se selecciona un ítem
      ),
    );
  }
}
