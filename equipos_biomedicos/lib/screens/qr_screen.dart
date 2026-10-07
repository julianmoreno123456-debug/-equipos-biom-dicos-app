import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/equipo.dart';

class QrScreen extends StatelessWidget {
  final Equipo equipo;
  const QrScreen({super.key, required this.equipo});

  @override
  Widget build(BuildContext context) {
    // El QR guarda los datos clave del equipo en texto plano.
    // Al escanearlo con cualquier lector de QR se puede identificar el equipo
    // de inmediato (nombre, especialidad, referencia e ID interno).
    final contenidoQr = 'EQUIPO BIOMÉDICO\n'
        'ID: ${equipo.id}\n'
        'Nombre: ${equipo.nombre}\n'
        'Especialidad: ${equipo.especialidad}\n'
        'Referencia: ${equipo.referencia}';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Código QR del equipo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: QrImageView(
                data: contenidoQr,
                version: QrVersions.auto,
                size: 200,
                gapless: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Equipo: ${equipo.nombre}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Escanea este código con la cámara o cualquier lector de QR\n'
              'para identificar el equipo rápidamente (ej: durante una ronda\n'
              'de mantenimiento).',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
