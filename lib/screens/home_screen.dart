import 'package:flutter/material.dart';
import 'inventario_screen.dart';
import 'agregar_equipo_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimiento Biomédico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.medical_services, size: 80, color: Colors.teal),
            const SizedBox(height: 8),
            const Text(
              'Control de Mantenimiento\nde Equipos Biomédicos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 28),
            _MenuButton(
              icon: Icons.dashboard,
              label: 'Dashboard',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              ),
            ),
            const SizedBox(height: 14),
            _MenuButton(
              icon: Icons.inventory_2,
              label: 'Inventario de Equipos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InventarioScreen()),
              ),
            ),
            const SizedBox(height: 14),
            _MenuButton(
              icon: Icons.add_box,
              label: 'Agregar Nuevo Equipo',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AgregarEquipoScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 26),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}
