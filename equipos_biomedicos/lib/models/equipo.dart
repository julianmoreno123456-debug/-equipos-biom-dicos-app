class Equipo {
  int? id;
  String nombre;
  String especialidad;
  String referencia;
  String? fotoPath;

  Equipo({
    this.id,
    required this.nombre,
    required this.especialidad,
    required this.referencia,
    this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'especialidad': especialidad,
      'referencia': referencia,
      'fotoPath': fotoPath,
    };
  }

  factory Equipo.fromMap(Map<String, dynamic> map) {
    return Equipo(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      especialidad: map['especialidad'] as String,
      referencia: map['referencia'] as String,
      fotoPath: map['fotoPath'] as String?,
    );
  }
}
