import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/equipo.dart';
import '../models/mantenimiento_preventivo.dart';
import '../models/mantenimiento_correctivo.dart';
import '../models/manual.dart';
import '../models/checklist_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'equipos_biomedicos.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE equipos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            especialidad TEXT NOT NULL,
            referencia TEXT NOT NULL,
            fotoPath TEXT,
            fechaRegistro TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE preventivos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            equipoId INTEGER NOT NULL,
            fecha TEXT NOT NULL,
            observacion TEXT NOT NULL,
            FOREIGN KEY (equipoId) REFERENCES equipos (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE correctivos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            equipoId INTEGER NOT NULL,
            fecha TEXT NOT NULL,
            falla TEXT NOT NULL,
            solucion TEXT NOT NULL,
            fotoEvidenciaPath TEXT,
            FOREIGN KEY (equipoId) REFERENCES equipos (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE manuales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            equipoId INTEGER NOT NULL,
            nombreArchivo TEXT NOT NULL,
            textoExtraido TEXT NOT NULL,
            FOREIGN KEY (equipoId) REFERENCES equipos (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE checklist (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            equipoId INTEGER NOT NULL,
            descripcion TEXT NOT NULL,
            realizado INTEGER NOT NULL DEFAULT 0,
            fecha TEXT NOT NULL,
            FOREIGN KEY (equipoId) REFERENCES equipos (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // ---------- EQUIPOS ----------
  Future<int> insertarEquipo(Equipo equipo) async {
    final db = await database;
    final id = await db.insert('equipos', equipo.toMap());
    // Se crea automáticamente un checklist básico estándar para el equipo
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    const itemsBase = [
      'Inspección visual general',
      'Limpieza externa del equipo',
      'Revisión de cables y conexiones',
      'Verificación de encendido/apagado',
      'Prueba de funcionamiento básico',
    ];
    for (final item in itemsBase) {
      await db.insert('checklist', {
        'equipoId': id,
        'descripcion': item,
        'realizado': 0,
        'fecha': hoy,
      });
    }
    return id;
  }

  Future<List<Equipo>> obtenerEquipos() async {
    final db = await database;
    final maps = await db.query('equipos', orderBy: 'nombre ASC');
    return maps.map((m) => Equipo.fromMap(m)).toList();
  }

  Future<Equipo?> obtenerEquipoPorId(int id) async {
    final db = await database;
    final maps = await db.query('equipos', where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return Equipo.fromMap(maps.first);
  }

  // ---------- PREVENTIVOS ----------
  Future<int> insertarPreventivo(MantenimientoPreventivo m) async {
    final db = await database;
    return await db.insert('preventivos', m.toMap());
  }

  Future<List<MantenimientoPreventivo>> obtenerPreventivos(int equipoId) async {
    final db = await database;
    final maps = await db.query('preventivos',
        where: 'equipoId = ?', whereArgs: [equipoId], orderBy: 'fecha DESC');
    return maps.map((m) => MantenimientoPreventivo.fromMap(m)).toList();
  }

  // ---------- CORRECTIVOS ----------
  Future<int> insertarCorrectivo(MantenimientoCorrectivo m) async {
    final db = await database;
    return await db.insert('correctivos', m.toMap());
  }

  Future<List<MantenimientoCorrectivo>> obtenerCorrectivos(int equipoId) async {
    final db = await database;
    final maps = await db.query('correctivos',
        where: 'equipoId = ?', whereArgs: [equipoId], orderBy: 'fecha DESC');
    return maps.map((m) => MantenimientoCorrectivo.fromMap(m)).toList();
  }

  // ---------- MANUALES ----------
  Future<int> guardarManual(Manual manual) async {
    final db = await database;
    await db.delete('manuales', where: 'equipoId = ?', whereArgs: [manual.equipoId]);
    return await db.insert('manuales', manual.toMap());
  }

  Future<Manual?> obtenerManual(int equipoId) async {
    final db = await database;
    final maps = await db.query('manuales',
        where: 'equipoId = ?', whereArgs: [equipoId], limit: 1);
    if (maps.isEmpty) return null;
    return Manual.fromMap(maps.first);
  }

  // ---------- CHECKLIST ----------
  Future<List<ChecklistItem>> obtenerChecklist(int equipoId) async {
    final db = await database;
    final maps = await db.query('checklist', where: 'equipoId = ?', whereArgs: [equipoId]);
    return maps.map((m) => ChecklistItem.fromMap(m)).toList();
  }

  Future<int> actualizarChecklistItem(ChecklistItem item) async {
    final db = await database;
    return await db.update('checklist', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> agregarChecklistItem(ChecklistItem item) async {
    final db = await database;
    return await db.insert('checklist', item.toMap());
  }

  // ---------- DASHBOARD (estadísticas) ----------
  Future<Map<String, int>> obtenerEstadisticas() async {
    final db = await database;
    final totalEquipos = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM equipos')) ??
        0;
    final totalPreventivos = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM preventivos')) ??
        0;
    final totalCorrectivos = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM correctivos')) ??
        0;
    final totalManuales = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM manuales')) ??
        0;
    final checklistPendientes = Sqflite.firstIntValue(await db
            .rawQuery('SELECT COUNT(*) FROM checklist WHERE realizado = 0')) ??
        0;

    return {
      'equipos': totalEquipos,
      'preventivos': totalPreventivos,
      'correctivos': totalCorrectivos,
      'manuales': totalManuales,
      'checklistPendientes': checklistPendientes,
    };
  }
}
