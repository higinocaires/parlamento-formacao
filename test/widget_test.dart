import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:parlamento_pt/core/app.dart';

void main() {
  testWidgets('App launches with deputies screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text('Deputados'), findsOneWidget);
  });
}
