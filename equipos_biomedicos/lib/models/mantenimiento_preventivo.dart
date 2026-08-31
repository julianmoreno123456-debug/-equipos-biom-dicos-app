class MantenimientoPreventivo {
  int? id;
  int equipoId;
  String fecha; // yyyy-MM-dd
  String observacion;

  MantenimientoPreventivo({
    this.id,
    required this.equipoId,
    required this.fecha,
    required this.observacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipoId': equipoId,
      'fecha': fecha,
      'observacion': observacion,
    };
  }

  factory MantenimientoPreventivo.fromMap(Map<String, dynamic> map) {
    return MantenimientoPreventivo(
      id: map['id'] as int?,
      equipoId: map['equipoId'] as int,
      fecha: map['fecha'] as String,
      observacion: map['observacion'] as String,
    );
  }
}
