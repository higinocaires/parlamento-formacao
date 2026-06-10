import 'package:go_router/go_router.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/presentation/screens/deputies_list_screen.dart';
import 'package:parlamento_pt/features/deputies/presentation/screens/deputy_detail_screen.dart';

/// Creates the app [GoRouter], optionally injecting a [repository] for tests.
GoRouter createAppRouter({DeputiesRepository? repository}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DeputiesListScreen(),
      ),
      GoRoute(
        path: '/deputado/:depCadId',
        builder: (context, state) {
          final depCadId = int.parse(state.pathParameters['depCadId']!);
          return DeputyDetailScreen(
            depCadId: depCadId,
            repository: repository,
          );
        },
      ),
    ],
  );
}

final GoRouter appRouter = createAppRouter();
