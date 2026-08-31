class Manual {
  int? id;
  int equipoId;
  String nombreArchivo;
  String textoExtraido;

  Manual({
    this.id,
    required this.equipoId,
    required this.nombreArchivo,
    required this.textoExtraido,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipoId': equipoId,
      'nombreArchivo': nombreArchivo,
      'textoExtraido': textoExtraido,
    };
  }

  factory Manual.fromMap(Map<String, dynamic> map) {
    return Manual(
      id: map['id'] as int?,
      equipoId: map['equipoId'] as int,
      nombreArchivo: map['nombreArchivo'] as String,
      textoExtraido: map['textoExtraido'] as String,
    );
  }
}
