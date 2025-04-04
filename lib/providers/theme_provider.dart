// providers/theme_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shared_preferences_service.dart';

class ThemeNotifier extends StateNotifier<String> {
  final SharedPreferencesService prefsService;

  ThemeNotifier(this.prefsService) : super('light') {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    await prefsService.init();
    state = prefsService.getString('theme') ?? 'light';
  }

  Future<void> toggleTheme() async {
    state = state == 'light' ? 'dark' : 'light';
    await prefsService.setString('theme', state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, String>((ref) {
  final prefsService = SharedPreferencesService();
  return ThemeNotifier(prefsService);
});
