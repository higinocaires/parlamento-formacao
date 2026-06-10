import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlamento_pt/core/theme/app_theme.dart';
import 'package:parlamento_pt/core/theme/theme_mode_provider.dart';
import 'package:parlamento_pt/features/deputies/presentation/screens/deputies_list_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Parlamento PT',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const DeputiesListScreen(),
    );
  }
}
