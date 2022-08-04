import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockUserInterface extends Mock implements UserInterface {}

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final userInterface = MockUserInterface();
  final achievementsInterface = MockAchievementsInterface();
  final settingsInterface = MockSettingsInterface();
  final useCase = SignOutUseCase(
    authInterface: authInterface,
    userInterface: userInterface,
    achievementsInterface: achievementsInterface,
    settingsInterface: settingsInterface,
  );

  test(
    'should call method responsible for signing out user and methods responsible for resetting repositories',
    () async {
      when(
        () => authInterface.signOut(),
      ).thenAnswer((_) async => '');

      await useCase.execute();

      verify(
        () => authInterface.signOut(),
      ).called(1);
      verify(
        () => userInterface.reset(),
      ).called(1);
      verify(
        () => achievementsInterface.reset(),
      ).called(1);
      verify(
        () => settingsInterface.reset(),
      ).called(1);
    },
  );
}
