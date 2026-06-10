import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:parlamento_pt/core/constants/api_constants.dart';
import 'package:parlamento_pt/features/deputies/domain/deputies_page.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';

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
      final page = await _fetchPage(offset);
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

  Future<DeputiesPage> _fetchPage(int offset) async {
    final url = ApiConstants.deputiesListPageUrl(
      offset: offset,
      limit: ApiConstants.pageSize,
    );

    http.Response response;
    try {
      response = await _client.get(Uri.parse(url));
    } on Exception catch (error) {
      throw DeputiesRepositoryException(
        'Network error while fetching deputies: $error',
      );
    }

    if (response.statusCode != 200) {
      throw DeputiesRepositoryException(
        'Failed to fetch deputies (HTTP ${response.statusCode})',
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return DeputiesPage.fromJson(json);
    } on Exception catch (error) {
      throw DeputiesRepositoryException(
        'Failed to parse deputies response: $error',
      );
    }
  }
}
