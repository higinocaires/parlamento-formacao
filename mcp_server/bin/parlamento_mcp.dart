import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mcp_dart/mcp_dart.dart';

const _apiBase = 'https://api.votoaberto.org/api/v1';
const _legislatura = 'L17';
const _situacao = 'Efetivo';

Future<Map<String, dynamic>?> _getJson(
  String path, {
  Map<String, String> query = const {},
}) async {
  final uri = Uri.parse('$_apiBase$path').replace(
    queryParameters: {
      'legislatura': _legislatura,
      ...query,
    },
  );

  try {
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      return null;
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  } on Exception catch (error) {
    stderr.writeln('API error: $error');
    return null;
  }
}

String _deputyLine(Map<String, dynamic> json) {
  final id = (json['dep_cad_id'] as num).toInt();
  final name = json['nome_parlamentar'] as String? ?? '—';
  final party = json['partido_atual'] as String? ?? '—';
  return '$id · $name · $party';
}

Future<void> main() async {
  final server = McpServer(
    const Implementation(name: 'parlamento-mcp', version: '1.0.0'),
  );

  server.registerTool(
    'list_deputies',
    description:
        'List active Portuguese Parliament deputies (legislatura L17).',
    inputSchema: JsonSchema.object(
      properties: {
        'limit': JsonSchema.number(
          description: 'Max deputies to return (default 10, max 50).',
        ),
        'partido': JsonSchema.string(
          description: 'Optional party filter, e.g. PS, PSD, CH.',
        ),
      },
    ),
    callback: (args, extra) async {
      final limit = ((args['limit'] as num?) ?? 10).toInt().clamp(1, 50);
      final partido = (args['partido'] as String?)?.trim();

      final json = await _getJson(
        '/deputados',
        query: {
          'situacao': _situacao,
          'limit': '$limit',
          'offset': '0',
        },
      );

      if (json == null) {
        return const CallToolResult(
          isError: true,
          content: [TextContent(text: 'Failed to fetch deputies.')],
        );
      }

      final data = (json['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();

      final filtered = partido == null || partido.isEmpty
          ? data
          : data
              .where(
                (item) =>
                    (item['partido_atual'] as String? ?? '')
                        .toUpperCase() ==
                    partido.toUpperCase(),
              )
              .toList();

      if (filtered.isEmpty) {
        return CallToolResult.fromContent(
          [
            TextContent(
              text: partido == null
                  ? 'No deputies found.'
                  : 'No deputies found for party $partido.',
            ),
          ],
        );
      }

      final lines = filtered.map(_deputyLine).join('\n');
      return CallToolResult.fromContent(
        [TextContent(text: 'Deputados (L17):\n$lines')],
      );
    },
  );

  server.registerTool(
    'get_deputy',
    description: 'Get one deputy by dep_cad_id from votoaberto.',
    inputSchema: JsonSchema.object(
      properties: {
        'dep_cad_id': JsonSchema.number(
          description: 'Deputy cadastral ID, e.g. 7489.',
        ),
      },
      required: ['dep_cad_id'],
    ),
    callback: (args, extra) async {
      final depCadId = (args['dep_cad_id'] as num?)?.toInt();
      if (depCadId == null) {
        return const CallToolResult(
          isError: true,
          content: [TextContent(text: 'dep_cad_id is required.')],
        );
      }

      final deputyJson = await _getJson('/deputados/$depCadId');
      if (deputyJson == null) {
        return CallToolResult(
          isError: true,
          content: [
            TextContent(text: 'Deputy $depCadId not found or API error.'),
          ],
        );
      }

      final iniciativasJson = await _getJson(
        '/deputados/$depCadId/iniciativas',
        query: {'limit': '5', 'offset': '0'},
      );

      final totalIniciativas =
          (iniciativasJson?['pagination'] as Map<String, dynamic>?)?['total']
              as num?;

      final buffer = StringBuffer()
        ..writeln('Nome: ${deputyJson['nome_parlamentar']}')
        ..writeln('Partido: ${deputyJson['partido_atual']}')
        ..writeln('Círculo: ${deputyJson['circulo_atual'] ?? '—'}')
        ..writeln('ID: $depCadId');

      if (totalIniciativas != null) {
        buffer.writeln('Iniciativas (total): $totalIniciativas');
      }

      return CallToolResult.fromContent(
        [TextContent(text: buffer.toString())],
      );
    },
  );

  await server.connect(StdioServerTransport());
  stderr.writeln('Parlamento MCP server running on stdio');
}
