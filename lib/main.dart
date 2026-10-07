import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EquiposBiomedicosApp());
}

class EquiposBiomedicosApp extends StatelessWidget {
  const EquiposBiomedicosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Mantenimiento - Equipos Biomédicos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
