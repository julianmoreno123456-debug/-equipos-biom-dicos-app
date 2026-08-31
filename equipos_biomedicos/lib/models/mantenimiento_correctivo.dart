class MantenimientoCorrectivo {
  int? id;
  int equipoId;
  String fecha; // yyyy-MM-dd
  String falla;
  String solucion;

  MantenimientoCorrectivo({
    this.id,
    required this.equipoId,
    required this.fecha,
    required this.falla,
    required this.solucion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipoId': equipoId,
      'fecha': fecha,
      'falla': falla,
      'solucion': solucion,
    };
  }

  factory MantenimientoCorrectivo.fromMap(Map<String, dynamic> map) {
    return MantenimientoCorrectivo(
      id: map['id'] as int?,
      equipoId: map['equipoId'] as int,
      fecha: map['fecha'] as String,
      falla: map['falla'] as String,
      solucion: map['solucion'] as String,
    );
  }
}
