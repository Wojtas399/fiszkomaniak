import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockUserInterface extends Mock implements UserInterface {}

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

class MockAppearanceSettingsInterface extends Mock
    implements AppearanceSettingsInterface {}

class MockNotificationsSettingsInterface extends Mock
    implements NotificationsSettingsInterface {}

void main() {
  final authInterface = MockAuthInterface();
  final userInterface = MockUserInterface();
  final achievementsInterface = MockAchievementsInterface();
  final appearanceSettingsInterface = MockAppearanceSettingsInterface();
  final notificationsSettingsInterface = MockNotificationsSettingsInterface();
  final useCase = SignUpUseCase(
    authInterface: authInterface,
    userInterface: userInterface,
    achievementsInterface: achievementsInterface,
    appearanceSettingsInterface: appearanceSettingsInterface,
    notificationsSettingsInterface: notificationsSettingsInterface,
  );

  test(
    'should call methods responsible for signing up user, adding basic user info and methods responsible for initializing achievements stats, appearance settings and notifications settings',
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
        () => appearanceSettingsInterface.setDefaultSettings(),
      ).thenAnswer((_) async => '');
      when(
        () => notificationsSettingsInterface.setDefaultSettings(),
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
        () => appearanceSettingsInterface.setDefaultSettings(),
      ).called(1);
      verify(
        () => notificationsSettingsInterface.setDefaultSettings(),
      ).called(1);
    },
  );
}
