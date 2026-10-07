class ChecklistItem {
  int? id;
  int equipoId;
  String descripcion;
  int realizado; // 0 = no, 1 = sí
  String fecha;

  ChecklistItem({
    this.id,
    required this.equipoId,
    required this.descripcion,
    this.realizado = 0,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipoId': equipoId,
      'descripcion': descripcion,
      'realizado': realizado,
      'fecha': fecha,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as int?,
      equipoId: map['equipoId'] as int,
      descripcion: map['descripcion'] as String,
      realizado: map['realizado'] as int,
      fecha: map['fecha'] as String,
    );
  }
}
