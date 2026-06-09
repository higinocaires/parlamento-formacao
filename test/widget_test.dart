import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:parlamento_pt/main.dart';

void main() {
  testWidgets('App launches with deputies screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    expect(find.text('Deputados'), findsOneWidget);
  });
}
