// Quick terminal demo — same API call as the list_deputies MCP tool.
// Run: dart run bin/demo_list.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  const url =
      'https://api.votoaberto.org/api/v1/deputados'
      '?legislatura=L17&situacao=Efetivo&limit=3&offset=0';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    stderr.writeln('HTTP ${response.statusCode}');
    exit(1);
  }

  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final total =
      (json['pagination'] as Map<String, dynamic>?)?['total'] ?? '?';
  final data = json['data'] as List<dynamic>? ?? [];

  stdout.writeln('Total na API: $total deputados efetivos (mostrados ${data.length}).\n');

  for (final item in data) {
    final map = item as Map<String, dynamic>;
    final id = map['dep_cad_id'];
    final name = map['nome_parlamentar'];
    final party = map['partido_atual'];
    stdout.writeln('$id · $name · $party');
  }
}
