import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/equipo.dart';
import '../models/mantenimiento_preventivo.dart';
import '../models/mantenimiento_correctivo.dart';
import 'manual_screen.dart';
import 'checklist_screen.dart';
import 'qr_screen.dart';

class DetalleEquipoScreen extends StatefulWidget {
  final Equipo equipo;
  const DetalleEquipoScreen({super.key, required this.equipo});

  @override
  State<DetalleEquipoScreen> createState() => _DetalleEquipoScreenState();
}

class _DetalleEquipoScreenState extends State<DetalleEquipoScreen> {
  List<MantenimientoPreventivo> _preventivos = [];
  List<MantenimientoCorrectivo> _correctivos = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prev = await DatabaseHelper.instance.obtenerPreventivos(widget.equipo.id!);
    final corr = await DatabaseHelper.instance.obtenerCorrectivos(widget.equipo.id!);
    setState(() {
      _preventivos = prev;
      _correctivos = corr;
    });
  }

  Future<void> _dialogoAgregarPreventivo() async {
    final obsCtrl = TextEditingController();
    final fecha = DateTime.now();

    final guardar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo mantenimiento preventivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fecha: ${DateFormat('yyyy-MM-dd').format(fecha)}'),
            TextField(
              controller: obsCtrl,
              decoration: const InputDecoration(labelText: 'Observación'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
        ],
      ),
    );

    if (guardar == true) {
      await DatabaseHelper.instance.insertarPreventivo(
        MantenimientoPreventivo(
          equipoId: widget.equipo.id!,
          fecha: DateFormat('yyyy-MM-dd').format(fecha),
          observacion: obsCtrl.text.trim().isEmpty ? 'Mantenimiento preventivo realizado' : obsCtrl.text.trim(),
        ),
      );
      _cargarDatos();
    }
  }

  Future<void> _dialogoAgregarCorrectivo() async {
    final fallaCtrl = TextEditingController();
    final solucionCtrl = TextEditingController();
    final fecha = DateTime.now();
    String? fotoPath;

    final guardar = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Nuevo mantenimiento correctivo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Fecha: ${DateFormat('yyyy-MM-dd').format(fecha)}'),
                TextField(
                  controller: fallaCtrl,
                  decoration: const InputDecoration(labelText: 'Falla reportada'),
                  maxLines: 2,
                ),
                TextField(
                  controller: solucionCtrl,
                  decoration: const InputDecoration(labelText: 'Solución aplicada'),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                if (fotoPath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(fotoPath!), height: 100),
                  ),
                TextButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final imagen = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                    if (imagen != null) {
                      setStateDialog(() => fotoPath = imagen.path);
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: Text(fotoPath == null ? 'Agregar evidencia fotográfica' : 'Cambiar foto'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
          ],
        ),
      ),
    );

    if (guardar == true) {
      await DatabaseHelper.instance.insertarCorrectivo(
        MantenimientoCorrectivo(
          equipoId: widget.equipo.id!,
          fecha: DateFormat('yyyy-MM-dd').format(fecha),
          falla: fallaCtrl.text.trim(),
          solucion: solucionCtrl.text.trim(),
          fotoEvidenciaPath: fotoPath,
        ),
      );
      _cargarDatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final equipo = widget.equipo;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(equipo.nombre),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Hoja de vida'),
              Tab(text: 'Preventivos'),
              Tab(text: 'Correctivos'),
              Tab(text: 'Checklist'),
              Tab(text: 'Manual / IA'),
              Tab(text: 'QR'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ----- HOJA DE VIDA -----
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (equipo.fotoPath != null && File(equipo.fotoPath!).existsSync())
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(equipo.fotoPath!), height: 200, fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 16),
                  _infoRow('Nombre', equipo.nombre),
                  _infoRow('Especialidad', equipo.especialidad),
                  _infoRow('Referencia', equipo.referencia),
                  _infoRow('Fecha de registro', equipo.fechaRegistro),
                  const Divider(height: 28),
                  _infoRow('Mantenimientos preventivos', '${_preventivos.length}'),
                  _infoRow('Mantenimientos correctivos', '${_correctivos.length}'),
                ],
              ),
            ),

            // ----- PREVENTIVOS -----
            Scaffold(
              body: _preventivos.isEmpty
                  ? const Center(child: Text('No hay mantenimientos preventivos registrados.'))
                  : ListView.builder(
                      itemCount: _preventivos.length,
                      itemBuilder: (context, i) {
                        final p = _preventivos[i];
                        return ListTile(
                          leading: const Icon(Icons.build_circle, color: Colors.teal),
                          title: Text(p.fecha),
                          subtitle: Text(p.observacion),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'fab_preventivo',
                backgroundColor: Colors.teal,
                onPressed: _dialogoAgregarPreventivo,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),

            // ----- CORRECTIVOS (con evidencia fotográfica) -----
            Scaffold(
              body: _correctivos.isEmpty
                  ? const Center(child: Text('No hay historial de mantenimiento correctivo.'))
                  : ListView.builder(
                      itemCount: _correctivos.length,
                      itemBuilder: (context, i) {
                        final c = _correctivos[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: ListTile(
                            leading: c.fotoEvidenciaPath != null && File(c.fotoEvidenciaPath!).existsSync()
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(File(c.fotoEvidenciaPath!), width: 48, height: 48, fit: BoxFit.cover),
                                  )
                                : const Icon(Icons.warning_amber, color: Colors.orange),
                            title: Text('${c.fecha} · ${c.falla}'),
                            subtitle: Text('Solución: ${c.solucion}'),
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'fab_correctivo',
                backgroundColor: Colors.teal,
                onPressed: _dialogoAgregarCorrectivo,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),

            // ----- CHECKLIST -----
            ChecklistScreen(equipoId: equipo.id!),

            // ----- MANUAL / ASISTENTE IA -----
            ManualScreen(equipoId: equipo.id!),

            // ----- CÓDIGO QR -----
            QrScreen(equipo: equipo),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
