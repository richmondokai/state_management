// providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/shared_preferences_service.dart';

class AuthState {
  final bool isLoggedIn;
  final User? user;

  AuthState({this.isLoggedIn = false, this.user});

  AuthState copyWith({bool? isLoggedIn, User? user}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SharedPreferencesService prefsService;

  AuthNotifier(this.prefsService) : super(AuthState()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    await prefsService.init();
    final isLoggedIn = prefsService.getBool('isLoggedIn') ?? false;
    final userName = prefsService.getString('userName');
    final userEmail = prefsService.getString('userEmail');

    if (isLoggedIn && userName != null && userEmail != null) {
      state = AuthState(
        isLoggedIn: true,
        user: User(name: userName, email: userEmail),
      );
    }
  }

  Future<void> login(User user) async {
    await prefsService.setBool('isLoggedIn', true);
    await prefsService.setString('userName', user.name);
    await prefsService.setString('userEmail', user.email);

    state = AuthState(isLoggedIn: true, user: user);
  }

  Future<void> logout() async {
    await prefsService.remove('isLoggedIn');
    await prefsService.remove('userName');
    await prefsService.remove('userEmail');

    state = AuthState(isLoggedIn: false, user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefsService = SharedPreferencesService();
  return AuthNotifier(prefsService);
});
