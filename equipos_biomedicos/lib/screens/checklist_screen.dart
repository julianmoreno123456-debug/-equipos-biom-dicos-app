import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/checklist_item.dart';

class ChecklistScreen extends StatefulWidget {
  final int equipoId;
  const ChecklistScreen({super.key, required this.equipoId});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<ChecklistItem> _items = [];
  final _nuevoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final items = await DatabaseHelper.instance.obtenerChecklist(widget.equipoId);
    setState(() => _items = items);
  }

  Future<void> _toggle(ChecklistItem item) async {
    item.realizado = item.realizado == 1 ? 0 : 1;
    await DatabaseHelper.instance.actualizarChecklistItem(item);
    _cargar();
  }

  Future<void> _agregarItem() async {
    if (_nuevoCtrl.text.trim().isEmpty) return;
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    await DatabaseHelper.instance.agregarChecklistItem(
      ChecklistItem(equipoId: widget.equipoId, descripcion: _nuevoCtrl.text.trim(), fecha: hoy),
    );
    _nuevoCtrl.clear();
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final completados = _items.where((i) => i.realizado == 1).length;
    return Column(
      children: [
        if (_items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: LinearProgressIndicator(
              value: completados / _items.length,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              color: Colors.teal,
            ),
          ),
        Expanded(
          child: _items.isEmpty
              ? const Center(child: Text('No hay ítems de checklist.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return CheckboxListTile(
                      value: item.realizado == 1,
                      onChanged: (_) => _toggle(item),
                      title: Text(
                        item.descripcion,
                        style: TextStyle(
                          decoration: item.realizado == 1 ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      activeColor: Colors.teal,
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nuevoCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Agregar ítem al checklist',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.teal),
                onPressed: _agregarItem,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
