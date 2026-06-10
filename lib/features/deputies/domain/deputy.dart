import 'package:parlamento_pt/core/constants/api_constants.dart';

/// A deputy (deputado) from the votoaberto API.
class Deputy {
  const Deputy({
    required this.depCadId,
    required this.nomeParlamentar,
    required this.partidoAtual,
    this.circuloAtual,
    this.legislatura,
    this.situacaoAtual,
    this.nomeCompleto,
    this.photoUrl,
  });

  final int depCadId;
  final String nomeParlamentar;
  final String partidoAtual;
  final String? circuloAtual;
  final String? legislatura;
  final String? situacaoAtual;
  final String? nomeCompleto;
  final String? photoUrl;

  static const String _fieldCirculoAtual = 'circulo_atual';
  static const String _fieldLegislatura = 'legislatura';
  static const String _fieldSituacaoAtual = 'situacao_atual';
  static const String _fieldNomeCompleto = 'nome_completo';
  static const String _fieldPhotoUrl = 'url_foto';

  factory Deputy.fromJson(Map<String, dynamic> json) {
    return Deputy(
      depCadId: (json[ApiConstants.fieldDepCadId] as num).toInt(),
      nomeParlamentar: json[ApiConstants.fieldNomeParlamentar] as String,
      partidoAtual: json[ApiConstants.fieldPartidoAtual] as String,
      circuloAtual: json[_fieldCirculoAtual] as String?,
      legislatura: json[_fieldLegislatura] as String?,
      situacaoAtual: json[_fieldSituacaoAtual] as String?,
      nomeCompleto: json[_fieldNomeCompleto] as String?,
      photoUrl: json[_fieldPhotoUrl] as String?,
    );
  }
}
