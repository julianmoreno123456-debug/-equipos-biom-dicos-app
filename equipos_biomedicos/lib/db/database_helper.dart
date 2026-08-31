import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/equipo.dart';
import '../models/mantenimiento_preventivo.dart';
import '../models/mantenimiento_correctivo.dart';
import '../models/manual.dart';

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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE equipos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            especialidad TEXT NOT NULL,
            referencia TEXT NOT NULL,
            fotoPath TEXT
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
      },
    );
  }

  // ---------- EQUIPOS ----------
  Future<int> insertarEquipo(Equipo equipo) async {
    final db = await database;
    return await db.insert('equipos', equipo.toMap());
  }

  Future<List<Equipo>> obtenerEquipos() async {
    final db = await database;
    final maps = await db.query('equipos', orderBy: 'nombre ASC');
    return maps.map((m) => Equipo.fromMap(m)).toList();
  }

  Future<int> actualizarEquipo(Equipo equipo) async {
    final db = await database;
    return await db.update('equipos', equipo.toMap(),
        where: 'id = ?', whereArgs: [equipo.id]);
  }

  Future<int> eliminarEquipo(int id) async {
    final db = await database;
    await db.delete('preventivos', where: 'equipoId = ?', whereArgs: [id]);
    await db.delete('correctivos', where: 'equipoId = ?', whereArgs: [id]);
    await db.delete('manuales', where: 'equipoId = ?', whereArgs: [id]);
    return await db.delete('equipos', where: 'id = ?', whereArgs: [id]);
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
    // Si ya existe un manual para ese equipo, se reemplaza
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
}
