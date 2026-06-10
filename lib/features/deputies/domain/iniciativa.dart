/// A legislative initiative (iniciativa) linked to a deputy.
class Iniciativa {
  const Iniciativa({
    required this.id,
    required this.numero,
    required this.titulo,
    required this.descricaoTipo,
    this.legislatura,
    this.tipo,
    this.autorGp,
  });

  final String id;
  final String numero;
  final String titulo;
  final String descricaoTipo;
  final String? legislatura;
  final String? tipo;
  final String? autorGp;

  static const String _fieldId = 'ini_id';
  static const String _fieldNumero = 'ini_nr';
  static const String _fieldLegislatura = 'legislatura';
  static const String _fieldTipo = 'ini_tipo';
  static const String _fieldDescricaoTipo = 'ini_desc_tipo';
  static const String _fieldTitulo = 'ini_titulo';
  static const String _fieldAutorGp = 'autor_gp';

  factory Iniciativa.fromJson(Map<String, dynamic> json) {
    return Iniciativa(
      id: json[_fieldId] as String,
      numero: json[_fieldNumero] as String,
      titulo: json[_fieldTitulo] as String,
      descricaoTipo: json[_fieldDescricaoTipo] as String,
      legislatura: json[_fieldLegislatura] as String?,
      tipo: json[_fieldTipo] as String?,
      autorGp: json[_fieldAutorGp] as String?,
    );
  }

  /// Subtitle for list items (type + number).
  String get subtitle => '$descricaoTipo · n.º $numero';
}
