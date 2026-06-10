import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:parlamento_pt/core/constants/api_constants.dart';
import 'package:parlamento_pt/features/deputies/domain/deputies_page.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/domain/iniciativa.dart';
import 'package:parlamento_pt/features/deputies/domain/iniciativas_page.dart';

/// Thrown when fetching or parsing deputies data fails.
class DeputiesRepositoryException implements Exception {
  DeputiesRepositoryException(this.message);

  final String message;

  @override
  String toString() => 'DeputiesRepositoryException: $message';
}

/// Fetches deputies from the votoaberto API.
class DeputiesRepository {
  DeputiesRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Loads every page of active deputies for the configured legislature.
  Future<List<Deputy>> fetchAllDeputies() async {
    final allDeputies = <Deputy>[];
    var offset = 0;

    while (true) {
      final page = await _fetchDeputiesPage(offset);
      if (page.deputies.isEmpty) {
        break;
      }

      allDeputies.addAll(page.deputies);
      offset += page.deputies.length;

      if (allDeputies.length >= page.total) {
        break;
      }
    }

    return allDeputies;
  }

  /// Fetches a single deputy by cadastral ID.
  Future<Deputy> fetchDeputy(int depCadId) async {
    final url = ApiConstants.deputyDetailUrl(depCadId);
    final json = await _getJson(url, 'deputy');
    return Deputy.fromJson(json);
  }

  /// Fetches the first page of iniciativas for a deputy.
  Future<List<Iniciativa>> fetchIniciativas(int depCadId) async {
    final url = ApiConstants.deputyIniciativasUrl(depCadId);
    final json = await _getJson(url, 'iniciativas');
    return IniciativasPage.fromJson(json).iniciativas;
  }

  Future<DeputiesPage> _fetchDeputiesPage(int offset) async {
    final url = ApiConstants.deputiesListPageUrl(
      offset: offset,
      limit: ApiConstants.pageSize,
    );
    final json = await _getJson(url, 'deputies');
    return DeputiesPage.fromJson(json);
  }

  Future<Map<String, dynamic>> _getJson(String url, String resource) async {
    http.Response response;
    try {
      response = await _client.get(Uri.parse(url));
    } on Exception catch (error) {
      throw DeputiesRepositoryException(
        'Network error while fetching $resource: $error',
      );
    }

    if (response.statusCode != 200) {
      throw DeputiesRepositoryException(
        'Failed to fetch $resource (HTTP ${response.statusCode})',
      );
    }

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on Exception catch (error) {
      throw DeputiesRepositoryException(
        'Failed to parse $resource response: $error',
      );
    }
  }
}
