import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/core/app.dart';
import 'package:parlamento_pt/core/router/app_router.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/domain/iniciativa.dart';
import 'package:parlamento_pt/features/deputies/presentation/screens/deputies_list_screen.dart';
import 'package:parlamento_pt/features/deputies/presentation/screens/deputy_detail_screen.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';

void main() {
  group('DeputiesListScreen Widget Tests', () {
    testWidgets('shows loading indicator while fetching deputies', (
      WidgetTester tester,
    ) async {
      final completer = Completer<List<Deputy>>();
      addTearDown(() {
        if (!completer.isCompleted) {
          completer.complete(const []);
        }
      });
      final repository = _FakeDeputiesRepository(completer: completer);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DeputiesListScreen(repository: repository),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Deputados'), findsOneWidget);
    });

    testWidgets('renders list of deputies from repository', (
      WidgetTester tester,
    ) async {
      final repository = _FakeDeputiesRepository(
        deputies: const [
          Deputy(
            depCadId: 1,
            nomeParlamentar: 'Luís Montenegro',
            partidoAtual: 'PSD',
          ),
          Deputy(
            depCadId: 2,
            nomeParlamentar: 'Pedro Nuno Santos',
            partidoAtual: 'PS',
          ),
          Deputy(
            depCadId: 3,
            nomeParlamentar: 'André Ventura',
            partidoAtual: 'CH',
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DeputiesListScreen(repository: repository),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Deputados'), findsOneWidget);
      expect(find.byType(DeputyCard), findsNWidgets(3));
      expect(find.text('Luís Montenegro'), findsOneWidget);
      expect(find.text('Pedro Nuno Santos'), findsOneWidget);
      expect(find.text('André Ventura'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (
      WidgetTester tester,
    ) async {
      final repository = _FakeDeputiesRepository(
        error: DeputiesRepositoryException('Falha de rede'),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DeputiesListScreen(repository: repository),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Falha de rede'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
    });

    testWidgets('shows empty state when repository returns no deputies', (
      WidgetTester tester,
    ) async {
      final repository = _FakeDeputiesRepository();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DeputiesListScreen(repository: repository),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nenhum deputado encontrado'), findsOneWidget);
    });

    testWidgets('navigates to detail when deputy card is tapped', (
      WidgetTester tester,
    ) async {
      const deputy = Deputy(
        depCadId: 42,
        nomeParlamentar: 'Luís Montenegro',
        partidoAtual: 'PSD',
        circuloAtual: 'Braga',
        nomeCompleto: 'Luís Montenegro Completo',
      );
      const iniciativa = Iniciativa(
        id: '1',
        numero: '900',
        titulo: 'Iniciativa de teste',
        descricaoTipo: 'Projeto de Resolução',
      );

      final repository = _FakeDeputiesRepository(
        deputies: const [deputy],
        deputyDetail: deputy,
        iniciativas: const [iniciativa],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: createAppRouter(repository: repository),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Luís Montenegro'));
      await tester.pumpAndSettle();

      expect(find.byType(DeputyDetailScreen), findsOneWidget);
      expect(find.text('Iniciativas'), findsOneWidget);
      expect(find.text('Iniciativa de teste'), findsOneWidget);
      expect(find.text('Círculo: Braga'), findsOneWidget);
    });

    testWidgets('toggles theme mode with switch', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: App(),
        ),
      );

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      expect(tester.widget<Switch>(switchFinder).value, isFalse);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(switchFinder).value, isTrue);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });
  });
}

class _FakeDeputiesRepository extends DeputiesRepository {
  _FakeDeputiesRepository({
    this.deputies = const [],
    this.deputyDetail,
    this.iniciativas = const [],
    this.completer,
    this.error,
  });

  final List<Deputy> deputies;
  final Deputy? deputyDetail;
  final List<Iniciativa> iniciativas;
  final Completer<List<Deputy>>? completer;
  final Object? error;

  @override
  Future<List<Deputy>> fetchAllDeputies() {
    if (completer != null) {
      return completer!.future;
    }
    if (error != null) {
      return Future<List<Deputy>>.error(error!);
    }
    return Future<List<Deputy>>.value(deputies);
  }

  @override
  Future<Deputy> fetchDeputy(int depCadId) async {
    if (error != null) {
      throw error!;
    }
    return deputyDetail ??
        Deputy(
          depCadId: depCadId,
          nomeParlamentar: 'Deputado $depCadId',
          partidoAtual: 'PS',
        );
  }

  @override
  Future<List<Iniciativa>> fetchIniciativas(int depCadId) async {
    if (error != null) {
      throw error!;
    }
    return iniciativas;
  }
}
