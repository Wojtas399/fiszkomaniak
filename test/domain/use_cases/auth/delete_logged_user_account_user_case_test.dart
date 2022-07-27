import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/delete_logged_user_account_use_case.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';

class MockUserInterface extends Mock implements UserInterface {}

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final userInterface = MockUserInterface();
  final authInterface = MockAuthInterface();
  final useCase = DeleteLoggedUserAccountUseCase(
    userInterface: userInterface,
    authInterface: authInterface,
  );

  test(
    'should call methods responsible for reauthentication, deleting avatar, deleting all user data and for deleting user from auth repo. Additionally, should reset all repositories',
    () async {
      when(
        () => authInterface.reauthenticate(password: 'password'),
      ).thenAnswer((_) async => '');
      when(() => userInterface.deleteAvatar()).thenAnswer((_) async => '');
      when(() => userInterface.deleteAllUserData()).thenAnswer((_) async => '');
      when(
        () => authInterface.deleteLoggedUserAccount(),
      ).thenAnswer((_) async => '');

      await useCase.execute(password: 'password');

      verify(
        () => authInterface.reauthenticate(password: 'password'),
      ).called(1);
      verify(() => userInterface.deleteAvatar()).called(1);
      verify(() => userInterface.deleteAllUserData()).called(1);
      verify(() => authInterface.deleteLoggedUserAccount()).called(1);
      verify(() => userInterface.reset()).called(1);
    },
  );
}
