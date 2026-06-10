import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/domain/iniciativa.dart';
import 'package:parlamento_pt/features/deputies/domain/iniciativas_page.dart';

void main() {
  group('Iniciativa', () {
    test('fromJson parses fields from API sample', () {
      const json = {
        'ini_id': '356662',
        'ini_nr': '900',
        'legislatura': 'L17',
        'ini_tipo': 'R',
        'ini_desc_tipo': 'Projeto de Resolução',
        'ini_titulo':
            'Recomenda ao Governo a criação e implementação do Programa mente forte',
        'autor_gp': null,
      };

      final iniciativa = Iniciativa.fromJson(json);

      expect(iniciativa.id, '356662');
      expect(iniciativa.numero, '900');
      expect(iniciativa.legislatura, 'L17');
      expect(iniciativa.tipo, 'R');
      expect(iniciativa.descricaoTipo, 'Projeto de Resolução');
      expect(
        iniciativa.titulo,
        contains('Programa mente forte'),
      );
      expect(iniciativa.autorGp, isNull);
      expect(iniciativa.subtitle, 'Projeto de Resolução · n.º 900');
    });
  });

  group('IniciativasPage', () {
    test('fromJson extracts iniciativas and pagination', () {
      const json = {
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
          {
            'ini_id': '356661',
            'ini_nr': '899',
            'legislatura': 'L17',
            'ini_tipo': 'R',
            'ini_desc_tipo': 'Projeto de Resolução',
            'ini_titulo': 'Segunda iniciativa',
            'autor_gp': null,
          },
        ],
        'pagination': {'limit': 3, 'offset': 0, 'total': 6},
      };

      final page = IniciativasPage.fromJson(json);

      expect(page.iniciativas, hasLength(2));
      expect(page.iniciativas.first.titulo, 'Primeira iniciativa');
      expect(page.limit, 3);
      expect(page.offset, 0);
      expect(page.total, 6);
    });
  });
}
