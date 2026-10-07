class MantenimientoCorrectivo {
  int? id;
  int equipoId;
  String fecha;
  String falla;
  String solucion;
  String? fotoEvidenciaPath;

  MantenimientoCorrectivo({
    this.id,
    required this.equipoId,
    required this.fecha,
    required this.falla,
    required this.solucion,
    this.fotoEvidenciaPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipoId': equipoId,
      'fecha': fecha,
      'falla': falla,
      'solucion': solucion,
      'fotoEvidenciaPath': fotoEvidenciaPath,
    };
  }

  factory MantenimientoCorrectivo.fromMap(Map<String, dynamic> map) {
    return MantenimientoCorrectivo(
      id: map['id'] as int?,
      equipoId: map['equipoId'] as int,
      fecha: map['fecha'] as String,
      falla: map['falla'] as String,
      solucion: map['solucion'] as String,
      fotoEvidenciaPath: map['fotoEvidenciaPath'] as String?,
    );
  }
}
