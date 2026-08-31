import 'dart:io';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/equipo.dart';
import 'agregar_equipo_screen.dart';
import 'detalle_equipo_screen.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  List<Equipo> _equipos = [];

  @override
  void initState() {
    super.initState();
    _cargarEquipos();
  }

  Future<void> _cargarEquipos() async {
    final equipos = await DatabaseHelper.instance.obtenerEquipos();
    setState(() => _equipos = equipos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario de Equipos')),
      body: _equipos.isEmpty
          ? const Center(
              child: Text('Aún no hay equipos registrados.\nToca el botón + para agregar uno.',
                  textAlign: TextAlign.center),
            )
          : ListView.builder(
              itemCount: _equipos.length,
              itemBuilder: (context, index) {
                final equipo = _equipos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: equipo.fotoPath != null && File(equipo.fotoPath!).existsSync()
                        ? CircleAvatar(backgroundImage: FileImage(File(equipo.fotoPath!)))
                        : const CircleAvatar(child: Icon(Icons.medical_services)),
                    title: Text(equipo.nombre),
                    subtitle: Text('${equipo.especialidad} · Ref: ${equipo.referencia}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetalleEquipoScreen(equipo: equipo)),
                      );
                      _cargarEquipos();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarEquipoScreen()),
          );
          _cargarEquipos();
        },
      ),
    );
  }
}
