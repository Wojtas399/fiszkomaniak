import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockUserInterface extends Mock implements UserInterface {}

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final userInterface = MockUserInterface();
  final achievementsInterface = MockAchievementsInterface();
  final settingsInterface = MockSettingsInterface();
  final useCase = SignUpUseCase(
    authInterface: authInterface,
    userInterface: userInterface,
    achievementsInterface: achievementsInterface,
    settingsInterface: settingsInterface,
  );

  test(
    'should call methods responsible for signing up user, adding basic user info and methods responsible for initializing achievements and setting default settings',
    () async {
      when(
        () => authInterface.signUp(email: 'email', password: 'password'),
      ).thenAnswer((_) async => 'u1');
      when(
        () => userInterface.addUserData(userId: 'u1', username: 'username'),
      ).thenAnswer((_) async => '');
      when(
        () => achievementsInterface.setInitialAchievements(),
      ).thenAnswer((_) async => '');
      when(
        () => settingsInterface.setDefaultSettings(),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        username: 'username',
        email: 'email',
        password: 'password',
      );

      verify(
        () => authInterface.signUp(email: 'email', password: 'password'),
      ).called(1);
      verify(
        () => userInterface.addUserData(userId: 'u1', username: 'username'),
      ).called(1);
      verify(
        () => achievementsInterface.setInitialAchievements(),
      ).called(1);
      verify(
        () => settingsInterface.setDefaultSettings(),
      ).called(1);
    },
  );
}
