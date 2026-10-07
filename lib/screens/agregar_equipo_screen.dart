import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/database_helper.dart';
import '../models/equipo.dart';

class AgregarEquipoScreen extends StatefulWidget {
  const AgregarEquipoScreen({super.key});

  @override
  State<AgregarEquipoScreen> createState() => _AgregarEquipoScreenState();
}

class _AgregarEquipoScreenState extends State<AgregarEquipoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _especialidadCtrl = TextEditingController();
  final _referenciaCtrl = TextEditingController();
  String? _fotoPath;

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final origen = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (origen == null) return;
    final XFile? imagen = await picker.pickImage(source: origen, imageQuality: 70);
    if (imagen != null) {
      setState(() => _fotoPath = imagen.path);
    }
  }

  Future<void> _guardarEquipo() async {
    if (!_formKey.currentState!.validate()) return;

    final equipo = Equipo(
      nombre: _nombreCtrl.text.trim(),
      especialidad: _especialidadCtrl.text.trim(),
      referencia: _referenciaCtrl.text.trim(),
      fotoPath: _fotoPath,
      fechaRegistro: DateTime.now().toIso8601String().substring(0, 10),
    );

    await DatabaseHelper.instance.insertarEquipo(equipo);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Equipo guardado correctamente')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _seleccionarFoto,
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _fotoPath != null ? FileImage(File(_fotoPath!)) : null,
                    child: _fotoPath == null
                        ? const Icon(Icons.add_a_photo, size: 40, color: Colors.black54)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del equipo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _especialidadCtrl,
                decoration: const InputDecoration(
                  labelText: 'Especialidad',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa la especialidad' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenciaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Referencia',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa la referencia' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _guardarEquipo,
                icon: const Icon(Icons.save),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Guardar equipo', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
