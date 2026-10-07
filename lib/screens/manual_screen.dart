import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../db/database_helper.dart';
import '../models/manual.dart';

class ManualScreen extends StatefulWidget {
  final int equipoId;
  const ManualScreen({super.key, required this.equipoId});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  Manual? _manual;
  bool _cargando = false;
  final _busquedaCtrl = TextEditingController();
  List<String> _resultados = [];

  @override
  void initState() {
    super.initState();
    _cargarManual();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarManual() async {
    final manual = await DatabaseHelper.instance.obtenerManual(widget.equipoId);
    if (!mounted) return;
    setState(() => _manual = manual);
  }

  Future<void> _subirManual() async {
    final archivo = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );
    if (archivo == null || archivo.path == null) return;

    setState(() => _cargando = true);

    final path = archivo.path!;
    final nombreArchivo = archivo.name;
    String texto = '';

    try {
      if (path.toLowerCase().endsWith('.pdf')) {
        final bytes = File(path).readAsBytesSync();
        final PdfDocument documento = PdfDocument(inputBytes: bytes);
        texto = PdfTextExtractor(documento).extractText();
        documento.dispose();
      } else {
        texto = await File(path).readAsString();
      }
    } catch (e) {
      texto = '';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo leer el archivo: $e')),
        );
      }
    }

    if (texto.trim().isNotEmpty) {
      final manual = Manual(
        equipoId: widget.equipoId,
        nombreArchivo: nombreArchivo,
        textoExtraido: texto,
      );
      await DatabaseHelper.instance.guardarManual(manual);
      await _cargarManual();
    }

    if (!mounted) return;
    setState(() => _cargando = false);
  }

  void _buscar(String consulta) {
    if (_manual == null || consulta.trim().isEmpty) {
      setState(() => _resultados = []);
      return;
    }
    final lineas = _manual!.textoExtraido.split(RegExp(r'[\n\r]+'));
    final query = consulta.toLowerCase();
    final coincidencias = lineas
        .where((linea) =>
            linea.toLowerCase().contains(query) && linea.trim().isNotEmpty)
        .toList();
    setState(() => _resultados = coincidencias);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_manual == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.smart_toy_outlined, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'Asistente IA del manual',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sube el manual del equipo (PDF o TXT) y luego podrás\n'
                'buscar información dentro de él con palabras clave.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _subirManual,
                icon: const Icon(Icons.upload_file),
                label: const Text('Subir manual (PDF o TXT)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.smart_toy_outlined, color: Colors.teal, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Manual: ${_manual!.nombreArchivo}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: _subirManual,
                icon: const Icon(Icons.refresh),
                label: const Text('Reemplazar'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: _busquedaCtrl,
            decoration: const InputDecoration(
              labelText:
                  'Pregúntale al asistente (ej: voltaje, batería, error E01)',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _buscar,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _resultados.isEmpty
              ? Center(
                  child: Text(
                    _busquedaCtrl.text.isEmpty
                        ? 'Escribe una palabra o frase para buscar dentro del manual.'
                        : 'Sin coincidencias.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: _resultados.length,
                  itemBuilder: (context, i) => Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(_resultados[i].trim()),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}