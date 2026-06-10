import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/domain/deputies_page.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';

void main() {
  group('Deputy', () {
    test('fromJson parses required and optional fields', () {
      const json = {
        'legislatura': 'L17',
        'dep_cad_id': 7489.0,
        'nome_parlamentar': 'Adriana Rodrigues',
        'nome_completo': 'Adriana Helena da Silva Rodrigues',
        'circulo_atual': 'Aveiro',
        'partido_atual': 'PSD',
        'situacao_atual': 'Efetivo',
      };

      final deputy = Deputy.fromJson(json);

      expect(deputy.depCadId, 7489);
      expect(deputy.nomeParlamentar, 'Adriana Rodrigues');
      expect(deputy.partidoAtual, 'PSD');
      expect(deputy.circuloAtual, 'Aveiro');
      expect(deputy.legislatura, 'L17');
      expect(deputy.situacaoAtual, 'Efetivo');
      expect(deputy.nomeCompleto, 'Adriana Helena da Silva Rodrigues');
      expect(deputy.photoUrl, isNull);
    });

    test('fromJson parses photo URL when present', () {
      const json = {
        'dep_cad_id': 1,
        'nome_parlamentar': 'Test Deputy',
        'partido_atual': 'PS',
        'url_foto': 'https://example.com/photo.jpg',
      };

      final deputy = Deputy.fromJson(json);

      expect(deputy.photoUrl, 'https://example.com/photo.jpg');
    });
  });

  group('DeputiesPage', () {
    test('fromJson extracts deputies and pagination', () {
      const json = {
        'data': [
          {
            'legislatura': 'L17',
            'dep_cad_id': 7489.0,
            'nome_parlamentar': 'Adriana Rodrigues',
            'circulo_atual': 'Aveiro',
            'partido_atual': 'PSD',
            'situacao_atual': 'Efetivo',
          },
          {
            'legislatura': 'L17',
            'dep_cad_id': 9194.0,
            'nome_parlamentar': 'Aida Carvalho',
            'circulo_atual': 'Guarda',
            'partido_atual': 'PS',
            'situacao_atual': 'Efetivo',
          },
        ],
        'pagination': {'limit': 50, 'offset': 0, 'total': 200},
      };

      final page = DeputiesPage.fromJson(json);

      expect(page.deputies, hasLength(2));
      expect(page.deputies.first.nomeParlamentar, 'Adriana Rodrigues');
      expect(page.deputies.last.partidoAtual, 'PS');
      expect(page.limit, 50);
      expect(page.offset, 0);
      expect(page.total, 200);
    });
  });
}
