import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:parlamento_pt/core/constants/api_constants.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';

void main() {
  group('DeputiesRepository', () {
    test('fetchAllDeputies merges all paginated pages', () async {
      final page1 = {
        'data': [
          {
            'dep_cad_id': 1,
            'nome_parlamentar': 'Deputy One',
            'partido_atual': 'PS',
          },
          {
            'dep_cad_id': 2,
            'nome_parlamentar': 'Deputy Two',
            'partido_atual': 'PSD',
          },
        ],
        'pagination': {'limit': 2, 'offset': 0, 'total': 3},
      };
      final page2 = {
        'data': [
          {
            'dep_cad_id': 3,
            'nome_parlamentar': 'Deputy Three',
            'partido_atual': 'CH',
          },
        ],
        'pagination': {'limit': 2, 'offset': 2, 'total': 3},
      };

      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        final offset = request.url.queryParameters['offset'];
        if (offset == '0') {
          return http.Response(jsonEncode(page1), 200);
        }
        if (offset == '2') {
          return http.Response(jsonEncode(page2), 200);
        }
        return http.Response(jsonEncode(_emptyPage()), 200);
      });

      final repository = DeputiesRepository(client: client);
      final deputies = await repository.fetchAllDeputies();

      expect(requestCount, 2);
      expect(deputies, hasLength(3));
      expect(deputies.first.nomeParlamentar, 'Deputy One');
      expect(deputies.last.nomeParlamentar, 'Deputy Three');
    });

    test('fetchAllDeputies uses ApiConstants query parameters', () async {
      Uri? requestedUri;
      final client = MockClient((request) async {
        requestedUri = request.url;
        return http.Response(jsonEncode(_singleDeputyPage()), 200);
      });

      final repository = DeputiesRepository(client: client);
      await repository.fetchAllDeputies();

      expect(requestedUri, isNotNull);
      expect(requestedUri!.queryParameters['legislatura'], ApiConstants.legislatura);
      expect(requestedUri!.queryParameters['situacao'], ApiConstants.situacao);
      expect(
        requestedUri!.queryParameters['limit'],
        '${ApiConstants.pageSize}',
      );
      expect(requestedUri!.queryParameters['offset'], '0');
    });

    test('fetchAllDeputies throws on non-200 response', () async {
      final client = MockClient(
        (_) async => http.Response('Server error', 500),
      );

      final repository = DeputiesRepository(client: client);

      expect(
        repository.fetchAllDeputies(),
        throwsA(
          isA<DeputiesRepositoryException>().having(
            (error) => error.message,
            'message',
            contains('HTTP 500'),
          ),
        ),
      );
    });

    test('fetchDeputy parses detail response', () async {
      const detail = {
        'legislatura': 'L17',
        'dep_cad_id': 7489.0,
        'nome_parlamentar': 'Adriana Rodrigues',
        'nome_completo': 'Adriana Helena da Silva Rodrigues',
        'circulo_atual': 'Aveiro',
        'partido_atual': 'PSD',
        'situacao_atual': 'Efetivo',
      };

      final client = MockClient(
        (_) async => http.Response(jsonEncode(detail), 200),
      );

      final repository = DeputiesRepository(client: client);
      final deputy = await repository.fetchDeputy(7489);

      expect(deputy.depCadId, 7489);
      expect(deputy.nomeParlamentar, 'Adriana Rodrigues');
      expect(deputy.circuloAtual, 'Aveiro');
    });

    test('fetchIniciativas parses first page', () async {
      final page = {
        'data': [
          {
            'ini_id': '356662',
            'ini_nr': '900',
            'legislatura': 'L17',
            'ini_tipo': 'R',
            'ini_desc_tipo': 'Projeto de Resolução',
            'ini_titulo': 'Primeira iniciativa',
            'autor_gp': null,
          },
        ],
        'pagination': {'limit': 50, 'offset': 0, 'total': 1},
      };

      final client = MockClient(
        (_) async => http.Response(jsonEncode(page), 200),
      );

      final repository = DeputiesRepository(client: client);
      final iniciativas = await repository.fetchIniciativas(7489);

      expect(iniciativas, hasLength(1));
      expect(iniciativas.first.titulo, 'Primeira iniciativa');
    });

    test('fetchAllDeputies throws on invalid JSON', () async {
      final client = MockClient(
        (_) async => http.Response('not json', 200),
      );

      final repository = DeputiesRepository(client: client);

      expect(
        repository.fetchAllDeputies(),
        throwsA(
          isA<DeputiesRepositoryException>().having(
            (error) => error.message,
            'message',
            contains('Failed to parse'),
          ),
        ),
      );
    });
  });
}

Map<String, dynamic> _singleDeputyPage() {
  return {
    'data': [
      {
        'dep_cad_id': 1,
        'nome_parlamentar': 'Deputy One',
        'partido_atual': 'PS',
      },
    ],
    'pagination': {'limit': 50, 'offset': 0, 'total': 1},
  };
}

Map<String, dynamic> _emptyPage() {
  return {
    'data': <dynamic>[],
    'pagination': {'limit': 50, 'offset': 0, 'total': 0},
  };
}
