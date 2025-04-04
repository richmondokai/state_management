// test/providers/auth_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assessment3/models/user.dart';
import 'package:flutter_assessment3/providers/auth_provider.dart';
import 'package:flutter_assessment3/services/shared_preferences_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

void main() {
  late AuthNotifier authNotifier;
  late MockSharedPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferencesService();
    authNotifier = AuthNotifier(mockPrefs);
  });

  test('initial state is logged out', () {
    expect(authNotifier.state.isLoggedIn, false);
    expect(authNotifier.state.user, null);
  });

  test('login updates state and saves to prefs', () async {
    final user = User(name: 'Test', email: 'test@example.com');
    when(
      () => mockPrefs.setBool('isLoggedIn', true),
    ).thenAnswer((_) async => true);
    when(
      () => mockPrefs.setString('userName', user.name),
    ).thenAnswer((_) async => true);
    when(
      () => mockPrefs.setString('userEmail', user.email),
    ).thenAnswer((_) async => true);

    await authNotifier.login(user);

    expect(authNotifier.state.isLoggedIn, true);
    expect(authNotifier.state.user, user);
    verify(() => mockPrefs.setBool('isLoggedIn', true)).called(1);
  });
}
