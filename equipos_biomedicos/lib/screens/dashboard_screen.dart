import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, int> _stats = {
    'equipos': 0,
    'preventivos': 0,
    'correctivos': 0,
    'manuales': 0,
    'checklistPendientes': 0,
  };

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final stats = await DatabaseHelper.instance.obtenerEstadisticas();
    setState(() => _stats = stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: _cargar,
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.3,
          children: [
            _StatCard(
              icon: Icons.inventory_2,
              label: 'Equipos registrados',
              value: _stats['equipos']!,
              color: Colors.teal,
            ),
            _StatCard(
              icon: Icons.build_circle,
              label: 'Mantenimientos preventivos',
              value: _stats['preventivos']!,
              color: Colors.blue,
            ),
            _StatCard(
              icon: Icons.warning_amber,
              label: 'Mantenimientos correctivos',
              value: _stats['correctivos']!,
              color: Colors.orange,
            ),
            _StatCard(
              icon: Icons.picture_as_pdf,
              label: 'Manuales cargados',
              value: _stats['manuales']!,
              color: Colors.purple,
            ),
            _StatCard(
              icon: Icons.checklist,
              label: 'Checklist pendientes',
              value: _stats['checklistPendientes']!,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Text('$value', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
