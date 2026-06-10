/// Constants and URL helpers for the
/// [votoaberto API](https://api.votoaberto.org/api/v1).
///
/// Relevant JSON field names on deputy list/detail responses:
/// - [fieldNomeParlamentar] — display name
/// - [fieldPartidoAtual] — current party acronym
/// - [fieldDepCadId] — deputy cadastral ID (used in detail and iniciativas URLs)
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.votoaberto.org/api/v1';

  static const String legislatura = 'L17';
  static const String situacao = 'Efetivo';
  static const int pageSize = 50;

  /// Deputy display name (`nome_parlamentar`).
  static const String fieldNomeParlamentar = 'nome_parlamentar';

  /// Current party acronym (`partido_atual`).
  static const String fieldPartidoAtual = 'partido_atual';

  /// Deputy cadastral ID (`dep_cad_id`).
  static const String fieldDepCadId = 'dep_cad_id';

  /// Paginated deputies list for the current legislature and situation.
  ///
  /// Example: `/deputados?legislatura=L17&situacao=Efetivo&limit=50&offset=0`
  static String deputiesListPageUrl({int offset = 0, int? limit}) {
    return Uri.parse('$baseUrl/deputados')
        .replace(
          queryParameters: {
            'legislatura': legislatura,
            'situacao': situacao,
            'limit': '${limit ?? pageSize}',
            'offset': '$offset',
          },
        )
        .toString();
  }

  /// Single deputy detail by cadastral ID.
  ///
  /// Example: `/deputados/7489?legislatura=L17`
  static String deputyDetailUrl(int depCadId) {
    return Uri.parse('$baseUrl/deputados/$depCadId')
        .replace(
          queryParameters: {'legislatura': legislatura},
        )
        .toString();
  }

  /// Deputy legislative initiatives (paginated).
  ///
  /// Example:
  /// `/deputados/7489/iniciativas?legislatura=L17&limit=50&offset=0`
  static String deputyIniciativasUrl(
    int depCadId, {
    int offset = 0,
    int? limit,
  }) {
    return Uri.parse('$baseUrl/deputados/$depCadId/iniciativas')
        .replace(
          queryParameters: {
            'legislatura': legislatura,
            'limit': '${limit ?? pageSize}',
            'offset': '$offset',
          },
        )
        .toString();
  }
}
