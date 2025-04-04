// widgets/theme_toggle.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return IconButton(
      icon: Icon(theme == 'dark' ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
    );
  }
}
